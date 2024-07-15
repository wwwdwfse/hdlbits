module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    reg [3:0]state,next_state;
    parameter[3:0]idle='d1,d0='d2,d1='d3,d2='d4,d3='d5,d4='d6,d5='d7,d6='d8,d7='d9,Done='d10,start='d11,error='d12;
    
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
                	next_state =idle ;
            end
            default:next_state = idle;    
        endcase
    end
    
    always@(posedge clk)
        begin
            if(reset)
                state<=idle;
            else
                state<=next_state;
        end
    
    assign done = (state == Done);
    
    

endmodule
