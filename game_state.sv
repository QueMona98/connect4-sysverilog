`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2020 10:44:58 PM
// Design Name: 
// Module Name: FSM
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


module game_state(
    input clock,
    input rst,                              // button to reset game (either top or bottom button)
    input select,                           // middle button (dropper)
    input [2:0] columnPosition,
    output logic [7:0][7:0] green_grid,       // grid containing information about state of green leds (high and low)
    output logic [7:0][7:0] blue_grid       // grid containing information about state of blue leds (high and low)
    );
    
    // t flip-flop implements the player turn
    reg turn = 0;     
    always_ff @ (posedge clock) begin 
        if (rst)                                // reset button pressed so turn set to color designated
            turn <= 0;
        else begin
            if (select)                         // if middle button is pressed then switch turns
                turn <= ~turn;
        end
    end

        
    // decoder for column position
    // 3-bit count -> 8-bit row
    reg [7:0] topRow;
    always_comb begin
        case (columnPosition)
            3'b000: topRow = 8'b01111111;               // maps current column to a specified high signal for an led (ITS LIT)
            3'b001: topRow = 8'b10111111;               // 1st row -> 8th row
            3'b010: topRow = 8'b11011111;
            3'b011: topRow = 8'b11101111;
            3'b100: topRow = 8'b11110111;
            3'b101: topRow = 8'b11111011;
            3'b110: topRow = 8'b11111101;
            default: topRow = 8'b11111111;
        endcase;
    end
             
    // column counter
    reg [6:0][2:0] columnCount;                 // holder for the amount of token in each column (3 bit value, max is 6 tokens
    always_ff @ (posedge clock) begin
        if (rst) begin                                // if reset button pressed, the column count becomes zero
            for(int i = 0; i < 8; i ++) begin 
                columnCount[i] <= 3'b000; 
            end
        end    
        else begin
            if(select && columnCount[columnPosition] < 5)  // add values to each column as long as the current column count is not greater than 6 
                columnCount[columnPosition] <= columnCount[columnPosition] + 1;
        end
    end
        
    // modifying the state of the green/blue grid
    always_ff @ (posedge clock) begin
    
        // top row configuration
        case (turn)
            (1'b0): begin 
                    green_grid[0] <= topRow;
                    blue_grid[0] <= 8'b11111111;
             end
            (1'b1): begin
                blue_grid[0] <= topRow;
                green_grid[0] <= 8'b11111111;
             end
        endcase
          
        if (rst) begin                          // if the reset button is pressed turn off all leds (make cathodes high)
            for(int i = 1; i < 8; i++) begin
                green_grid[i] <= 8'b11111111;
                blue_grid[i] <= 8'b11111111;
            end
        end 
        else begin
            if (select) begin                   // if middle button pressed
                case (turn)
                    (1'b0):  green_grid[7 - columnCount[columnPosition]][7 - columnPosition] <= 1'b0; 
                    (1'b1): blue_grid[7 - columnCount[columnPosition]][7 - columnPosition] <= 1'b0;
                endcase
            end
        end
    end
    
endmodule
