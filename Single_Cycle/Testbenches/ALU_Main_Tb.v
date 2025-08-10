module ALU_Main_Tb;

reg [31:0] t_r_op_a;
reg [31:0] t_r_op_b;

reg [2:0] t_r_alu_op;

wire t_w_zero;
wire [31:0] t_w_alu_out;

ALU_Main DUT(.i_op_a(t_r_op_a),
             .i_op_b(t_r_op_b),
             .i_alu_op(t_r_alu_op),
             .o_zero(t_w_zero),
             .o_alu_out(t_w_alu_out));

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,ALU_Main_Tb);
    t_r_op_a=32'h0012_3455;
    t_r_op_b=32'h0012_3456;
    $display("Op a = %h Op b = %h", t_r_op_b,t_r_op_b);

    t_r_alu_op=3'b000; // add
    #10;
    $display("ALU_OUT = %h, zero = %0d", t_w_alu_out,t_w_zero);
    
    t_r_alu_op=3'b001; // sub
    #10;
    $display("ALU_OUT = %h, zero = %0d", t_w_alu_out,t_w_zero);

    t_r_alu_op=3'b010; // and
    #10;
    $display("ALU_OUT = %h, zero = %0d", t_w_alu_out,t_w_zero);

    t_r_alu_op=3'b011; // or
    #10;
    $display("ALU_OUT = %h, zero = %0d", t_w_alu_out,t_w_zero);

    t_r_alu_op=3'b101; // slt
    #10;
    $display("ALU_OUT = %h, zero = %0d", t_w_alu_out,t_w_zero);

    #1000
    $finish;

end

endmodule