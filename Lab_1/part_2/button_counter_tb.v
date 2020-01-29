`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DB Solutions NY LLC
// Engineer: Daniel Berman
//
// Create Date: 01/2020
// Design Name: button_counter_top
// Module Name: button_counter_top
// Project Name: Button Counter
// Target Devices: Zynq-7000
// Tool Versions: Vivado 2018.3
// Description: Testbench for Lab 1
//
// Dependencies: None
//
// Revision: 1.0 - Initial release
// Revision 0.01 - File Created
// Additional Comments:
//  Created for Cornell Tech ECE 5727
//
//////////////////////////////////////////////////////////////////////////////////

module button_counter_tb;

  localparam CLK_PERIOD   = 8;  // 8ns = 125MHz
  localparam HALF_CLK   = CLK_PERIOD / 2;
  localparam DELAY    = 100;  // 100ns = 10 clk @ 100MHz

/*************************
** Instantiate DUT
*************************/

  reg  SYSCLK;
  reg  [3:0] BUTTONS;
  wire [3:0] LEDS;

  button_counter_top dut (.SYSCLK(SYSCLK),
    .BUTTONS(BUTTONS),
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
      BUTTONS = 4'b0; // No input at start, LED should be 4'h0

      #500 // Delay 500ns to allow for initial clock startup

        #DELAY BUTTONS[0] = 1'b1;   // LED should be 4'h1

      #DELAY BUTTONS[0] = 1'b0;

      #DELAY BUTTONS[1] = 1'b1;   // LED should increment by 2: 4'h3

      #DELAY BUTTONS[1] = 1'b0;

      #DELAY BUTTONS[2] = 1'b1;   // LED should increment by 3: 4'h5

      #DELAY BUTTONS[2] = 1'b0;

      #DELAY BUTTONS[3] = 1'b1;   // LED should increment by 4: 4'ha

      #DELAY BUTTONS[3] = 1'b0;

    end

endmodule