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
    
    
    
    
    
    parameter left=3'b000,right=3'b001,left_fall=3'b010,right_fall=3'b011;
    parameter dig_left=3'b100,dig_right=3'b101,die = 3'b110;
    reg [2:0] state,next_state;
    int i;
    reg splat;
    
    
    
    
    
    always@(posedge clk,posedge areset)begin
        if(areset)
            i <= 0;
        else begin
            if(!ground)
                i <= i+1;
            else
                i = 0;
        end
    end  
 
    always@(posedge clk,posedge areset)begin
        if(areset)
            splat <= 0;
        else begin
            if(i=='d20)
                splat <= 1;
        end
    end
    
    
    
    
    
    
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
           if(ground)begin
               if(!splat)
                   next_state = left;
               else
                   next_state = die;
           end
           else
               next_state = left_fall;
       end
       right_fall:begin
           if(ground)begin
               if(!splat)
                   next_state = right;
               else
                   next_state = die;
           end
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
       die:next_state = die;
       default:next_state = left;
        endcase
    end
    
    
    
    
    
    
    always@(posedge clk,posedge areset)begin
        if(areset)begin
            state <= left;
        end
        else
            state <= next_state;
    end
    
    
    
    
    
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
    
  
    
    always@(*)begin
            if((state == left))
                walk_left = 1;
            else 
                walk_left = 0;
    end
    
    always@(*)begin
            if((state == right))
                walk_right = 1;
            else 
                walk_right = 0;
    end
            
            
            

endmodule
