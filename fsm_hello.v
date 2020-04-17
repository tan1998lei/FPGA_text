`timescale 1ns / 1ns

module fsm_hello(
    input sys_clk,
    input reset_n,
    input [7:0]data_in,
    input data_in_valid,
    output reg check_ok
    );
    
    localparam
        CHECK_h  = 5'b00_001,
        CHECK_e  = 5'b00_010,
        CHECK_l1 = 5'b00_100,
        CHECK_l2 = 5'b01_000,    
        CHECK_o  = 5'b10_000;    
   
    reg [4:0]state;//一段式状态机
    
    reg [4:0]pre_state;//两段式和三段式状态机
    reg [4:0]next_state;    
    
    
 /*   
//一段式状态机
    always@(posedge sys_clk or negedge reset_n)
    if(!reset_n)begin
        check_ok <= 1'b0;
        state <= CHECK_h;
    end 
    else begin
        case(state)
            CHECK_h:begin
                check_ok <= 1'b0;
                if(data_in_valid && data_in == "h")
                    state <= CHECK_e;
                else
                    state <= CHECK_h;
            end
            
            CHECK_e:begin
                check_ok <= 1'b0;
                if(data_in_valid && data_in == "e")
                    state <= CHECK_l1;
                else if(data_in_valid && data_in == "h")
                    state <= CHECK_e;
                else if(data_in_valid)
                    state <= CHECK_h;    
                else
                    state <= CHECK_e; 
            end      
            
            CHECK_l1:begin
                check_ok <= 1'b0;
                if(data_in_valid && data_in == "l1")
                    state <= CHECK_l2;
                else if(data_in_valid && data_in == "h")
                    state <= CHECK_e;
                else if(data_in_valid)
                    state <= CHECK_h;    
                else
                    state <= CHECK_l1;  
            end     
                           
            CHECK_l2:begin
                check_ok <= 1'b0;
                if(data_in_valid && data_in == "l2")
                    state <= CHECK_o;
                else if(data_in_valid && data_in == "h")
                    state <= CHECK_e;
                else if(data_in_valid)
                    state <= CHECK_h;    
                else
                    state <= CHECK_l2;    
            end   
                         
            CHECK_o:        
                if(data_in_valid && data_in == "h")
                    state <= CHECK_e;                 
                else if(data_in_valid)begin
                    state <= CHECK_h;
                    if(data_in == "o")
                        check_ok <= 1'b1;
                    else
                        check_ok <= 1'b0;                        
                    end  
                else   
                    state <= CHECK_o;    
            default:state <= CHECK_h;
        endcase
    end
 */   
 

//两段式状态机
//第一个过程，同步时序always块，描述状态转移方程
    always@(posedge sys_clk)
    if(!reset_n)
        pre_state <= CHECK_h;
    else 
        pre_state <= next_state;
//第二个过程，组合逻辑always块，描述激励方程以及输出方程        
    always@(pre_state or reset_n)begin  //电平触发，现存状态为敏感信号
    case(pre_state)
        CHECK_h:
            if(!reset_n)begin
                check_ok <= 1'b0;
                next_state <= CHECK_h;
                end 
            else if(data_in_valid && data_in == "h")   
                next_state <= CHECK_e;                
            else
                next_state <= CHECK_h;  
                 
        CHECK_e:
            if(!reset_n)begin
                check_ok <= 1'b0;
                next_state <= CHECK_h;
                end                 
            else if(data_in_valid && data_in == "e")
                next_state <= CHECK_l1;
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;
            else if(data_in_valid)
                next_state <= CHECK_h;    
            else
                next_state <= CHECK_e;    
        
        CHECK_l1:
            if(!reset_n)begin
                check_ok <= 1'b0;
                next_state <= CHECK_h;
                end                   
            else if(data_in_valid && data_in == "l1")
                next_state <= CHECK_l2;
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;
            else if(data_in_valid)
                next_state <= CHECK_h;    
            else
                next_state <= CHECK_l1;    
              
        CHECK_l2:
            if(!reset_n)begin
                check_ok <= 1'b0;
                next_state <= CHECK_h;
                end                 
            else if(data_in_valid && data_in == "l2")
                next_state <= CHECK_o;
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;
            else if(data_in_valid)
                next_state <= CHECK_h;    
            else
                next_state <= CHECK_l2;     
               
        CHECK_o:        
            if(!reset_n)begin
                check_ok <= 1'b0;
                next_state <= CHECK_h;
                end                   
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;                 
            else if(data_in_valid)begin
                next_state <= CHECK_h;
                if(data_in == "o")
                    check_ok <= 1'b1;
                else
                    check_ok <= 1'b0;                        
                end  
            else   
                next_state <= CHECK_o;                   
                 
        default:next_state <= CHECK_h;
    endcase
    end

/*
//三段式状态机    
//第一个过程，同步时序always块，描述状态转移方程
    always@(posedge sys_clk)
    if(!reset_n)
        pre_state <= CHECK_h;
    else 
        pre_state <= next_state;

//第二个过程，组合逻辑always块，描述激励方程
    always@(pre_state or reset_n)begin  //电平触发，现存状态为敏感信号
    case(pre_state)
        CHECK_h:
            if(!reset_n)
                next_state <= CHECK_h;
            else if(data_in_valid && data_in == "h")   
                next_state <= CHECK_e;                
            else
                next_state <= CHECK_h;  
                 
        CHECK_e:
            if(!reset_n)
                next_state <= CHECK_h;             
            else if(data_in_valid && data_in == "e")
                next_state <= CHECK_l1;
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;
            else if(data_in_valid)
                next_state <= CHECK_h;    
            else
                next_state <= CHECK_e;    
        
        CHECK_l1:
            if(!reset_n)
                next_state <= CHECK_h;  
            else if(data_in_valid && data_in == "l1")
                next_state <= CHECK_l2;
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;
            else if(data_in_valid)
                next_state <= CHECK_h;    
            else
                next_state <= CHECK_l1;    
              
        CHECK_l2:
            if(!reset_n)
                next_state <= CHECK_h;    
            else if(data_in_valid && data_in == "l2")
                next_state <= CHECK_o;
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;
            else if(data_in_valid)
                next_state <= CHECK_h;    
            else
                next_state <= CHECK_l2;     
               
        CHECK_o:        
            if(!reset_n)
                next_state <= CHECK_h;        
            else if(data_in_valid && data_in == "h")
                next_state <= CHECK_e;                 
            else if(data_in_valid)
                next_state <= CHECK_h;
            else   
                next_state <= CHECK_o;                   
                 
        default:next_state <= CHECK_h;
    endcase
    end    
 
//第三个always块，描述输出方程     
    always@(pre_state or reset_n)begin  //电平触发，现存状态为敏感信号
    case(pre_state)
        CHECK_h:
            if(!reset_n)
                check_ok <= 1'b0;
                
        CHECK_e:
            if(!reset_n)
                check_ok <= 1'b0;  
        
        CHECK_l1:
            if(!reset_n)
                check_ok <= 1'b0;       
              
        CHECK_l2:
            if(!reset_n)
                check_ok <= 1'b0;         
               
        CHECK_o:        
            if(!reset_n)
                check_ok <= 1'b0;       
            else if(data_in_valid && data_in == "h")
                ;                 
            else if(data_in_valid)begin
                if(data_in == "o")
                    check_ok <= 1'b1;
                else
                    check_ok <= 1'b0;                        
                end  
            else          
                ;
        default:;
    endcase
    end    
*/    
        
endmodule
