`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DB Solutions NY LLC
// Engineer: Daniel Berman
//
// Create Date: 02/2020
// Design Name: tbird
// Module Name: tbird_tb
// Project Name: Thunderbird
// Target Devices: Zynq-7000
// Tool Versions: Vivado 2018.3
// Description: Testbench for Lab 2
//
// Dependencies: None
//
// Revision: 1.0 - Initial release
// Revision 0.01 - File Created
// Additional Comments:
//  Created for Cornell Tech ECE 5727
//
//////////////////////////////////////////////////////////////////////////////////

module tbird_tb;

    localparam CLK_PERIOD   = 8;
    localparam HALF_CLK     = CLK_PERIOD / 2;
    localparam DELAY        = 100;  // 100 ns = slow clk period in sim

/*************************
** Instantiate DUT
*************************/

reg SYSCLK;
reg HAZARD_BTN;
reg LEFT;
reg RIGHT;
wire [3:0] LEDS;

tbird #(.SIM_ONLY(1)
    ) dut (
    .SYSCLK(SYSCLK),
    .HAZARD_BTN(HAZARD_BTN),
    .LEFT(LEFT),
    .RIGHT(RIGHT),
    .LEDS(LEDS)
    );

/*************************
** Run Clock
*************************/

initial
    SYSCLK = 1'b0;  // At time 0, set clock to 0

always
    #HALF_CLK SYSCLK = ~SYSCLK; // Invert clock every half period

/*************************
** Testbench - modify as you see fit
*************************/

initial
begin
    HAZARD_BTN  = 1'b0;
    LEFT        = 1'b0;
    RIGHT       = 1'b0;

    #500 // Delay 500 ns to allow for initial clock startup

    #(10*DELAY) // Wait to come out of reset

    #DELAY      LEFT = 1'b1; // Turn on left signal
    #(10*DELAY) LEFT = 1'b0; // Turn off left signal

end

endmodule