
/*
// Module: Washing_Machine.v
// Description: A Controller Unit for a washing machine using verilog code //
// Owner : Mohamed Ayman Elsayed 
// Date : July 2022
*/

module Washing_Machine 

#( parameter clk_width = 2 , state_width = 3 , counter_width = 32 )

(

    input   wire                        rst_n,
    input   wire                        clk,
    input   wire    [clk_width-1:0]     clk_freq,
    input   wire                        coin_in,
    input   wire                        double_wash,
    input   wire                        timer_pause,
    output  reg                         wash_done

);     

reg     [state_width-1:0]       current_state;
reg     [state_width-1:0]       next_state; 
reg     [counter_width-1:0]     counter;
reg     [counter_width-1:0]     counter_value;
reg                             Filling_Water_time_finish;
reg                             Washing_time_finish;
reg                             Rinsing_time_finish;
reg                             Spinning_time_finish;
reg                             Second_Washing;


// State Encoding 

localparam     Idle = 3'b000,
               Filling_Water = 3'b001,
               Washing = 3'b010,
               Rinsing = 3'b011,
               Spinning = 3'b100;

// Time Duration in 1MHz 

localparam     Filling_Water_time_1MHZ = 32'd120,
               Washing_time_1MHZ = 32'd300,
               Rinsing_time_1MHZ = 32'd120,
               Spinning_time_1MHZ = 32'd60;


// Time Duration in 2MHz 

localparam     Filling_Water_time_2MHZ = 32'd240,
               Washing_time_2MHZ = 32'd600,
               Rinsing_time_2MHZ = 32'd240,
               Spinning_time_2MHZ = 32'd120;


// Time Duration in 4MHz 

localparam     Filling_Water_time_4MHZ = 32'd480,
               Washing_time_4MHZ = 32'd1200,
               Rinsing_time_4MHZ = 32'd480,
               Spinning_time_4MHZ = 32'd240;

// Time Duration in 8MHz 

localparam     Filling_Water_time_8MHZ = 32'd960,
               Washing_time_8MHZ = 32'd2400,
               Rinsing_time_8MHZ = 32'd960,
               Spinning_time_8MHZ = 32'd480;

// counter

always @ ( posedge clk or negedge rst_n )

    begin
        if ( !rst_n ) 
            begin
                counter <= 32'd0;
            end
        else
            begin
                counter <= counter_value ;
            end            
    end 

always @ ( posedge clk or negedge rst_n )

    begin 
        if ( !rst_n ) 
            begin
                current_state <= Idle;
            end
        else
            begin
                current_state <= next_state;
            end
    end 

always @ (*)

    begin
        case ( current_state )

        Idle:  
                begin
                    if ( coin_in )
                        begin
                            next_state = Filling_Water;
                            wash_done = 1'b0; 
                        end
                    else 
                        begin
                            next_state = Idle;
                            wash_done = 1'b1;
                        end
                end   

        Filling_Water:
                
                begin
                    
                    Second_Washing <= 1'b0;

                    if ( Filling_Water_time_finish )
                        begin
                            next_state = Washing ;
                        end
                    else
                        begin
                            next_state = Filling_Water;
                        end

                end

        Washing:

                begin

                    if ( Washing_time_finish )
                        begin
                            next_state = Rinsing ;
                        end
                    else
                        begin
                            next_state = Washing;
                        end
                        
                end

        Rinsing:

                begin

                    if ( Rinsing_time_finish && double_wash && !Second_Washing )
                        begin
                            next_state = Washing ;
                            Second_Washing = 1'b1;
                        end
                    else if ( Rinsing_time_finish && !double_wash )
                        begin
                            next_state = Spinning ;
                            Second_Washing = 1'b0;
                        end
                    else
                        begin
                            next_state = Rinsing;
                            Second_Washing = 1'b0;
                        end
                        
                end

        Spinning:

                begin

                    if ( Spinning_time_finish )
                        begin
                            next_state = Idle ;
                            wash_done = 1'b1;
                        end
                    else
                        begin
                            next_state = Spinning;
                            wash_done = 1'b0;
                        end
                        
                end               

        default:
                begin
                   next_state = Idle ;    
                end

        endcase
    end

always @(*)

    begin
        Filling_Water_time_finish = 1'b0;
        Washing_time_finish = 1'b0;
        Rinsing_time_finish = 1'b0;
        Spinning_time_finish = 1'b0;

        case ( current_state )

        Filling_Water: 

            begin
                case (clk_freq)
                
                2'b00 : 
                        begin
                            if ( counter == Filling_Water_time_1MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Filling_Water_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b01 : 
                        begin
                            if ( counter == Filling_Water_time_2MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Filling_Water_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b10 : 
                        begin
                            if ( counter == Filling_Water_time_4MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Filling_Water_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b11 : 
                        begin
                            if ( counter == Filling_Water_time_8MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Filling_Water_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                endcase
            end

        Washing: 

            begin
                case (clk_freq)
                
                2'b00 : 
                        begin
                            if ( counter == Washing_time_1MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Washing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b01 : 
                        begin
                            if ( counter == Washing_time_2MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Washing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b10 : 
                        begin
                            if ( counter == Washing_time_4MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Washing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b11 : 
                        begin
                            if ( counter == Washing_time_8MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Washing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                endcase
            end

        Rinsing: 

            begin
                case (clk_freq)
                
                2'b00 : 
                        begin
                            if ( counter == Rinsing_time_1MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Rinsing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b01 : 
                        begin
                            if ( counter == Rinsing_time_2MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Rinsing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b10 : 
                        begin
                            if ( counter == Rinsing_time_4MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Rinsing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b11 : 
                        begin
                            if ( counter == Rinsing_time_8MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Rinsing_time_finish = 1'b1;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                endcase
            end

        Spinning: 

            begin
                case (clk_freq)
                
                2'b00 : 
                        begin
                            if ( counter == Spinning_time_1MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Spinning_time_finish = 1'b1;
                                end
                            else if ( timer_pause ) 
                                begin
                                    counter_value = counter;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b01 : 
                        begin
                            if ( counter == Spinning_time_2MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Spinning_time_finish = 1'b1;
                                end
                            else if ( timer_pause ) 
                                begin
                                    counter_value = counter;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b10 : 
                        begin
                            if ( counter == Spinning_time_4MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Spinning_time_finish = 1'b1;
                                end
                            else if ( timer_pause ) 
                                begin
                                    counter_value = counter;
                                end
                            else
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                2'b11 : 
                        begin
                            if ( counter == Spinning_time_8MHZ )
                                begin
                                    counter_value = 32'd0;
                                    Spinning_time_finish = 1'b1;
                                end
                            else if ( timer_pause ) 
                                begin
                                    counter_value = counter;
                                end
                            else 
                                begin
                                    counter_value = counter + 32'd1;
                                end
                        end
                endcase
            end

        default:

            begin
                counter_value = 32'd0;
            end

        endcase
        
    end


endmodule 