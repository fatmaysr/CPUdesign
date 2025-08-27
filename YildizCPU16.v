module YildizCPU16 (
    input clkn, rstn,
    output [15:0] data_out, data_in,
    output [15:0] tbDR, tbAC, tbIR, tbBus,
    output [11:0] tbAR, tbPC,              // AR ve PC 12-bit adres hattı
    output [127:0] tbRegs,                 // ✅ düzleştirilmiş R0-R7
    output [11:0] tbSP, tbISR,             // SP ve ISR
    output [3:0]  tbFLAGS,                 // FLAGS 4-bit
    output [7:0]  tbINPR, tbOUTPR          // INPR & OUTPR
);

    wire we;
    wire [15:0] from_mem, to_mem;
    wire [11:0] adr;

    // Test sinyalleri için wire'lar
    wire [15:0] testDR, testAC, testIR, testBus;
    wire [11:0] testAR, testPC;
    wire [3:0]  testFLAGS;
    wire [7:0]  testINPR, testOUTPR;
    wire [127:0] regbank_flat;         // ✅ düzleştirilmiş register çıkışı
    wire [11:0] sp_wire, isr_wire;

    // Bellek bağlantıları
    assign data_out = from_mem;
    assign data_in  = to_mem;

    // Temel test çıkışları
    assign tbDR     = testDR;
    assign tbAC     = testAC;
    assign tbIR     = testIR;
    assign tbBus    = testBus;
    assign tbAR     = testAR;
    assign tbPC     = testPC;
    assign tbFLAGS  = testFLAGS;
    assign tbINPR   = testINPR;
    assign tbOUTPR  = testOUTPR;

    assign tbRegs   = regbank_flat;    // ✅ R0-R7 flat çıkışı
    assign tbSP     = sp_wire;
    assign tbISR    = isr_wire;

    // CPU instantiation
    yildiz_cpu_16bit cpu (
        .clk(clkn),
        .rst(rstn),
        .from_memory(from_mem),
        .to_memory(to_mem),
        .address(adr),
        .write(we),

        // test çıkışları
        .testDR(testDR),
        .testAC(testAC),
        .testIR(testIR),
        .testAR(testAR),
        .testPC(testPC),
        .testBus(testBus),
        .testFLAGS(testFLAGS),
        .testINPR(testINPR),
        .testOUTPR(testOUTPR),
        .registers_out_flat(regbank_flat),   // ✅ düzleştirilmiş çıkış
        .sp_out(sp_wire),
        .isr_out(isr_wire)
    );

    // RAM instantiation - 4096 x 16-bit
    ram_16bit #(
        .DATA_WIDTH(16),
        .ADDR_WIDTH(12)
    ) ram4096byte (
        .clk(clkn),
        .we(we),
        .addr(adr),
        .din(to_mem),
        .dout(from_mem)
    );

endmodule
