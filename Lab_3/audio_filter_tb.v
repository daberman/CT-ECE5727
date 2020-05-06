`timescale 1ns / 1ps

module audio_filter_tb;

localparam PHASE_INC_1KHZ = 2**24 / (500000 / 1000); // For sim speed up, pretend clock is 500kHz instead of 50MHz

localparam CLK_PERIOD = 20;
localparam HALF_CLK   = CLK_PERIOD / 2;

reg clk, rst;

reg signed  [16:0] sineWave;

reg         [23:0] phase1khz, phase15khz;
wire signed [15:0] sine1khz, sine15khz;

initial begin
    clk = 1'b0;
    rst = 1'b1;
    #(10*CLK_PERIOD) rst = 1'b0;
end

always #HALF_CLK clk = !clk;

audio_filter uut(
    .clk(clk),
    .rst(rst),
    .din(sineWave[16:1]),
    .dout()
    );

sine_gen sine_gen_1k (
  .aclk(clk),                                   // input wire aclk
  .s_axis_phase_tvalid(1'b1),                   // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(phase1khz[23 -: 16]),     // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(),                        // output wire m_axis_data_tvalid
  .m_axis_data_tdata(sine1khz)                  // output wire [15 : 0] m_axis_data_tdata
);

sine_gen sine_gen_15k (
  .aclk(clk),                                   // input wire aclk
  .s_axis_phase_tvalid(1'b1),                   // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(phase15khz[23 -: 16]),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(),                        // output wire m_axis_data_tvalid
  .m_axis_data_tdata(sine15khz)                 // output wire [15 : 0] m_axis_data_tdata
);

always @(posedge clk) begin
    phase1khz  <= phase1khz + PHASE_INC_1KHZ;
    phase15khz <= phase15khz + 15*PHASE_INC_1KHZ;
    sineWave   <= sine1khz + (sine15khz >>> 2);
    
    if (rst) begin
        phase1khz  <= 'b0;
        phase15khz <= 'b0;
    end
end

endmodule
