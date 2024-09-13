//This file is in Branch "reg_io"

//test git pull
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    
    parameter idle = 'd0,in1 = 'd1,fivein1 = 'd2,DISC = 'd3,FLAG = 'd4,ERR = 'd5,sixin1 = 'd6;
    reg [2:0] state,next_state;
    reg [2:0]cnt;
    always@(posedge clk)begin
        if(state == in1)begin
            if(in)
            	cnt <= cnt+1;
            else
                cnt <= 0;
        end
        else begin
            cnt <= 0;
        end
    end
            
    
    always@(*)begin
        case(state)
            idle:begin
                if(!in)
                    next_state = idle;
                else
                    next_state = in1;
            end
            in1:begin
                if(!in)
                    next_state = idle;
                else begin
                    if(cnt<='d2)
                        next_state = in1;
                    else 
                        next_state = fivein1;
                end
            end
            fivein1:begin
                if(!in)
                    next_state = DISC;
                else
                    next_state = sixin1;
            end
            sixin1:begin
                if(!in)
                    next_state = FLAG;
                else
                    next_state = ERR;
            end
            DISC:begin
                if(!in)
                    next_state = idle;
                else
                    next_state = in1;
            end
            FLAG:begin
                if(!in)
                    next_state = idle;
                else
                    next_state = in1;
            end
            ERR:begin
                if(!in)
                    next_state = idle;
                else
                    next_state = ERR;
            end
            default:next_state = idle;
        endcase
    end
    
    
    always@(posedge clk)begin
        if(reset)
            state <= idle;
        else
            state <= next_state;
    end
    
    
    
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state ==  ERR);
                    
                
    
    
endmodule
//这里在进入in1状态后，需要重复输入若干个1，这时可以用一个计数器cnt来计数in=1的个数，待到目标要求的个数后再进入下一个状态，这样节省状态数；
//还有一种情况，是从一个状态开始进入读取数据的一段状态，这时候也可以利用cnt计数，直到数据都读取完成了就进入下一个状态；
