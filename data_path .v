module data_path (
    input clk, rst,

    input IR_Load, DR_Load, PC_Load, AR_Load, AC_Load, FLAGS_Load,
    input DR_Inc, AC_Inc, PC_Inc,
    input [3:0] alu_sel,
    input [2:0] bus_sel,

    input [15:0] from_memory,
                 
    output [15:0] to_memory,
    output [11:0] address,

    output [15:0] IR_Value,
    output [3:0] FLAGS_Value,

    output [15:0] tDR, tAC, tIR, tBus,
    output [11:0] tAR, tPC,
   
    input [15:0] rb_data1,
    input [15:0] rb_data2,
    output [15:0] bus
);

    // Dahili registerlar
    reg [15:0] IR, DR, AC;
    reg [11:0] AR, PC;
    reg [3:0] FLAGS;

    wire [15:0] alu_out;

    // Bus seçimi
 assign bus = (bus_sel == 3'b000) ? rb_data1 :
             (bus_sel == 3'b001) ? rb_data2 :
             (bus_sel == 3'b010) ? from_memory :
             (bus_sel == 3'b011) ? {4'd0, PC} :     // 12-bit PC'yi 16-bit'e genişlet
             (bus_sel == 3'b100) ? DR :
             (bus_sel == 3'b101) ? AC :
             (bus_sel == 3'b110) ? 16'd0 :
             16'd0;  // <-- son "else" durumu için default değer


    // Bellek arabirimi
    assign to_memory = bus;
    assign address = AR;

    // Test çıkışları
    assign tDR = DR;
    assign tAC = AC;
    assign tIR = IR;
    assign tAR = AR;
    assign tPC = PC;
    assign tBus = bus;
    assign IR_Value = IR;
    assign FLAGS_Value = FLAGS;

    // IR
    always @(posedge clk or posedge rst) begin
        if (rst)
            IR <= 16'd0;
        else if (IR_Load)
            IR <= bus;
    end

    // DR
    always @(posedge clk or posedge rst) begin
        if (rst)
            DR <= 16'd0;
        else if (DR_Load)
            DR <= bus;
        else if (DR_Inc)
            DR <= DR + 1;
    end

    // AC
    always @(posedge clk or posedge rst) begin
        if (rst)
            AC <= 16'd0;
        else if (AC_Load)
            AC <= alu_out;
        else if (AC_Inc)
            AC <= AC + 1;
    end

    // AR
    always @(posedge clk or posedge rst) begin
        if (rst)
            AR <= 12'd0;
        else if (AR_Load)
            AR <= bus[11:0];
    end

    // PC
    always @(posedge clk or posedge rst) begin
        if (rst)
            PC <= 12'd0;
        else if (PC_Load)
            PC <= bus[11:0];
        else if (PC_Inc)
            PC <= PC + 1;
    end

    // FLAGS (Z, N, V, C gibi)
    always @(posedge clk or posedge rst) begin
        if (rst)
            FLAGS <= 4'b0000;
        else if (FLAGS_Load) begin
            FLAGS[0] <= (alu_out == 16'd0);             // Zero
            FLAGS[1] <= alu_out[15];                    // Negative (MSB)
            FLAGS[2] <= ^{AC[15], DR[15], alu_out[15]}; // Overflow
            FLAGS[3] <= alu_out[15];                    // Carry/Sign gibi
        end
    end

    // ALU modülü
    alu alu_uut (
        .s1_in(AC),
        .s2_in(DR),
        .islem_in(alu_sel),
        .s_out(alu_out)
    );

endmodule
