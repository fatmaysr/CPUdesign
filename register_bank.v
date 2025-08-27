module register_bank (
    input clk, rst,
    input [3:0] read_sel1, read_sel2, write_sel,
    input write_en,
    input [15:0] write_data,
    output [15:0] read_data1, read_data2,
    output [127:0] regs_out_flat, // R0-R7 düzleştirilmiş
    output [11:0] sp_out, isr_out // SP & ISR ayrı çıkışlar
);
    reg [15:0] registers [0:7]; // R0-R7
    reg [11:0] SP;              // Stack Pointer
    reg [11:0] ISR;             // Interrupt Service Register

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                registers[i] <= 16'b0;
            SP <= 12'd0;
            ISR <= 12'd0;
        end else if (write_en) begin
            if (write_sel < 8)
                registers[write_sel] <= write_data;
            else if (write_sel == 8)
                SP <= write_data[11:0];
            else if (write_sel == 9)
                ISR <= write_data[11:0];
        end
    end

    assign read_data1 = (read_sel1 < 8) ? registers[read_sel1] :
                        (read_sel1 == 8) ? {4'd0, SP} :
                        (read_sel1 == 9) ? {4'd0, ISR} :
                        16'd0;

    assign read_data2 = (read_sel2 < 8) ? registers[read_sel2] :
                        (read_sel2 == 8) ? {4'd0, SP} :
                        (read_sel2 == 9) ? {4'd0, ISR} :
                        16'd0;

    // R0-R7 düzleştirme
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : flatten
            assign regs_out_flat[j*16 +: 16] = registers[j];
        end
    endgenerate

    // SP & ISR çıkışı
    assign sp_out = SP;
    assign isr_out = ISR;

endmodule