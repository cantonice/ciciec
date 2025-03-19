module uart_tx #(
    parameter BAUD_RATE = 115200,
    parameter CLOCK_FREQ = 50000000
)(
    input wire clk,
    input wire reset_n,
    input wire [7:0] data_in,
    input wire start,
    output wire tx,
    output wire busy
);
    // 计算波特率计数器的最大值
    localparam integer BAUD_COUNTER_MAX = CLOCK_FREQ / BAUD_RATE;

    // 状态定义
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    // 寄存器定义
    reg [1:0] state = IDLE;
    reg [1:0] next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg [15:0] baud_counter;
    reg tx_reg;
    reg busy_reg;

    // 状态机
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            baud_counter <= 0;
            bit_count <= 0;
            tx_reg <= 1'b1; // 空闲状态下TX为高电平
            busy_reg <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    tx_reg <= 1'b1;
                    busy_reg <= 1'b0;
                    if (start) begin
                        shift_reg <= data_in;
                        bit_count <= 0;
                        baud_counter <= 0;
                        next_state <= START;
                    end
                end
                START: begin
                    tx_reg <= 1'b0; // 起始位
                    busy_reg <= 1'b1;
                    if (baud_counter == BAUD_COUNTER_MAX - 1) begin
                        baud_counter <= 0;
                        next_state <= DATA;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                DATA: begin
                    tx_reg <= shift_reg[0];
                    if (baud_counter == BAUD_COUNTER_MAX - 1) begin
                        baud_counter <= 0;
                        shift_reg <= shift_reg >> 1;
                        if (bit_count == 7) begin
                            next_state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                STOP: begin
                    tx_reg <= 1'b1; // 停止位
                    if (baud_counter == BAUD_COUNTER_MAX - 1) begin
                        baud_counter <= 0;
                        next_state <= IDLE;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                default: next_state <= IDLE;
            endcase
        end
    end

    // 输出信号
    assign tx = tx_reg;
    assign busy = busy_reg;

endmodule