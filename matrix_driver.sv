`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2020 10:08:46 PM
// Design Name: 
// Module Name: matrix_driver
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


module matrix_driver(
    input clock,  
    input [7:0][7:0] green_grid, blue_grid,       // grid for green and blue states (tuened on and off)
    output logic [7:0] green_driver, blue_driver, row_driver   // the grid that contains the final values that output on the module
    );
    
    logic [2:0] count = 0;                           
    
    always_ff @ (posedge clock) begin
        count <= count + 3'b001;
    end
    
    always @ (*)  begin                          // counter used to access a specific row (0-7 rows)
        case (count)                            // switch case to be able to access each row (anode)
            3'b000: row_driver = 8'b00000001;       // 1st row
            3'b001: row_driver = 8'b00000010;       // 
            3'b010: row_driver = 8'b00000100;
            3'b011: row_driver = 8'b00001000;
            3'b100: row_driver = 8'b00010000;
            3'b101: row_driver = 8'b00100000;
            3'b110: row_driver = 8'b01000000;
            3'b111: row_driver = 8'b10000000;
            default: row_driver = 8'b00000000;
        endcase
    end
    
    assign green_driver = green_grid[count];        // muxes to access the output green leds
    assign blue_driver = blue_grid[count];
    
endmodule




