module usb_uart(
    input wire clk,
    input wire reset_n,
    input wire [7:0] data_in,
    input wire data_valid,
    output wire tx
);
    // UART parameters
    parameter BAUD_RATE = 115200;
    parameter CLOCK_FREQ = 50000000;

    // UART signals
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_busy;

    // UART instance
    uart_tx #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_FREQ(CLOCK_FREQ)
    ) uart_tx_inst (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(tx_data),
        .start(tx_start),
        .tx(tx),
        .busy(tx_busy)
    );

    // State machine to send data
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            tx_data <= 8'b0;
            tx_start <= 1'b0;
        end else if (data_valid && !tx_busy) begin
            tx_data <= data_in;
            tx_start <= 1'b1;
        end else begin
            tx_start <= 1'b0;
        end
    end
endmodule