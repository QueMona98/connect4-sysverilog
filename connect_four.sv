`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2020 10:38:02 PM
// Design Name: 
// Module Name: connect_four
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module connect_four(
    input clock,
    input rbtn, lbtn, mbtn, bbtn,
    output logic [7:0] row, greenColumn, blueColumn  
    );
    
    logic inter_clock, reset, db_mbtn, db_bbtn, db_lbtn, db_rbtn;
    logic [7:0][7:0] blue_gridTest, green_gridTest;
    logic [2:0] position;
    logic [7:0] topRow;
    
    // clock divider
    clk_div MYCLOCK (
        .clk(clock),
        .sclk(inter_clock)
    );   
    
    // button debouncers
    debounce_one_shot debouncer1 (
        .CLK(inter_clock),
        .BTN(mbtn),
        .DB_BTN(db_mbtn)
    );
    
    debounce_one_shot debouncer2 (
        .CLK(inter_clock),
        .BTN(bbtn),
        .DB_BTN(db_bbtn)
    );
    
    debounce_one_shot debouncer3 (  // module to make sure right button signal only becomes high with each press (not affected by clock signal)
        .CLK(inter_clock),
        .BTN(rbtn),
        .DB_BTN(db_rbtn)
    );
    
    debounce_one_shot debouncer4 (  // module to make sure left position is only high at once
        .CLK(inter_clock),
        .BTN(lbtn),
        .DB_BTN(db_lbtn)
    );
    
    // position indicator/mover
    position_mover mover(
        .RBTN(db_rbtn),
        .LBTN(db_lbtn),
        .rst(db_bbtn),
        .clock(inter_clock),
        .columnPosition(position)
    );
    
    // game state
    game_state game(
        .clock(inter_clock),
        .rst(db_bbtn),
        .select(db_mbtn),
        .columnPosition(position),
        .green_grid(green_gridTest),
        .blue_grid(blue_gridTest)
    );
    
    // matrix driver
    matrix_driver driver (
        .clock(inter_clock),
        .blue_grid(blue_gridTest),
        .green_grid(green_gridTest),
        .green_driver(greenColumn),
        .blue_driver(blueColumn),
        .row_driver(row)
    );


endmodule

// clock divider
module clk_div (
    input clk,
    output sclk
    );

  integer MAX_COUNT = 60; 
  integer div_cnt =0;
  reg tmp_clk=0; 

   always @ (posedge clk)              
   begin
         if (div_cnt == MAX_COUNT) 
         begin
            tmp_clk = ~tmp_clk; 
            div_cnt = 0;
         end else
            div_cnt = div_cnt + 1;  
   end 
   assign sclk = tmp_clk; 
endmodule
