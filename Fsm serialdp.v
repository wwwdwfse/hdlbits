module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); 
    
    
    reg [7:0] inbyte;
    reg odd;
    parameter [3:0] idle = 'd1,start = 'd2,d0 = 'd3,d1 = 'd4,d2 = 'd5,d3 = 'd6,d4 = 'd7,d5 = 'd8;
    parameter [3:0] d6 = 'd9,d7 = 'd10,parity_bit = 'd11,miss = 'd12,Done = 'd13,error = 'd14;
    reg [3:0] state,next_state;
    
    
    
   always@(posedge clk)begin
        if(reset)
            odd = 1'b0;
        else begin
            if(!((state == idle)|(state == parity_bit)|(state == miss)|(state == Done)|(state == error)))
               begin
                   if(in)
                       odd<=~odd;
                   else
                       odd<=odd;
               end
            else
                odd<=1'b0;
        end
    end  
    
  
    
    always@(*)begin
        case(state)
            idle:begin
                if(!in)
                    next_state = start;
                else
                    next_state = idle;
            end
            start:next_state = d0;
            d0:next_state = d1;
            d1:next_state = d2;
            d2:next_state = d3;
            d3:next_state = d4;
            d4:next_state = d5;
            d5:next_state = d6;
            d6:next_state = d7;
            d7:next_state = parity_bit;
            parity_bit:begin
                if(!in)
                		next_state = miss;
                else begin
                    if(odd==1'b1)
                        next_state = Done;
                	else
                        next_state = error;
                end
            end
            miss:begin
                if(in)
                    next_state = idle;
                else
                    next_state = miss;
            end
            Done:begin
                if(!in)
                    next_state = start;
                else
                    next_state = idle;
            end
            error:begin
                if(!in)
                    next_state = start;
                else
                    next_state = idle;
            end
        endcase
    end
    
    
    
    always@(posedge clk)begin
        if(reset)
            begin
            	state <= idle;
            end
        else
            begin
           		state <= next_state;
            end
    end
    
    
    
    always@(posedge clk)begin
        if(reset)
            inbyte <= 8'b0;
        else begin
            if(!((state == idle)|(state == miss)|(state == Done)|(state == d7)|(state == parity_bit)))
           		inbyte <= {in,inbyte[7:1]};
        end
    end
            
            
    
    assign out_byte = (state == Done)?inbyte:8'bxxxx_xxxx;
    assign done = (state == Done);

endmodule
//1.状态设置有点臃肿，尤其数据传输部分，可以用data加计数器来表示；
//2.搞明白什么条件下要求的是跳转到哪个状态下，这是过关的基础；
//3.时序电路的信号检测要理清楚；
