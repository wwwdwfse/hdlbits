//This file is in branch "reg_io"




module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    parameter left=3'b000,right=3'b001,left_fall=3'b010,right_fall=3'b011,dig_left=3'b100,dig_right=3'b101;
    reg [2:0] state,next_state;
    
    always@(*)begin
        case(state)
       left:begin
               if(!ground)
                    next_state = left_fall;
                else begin
                    if(dig)
                        next_state = dig_left;
                    else if(bump_left)
                        next_state = right;
                    else
                        next_state = left;
                end
       end
       right:begin
           if(!ground)
               next_state = right_fall;
           else begin
               if(dig)
                   next_state = dig_right;
               else if(bump_right)
                   next_state = left;
               else
                   next_state = right;
           end
       end
       left_fall:begin
           if(ground)
               next_state = left;
           else
               next_state = left_fall;
       end
       right_fall:begin
           if(ground)
               next_state = right;
           else
               next_state = right_fall;
       end
       dig_left:begin
           if(!ground)
               next_state = left_fall;
           else
               next_state = dig_left;
       end
       dig_right:begin
           if(!ground)
               next_state = right_fall;
           else
               next_state = dig_right;
       end
       default:next_state = left;
        endcase
    end
    
    
    always@(posedge clk,posedge areset)begin
        if(areset)
            state = left;
        else
            state = next_state;
    end
    
    assign walk_left = (state == left);
    assign walk_right = (state == right);
    always@(*)begin
        if((state==left_fall)|(state==right_fall))
            aaah = 1'b1;
        else
            aaah = 1'b0;
    end
    always@(*)begin
        if((state==dig_left)|(state==dig_right))
            digging = 1'b1;
        else
            digging = 1'b0;
    end
                        
endmodule
