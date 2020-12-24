`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2020 01:25:32 PM
// Design Name: 
// Module Name: position_mover
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


module position_mover(  // module to detect and store movement of player (right or left) 
    input RBTN, // right button
    input LBTN, // left button
    input clock,
    input rst,
    output [2:0] columnPosition
    );
    
    logic [2:0] position = 3'b011;
            
    always_ff @(posedge clock) begin
        if (rst)
            position <= 3'b011;
        else begin
            if(RBTN && !LBTN && position < 6)       // right movement, if the right button is pressed but the left button not pressed (to account for both buttons being pressed at the same time)
                position <= position + 1;
            else if (LBTN && !RBTN && position > 0) // left movement
                position <= position - 1;
        end
    end   
    
    assign columnPosition = position;  

endmodule
