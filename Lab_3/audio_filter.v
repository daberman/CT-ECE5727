module audio_filter(
    input clk,
    input rst,
    input [15:0] din,
    output [15:0] dout
    );
    
    localparam SAMPLE_CLK_CNT = 500000 / 48000; // 50MHz / 48kHz; to speed up sim, reduce to 500kHz clock
    
    reg     sampleEn;
    integer sampleCnt;
    
    reg         firDinVld;
    wire        firDinRdy;
    reg [15:0]  firDin;
    wire        firDoutVld;
    wire [23:0] firDout;
    
fir_filter fir_filter_inst (
  .aclk(clk),                       // input wire aclk
  .s_axis_data_tvalid(firDinVld),   // input wire s_axis_data_tvalid
  .s_axis_data_tready(firDinRdy),   // output wire s_axis_data_tready
  .s_axis_data_tdata(firDin),       // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(firDoutVld),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(firDout)       // output wire [31 : 0] m_axis_data_tdata
);    
    
    assign dout = firDout[23 -: 16];
    
    // Sample the audio input and pass into the FIR Filter
    always @(posedge clk) begin
        if (firDinRdy) begin
            firDinVld <= 1'b0;
        end
        
        if (sampleEn) begin
            firDinVld <= 1'b1;
            firDin    <= din;
        end
        
        if (rst) begin
            firDinVld <= 1'b0;
            firDin    <= 'b0;
        end
    end
    
    // Generate 48 kHz sample tick
    always @(posedge clk) begin
        sampleCnt <= sampleCnt + 'b1;
        sampleEn  <= 1'b0;
        
        if (sampleCnt >= SAMPLE_CLK_CNT - 1) begin
            sampleCnt <= 'b0;
            sampleEn  <= 1'b1;
        end
        
        if (rst) begin
            sampleCnt <= 'b0;
        end
    end

endmodule
