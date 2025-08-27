module ram_16bit #(
    parameter DATA_WIDTH = 16,       // 16-bit veri genişliği
    parameter ADDR_WIDTH = 12        // 12-bit adres hattı: 2^12 = 4096 adres
)(
    input clk,                       // Saat sinyali
    input we,                        // Write Enable (1: yazma, 0: okuma)
    input [ADDR_WIDTH-1:0] addr,     // Bellek adresi
    input [DATA_WIDTH-1:0] din,      // Yazılacak veri
    output [DATA_WIDTH-1:0] dout     // Okunan veri
);

    // 4096 x 16-bit bellek dizisi
    reg [DATA_WIDTH-1:0] bellek [0:(1<<ADDR_WIDTH)-1];
    reg [DATA_WIDTH-1:0] data;

    always @(posedge clk) begin
        if (we) begin
            bellek[addr] <= din;         // Yazma işlemi
        end else begin
            data <= bellek[addr];        // Okuma işlemi
        end
    end

    assign dout = data;

endmodule