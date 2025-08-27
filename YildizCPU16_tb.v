`timescale 1ns / 1ps

module YildizCPU16_tb;

    reg clk;
    reg rst;

    wire [15:0] data_out, data_in;
    wire [15:0] tbDR, tbAC, tbIR, tbBus;
    wire [11:0] tbAR, tbPC;
    wire [127:0] tbRegs;
    wire [11:0] tbSP, tbISR;
    wire [3:0] tbFLAGS;
    wire [7:0] tbINPR, tbOUTPR;

    // Instantiate the CPU top module
    YildizCPU16 uut (
        .clkn(clk),
        .rstn(rst),
        .data_out(data_out),
        .data_in(data_in),
        .tbDR(tbDR),
        .tbAC(tbAC),
        .tbIR(tbIR),
        .tbBus(tbBus),
        .tbAR(tbAR),
        .tbPC(tbPC),
        .tbRegs(tbRegs),
        .tbSP(tbSP),
        .tbISR(tbISR),
        .tbFLAGS(tbFLAGS),
        .tbINPR(tbINPR),
        .tbOUTPR(tbOUTPR)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns period (100MHz)

    initial begin
        $display("----- YildizCPU16 Testbench Başlatılıyor -----");
       
        // Başlangıç değerleri
        clk = 0;
        rst = 0;

        #10;
        rst = 1;  // Reset aktif
        #20;
        rst = 0;  // Reset bırak
        $display("Reset bırakıldı");

        // Simülasyonu bir süre çalıştır
        #500;

        // Gözlemleme örneği
        $display("AC: %h", tbAC);
        $display("DR: %h", tbDR);
        $display("IR: %h", tbIR);
        $display("PC: %h", tbPC);
        $display("FLAGS: %b", tbFLAGS);
        $display("Registers [R0-R7]:");
        $display("R0: %h", tbRegs[15:0]);
        $display("R1: %h", tbRegs[31:16]);
        $display("R2: %h", tbRegs[47:32]);
        $display("R3: %h", tbRegs[63:48]);
        $display("R4: %h", tbRegs[79:64]);
        $display("R5: %h", tbRegs[95:80]);
        $display("R6: %h", tbRegs[111:96]);
        $display("R7: %h", tbRegs[127:112]);

        // Simülasyon sonu
        $finish;
    end

endmodule

