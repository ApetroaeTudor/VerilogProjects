module Mem_Instruction(
    input i_rst,
    input [31:0] i_pc,
    output [31:0] o_instr
);
    reg [7:0] r_mem_instr [256:0];

    assign {o_instr[31:24],o_instr[23:16],o_instr[15:8],o_instr[7:0]} = 
           {r_mem_instr[i_pc+3],r_mem_instr[i_pc+2],r_mem_instr[i_pc+1],r_mem_instr[i_pc]};

    always@(posedge i_rst)
    begin
        // code mem
            r_mem_instr[32'h67] <= 8'h00; r_mem_instr[32'h66] <= 8'h40; r_mem_instr[32'h65] <= 8'h23; r_mem_instr[32'h64] <= 8'h03; 
            // lw x6,4(x0)

            r_mem_instr[32'h6B] <= 8'h00; r_mem_instr[32'h6A] <= 8'h60; r_mem_instr[32'h69] <= 8'h24; r_mem_instr[32'h68] <= 8'h23;
            // sw x6,8(x0)

            r_mem_instr[32'h6F] <= 8'h09; r_mem_instr[32'h6E] <= 8'h00; r_mem_instr[32'h6D] <= 8'h03; r_mem_instr[32'h6C] <= 8'h93; 
            // addi x7,x0,0x90

            r_mem_instr[32'h73] <= 8'h00; r_mem_instr[32'h72] <= 8'h03; r_mem_instr[32'h71] <= 8'h80; r_mem_instr[32'h70] <= 8'he7;
            // jalr x1,0(x7)

            r_mem_instr[32'h77] <= 8'hfe; r_mem_instr[32'h76] <= 8'h10; r_mem_instr[32'h75] <= 8'h88; r_mem_instr[32'h74] <= 8'he3;
            // beq x1,x1,-16


            r_mem_instr[32'h93] <= 8'h00; r_mem_instr[32'h92] <= 8'h12; r_mem_instr[32'h91] <= 8'h82; r_mem_instr[32'h90] <= 8'h93;
            // addi x5,x5,1

            r_mem_instr[32'h97] <= 8'h02; r_mem_instr[32'h96] <= 8'h50; r_mem_instr[32'h95] <= 8'h29; r_mem_instr[32'h94] <= 8'h23;
            // sw x5,0x32(x0)

            r_mem_instr[32'h9b] <= 8'h00; r_mem_instr[32'h9a] <= 8'h00; r_mem_instr[32'h99] <= 8'h80; r_mem_instr[32'h98] <= 8'he7;
            // jalr x1,x1,0


    end


endmodule