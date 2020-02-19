module debouncer #(
    parameter SIM_ONLY = 0,
    parameter DB_TIME  = 10000
    )(
    input   clk,
    input   rst,
    input   i_sig,
    output  o_sig
);

localparam DB_TIME_I = SIM_ONLY ? 5 : DB_TIME;

integer counter;
reg     db_sig;

assign o_sig = db_sig;

always @(posedge clk) begin

    if (db_sig != i_sig) begin
        if (counter == DB_TIME_I-1) begin
            db_sig  <= !db_sig;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end else begin
        counter <= 0;
    end

    // Reset
    if (rst) begin
    counter <= 0;
    db_sig  <= 1'b0;
    end
end

endmodule