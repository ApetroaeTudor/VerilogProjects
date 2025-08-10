module Mem_Instruction_Tb;
reg t_r_rst;
reg [31:0] t_r_pc;
wire [31:0] t_w_instr;

Mem_Instruction DUT(.i_rst(t_r_rst),
                    .i_pc(t_r_pc),
                    .o_instr(t_w_instr));

integer i;
initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,Mem_Instruction_Tb);
    t_r_rst=1'b1;
    t_r_pc=32'h64;
    i=32'h64;

    #10
    repeat(16)
    begin   
        $display("Mem[%h] = %h", i,DUT.r_mem_instr[i]);
        
        t_r_pc = t_r_pc+32'd1;
        i = i + 1;
        #10;
    end

    #1000
    $finish;
end

endmodule