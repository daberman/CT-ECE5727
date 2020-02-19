`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DB Solutions NY LLC
// Engineer: Daniel Berman
//
// Create Date: 02/2020
// Design Name: tbird
// Module Name: tbird
// Project Name: Thunderbird
// Target Devices: Zynq-7000
// Tool Versions: Vivado 2018.3
// Description: A take on the common TBird digital controller design lab
//
// Dependencies: None
//
// Revision: 1.0 - Initial release
// Revision 0.01 - File Created
// Additional Comments:
//  Created for Cornell Tech ECE 5727
//
//////////////////////////////////////////////////////////////////////////////////

module tbird #(parameter SIM_ONLY = 0)(
    input  SYSCLK,
    input  HAZARD_BTN,
    input  LEFT,
    input  RIGHT,
    output reg [3:0] LEDS
);

// Divides the clock from 100 MHz down to 4 Hz
localparam CLK_DIV_VALUE = SIM_ONLY ? 5 : 12500000;

// FSM States - Complete with your own state names
localparam  ST_OFF  = 4'd0,
            ST_1    = 4'd1,
            //...
            ST_7    = 4'd7;


/******************
**   Wires & Regs
******************/

// Clock & Reset
wire clk, locked;
reg [7:0] rstPipe;
wire rst = |rstPipe; // Hold design in reset until clock is stable

integer clkDivCnt;
reg     clkEn;
wire    slowClk;

// Hazard Button
wire hazardBtn;
reg  hazardBtn_r;
wire hazardPushed;

// State Machine
reg [3:0] state;


/***********************
** Module Instantiations
***********************/

// Clock Wizard IP Core to generate a stable 100MHz clock from the board clock
clk_gen clk_gen_inst
(
    // Clock out ports
    .clk_100(clk),      // output clk @ 100 MHz
    // Status and control signals
    .locked(locked),    // output locked
    // Clock in ports
    .clk_in1(SYSCLK)    // input clk @ 125 MHz
);

// Place the slow clock into an fpga clocking tree
BUFG slow_clk_buf (.I(clkEn), .O(slowClk));

// Debounce the hazard button
debouncer #(.SIM_ONLY(SIM_ONLY))
    hzd_debouncer (.clk(clk), .rst(rst), .i_sig(HAZARD_BTN), .o_sig(hazardBtn));


/***************
**     RTL
***************/

assign hazardPushed = hazardBtn && !hazardBtn_r;

always @(posedge slowClk) begin

    hazardBtn_r <= hazardBtn;

    case (state)
        ST_OFF  : begin
            LEDS <= 4'b0;
        end
        default : state <= ST_OFF;
    endcase

    if (rst) begin
        state    <= ST_OFF;
    end
end


/* Do not modify any of the code below */

// Generate the slow clock
// Toggling at 8Hz will create a 4Hz clock w/ 50% duty cycle
always @(posedge clk) begin

    clkDivCnt <= clkDivCnt + 1;

    if (clkDivCnt == CLK_DIV_VALUE-1) begin
        clkDivCnt   <= 0;
        clkEn       <= !clkEn;
    end

    if (!locked) begin
        clkDivCnt   <= 0;
        clkEn       <= 1'b0;
    end
end

// Generate internal reset
always @(posedge slowClk, negedge locked) begin
    if (!locked) rstPipe <= 8'hff;
    else rstPipe <= rstPipe << 1;
end

endmodule