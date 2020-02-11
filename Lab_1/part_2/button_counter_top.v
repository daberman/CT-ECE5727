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
// Description: A counter driven by button presses. Counter value is output in binary
//  via leds (on Digilent Zybo-Z7-10 dev board)
//
// Dependencies: None
//
// Revision: 1.0 - Initial release
// Revision 0.01 - File Created
// Additional Comments:
//  Created for Cornell Tech ECE 5727
//  Shell code for Lab 1
//
//////////////////////////////////////////////////////////////////////////////////


module button_counter_top (
  input           SYSCLK,
  input   [3:0]   BUTTONS,
  output  [3:0]   LEDS
);

  // Change this value to get a debouncer you like
  localparam DB_TIME = 10000; // 10,000 ticks @ 100MHz = 0.1ms

  localparam TICK_PER_MS = 100000; // 100,000 ticks @100Mhz = 1ms
  localparam TIMER_MAX   = 1000 * TICK_PER_MS;

/*************************
** Wires & Regs
*************************/

  // Clock
  wire clk, locked;
  wire reset = !locked; // Hold design in reset until clock is stable

  // Counter
  wire [3:0] btns;
  reg  [3:0] btn_last;  // Used to register last value on btns for edge-detect
  reg  [3:0] counter;   // The 4-bit counter who's value is output to the LEDs

  // Timer
  reg [31:0] timer;     // The independent, always running timer to increment the counter

  // Debouncer
  reg [3:0]  db_btns;
  reg [31:0] db_counter [3:0];


/*************************
** Module Instantiations
*************************/

  clk_gen clk_gen_inst
    (
      // Clock out ports
      .clk_100(clk),      // output clk @ 100 MHz
      // Status and control signals
      .locked(locked),    // output locked
      // Clock in ports
      .clk_in1(SYSCLK));  // input clk @ 125 MHz


/*************************
** RTL
*************************/

  assign LEDS = counter;
  assign btns = BUTTONS;      // Comment out if uncommenting line below
//    assign btns = db_btns;    // Uncomment to add debouncer: Part 1 - 1e

  integer i;
  always @(posedge clk) begin

    for (i=0; i<=3; i=i+1) begin
      if (BUTTONS[i] != db_btns[i]) begin
        if (db_counter[i] == DB_TIME-1) begin
          db_btns[i]    <= !db_btns[i];
          db_counter[i] <= 32'b0;
        end else begin
          db_counter[i] <= db_counter[i] + 1;
        end
      end else begin
        db_counter[i] <= 32'b0;
      end
    end

    // Synchronous Reset
    if (reset) begin
      db_btns <= 4'b0;
      db_counter[0] <= 32'b0;
      db_counter[1] <= 32'b0;
      db_counter[2] <= 32'b0;
      db_counter[3] <= 32'b0;
    end
  end


/*************************
** ALL YOUR CODE GOES BELOW HERE
*************************/


  always @(posedge clk) begin
    // Synchronous counter - put your logic here for the lab

    // Synchronous reset
    if(reset) begin
      counter <= 4'b0;
      timer   <= 32'b0;
    end
  end

  // always @(posedge clk) begin
  //   // Synchronous reset
  //   if (reset) begin
  //     counter <= 4'b0;
  //     timer   <= 32'b0;
  //   end else begin
  //     // Synchronous counter - put your logic here for Post-Lab 2b

  //   end
  // end

  // always @(posedge clk, posedge reset) begin
  //   // Asynchronous reset
  //   if (reset) begin
  //     counter <= 4'b0;
  //     timer   <= 32'b0;
  //   end else begin
  //     // Synchronous counter - put your logic here for Post-Lab 2c

  //   end
  // end

endmodule
