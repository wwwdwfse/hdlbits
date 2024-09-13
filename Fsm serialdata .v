//This file is in branch "reg_io"




module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //
    reg [7:0] inbyte;
    
    parameter [3:0] idle = 'd1,start = 'd2,d0 = 'd3,d1 = 'd4,d2 = 'd5,d3 = 'd6,d4 = 'd7,d5 = 'd8;
    parameter [3:0] d6 = 'd9,d7 = 'd10,error = 'd11,Done = 'd12;
    reg [3:0] state,next_state;
    
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
            d7:begin
                if(in)
                	next_state = Done;
                else
                    next_state = error;
            end
            error:begin
                if(in)
                    next_state = idle;
                else
                    next_state = error;
            end
            Done:begin
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
        		//
            end
        else
            begin
           		state <= next_state;
        		//
            end
    end
    
    always@(posedge clk)begin
        if(reset)
            inbyte <= 8'b0;
        else begin
            if(!((state == idle)|(state == error)|(state == Done)|(state == d7)))
           		inbyte <= {in,inbyte[7:1]};
        end
    end
            
            
    
    assign out_byte = (state == Done)?inbyte:8'bxxxx_xxxx;
    assign done = (state == Done);
    

endmodule
