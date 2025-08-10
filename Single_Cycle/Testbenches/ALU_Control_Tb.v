module ALU_Control_Tb;
reg [1:0] t_r_alu_ctl;
reg [2:0] t_r_f3;
reg t_r_op5;

wire [2:0] t_w_alu_op;

ALU_Control DUT(.i_alu_ctl(t_r_alu_ctl),
                .i_f3(t_r_f3),
                .i_op5(t_r_op5),
                .o_alu_op(t_w_alu_op));

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,ALU_Control_Tb);
    t_r_alu_ctl = 2'b00;
    t_r_f3=3'b111;
    t_r_op5=1'b1;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_alu_ctl = 2'b01;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_alu_ctl = 2'b10;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_f3 = 3'b110;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_f3 = 3'b010;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_f3 = 3'b000;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_op5=1'b0;
    #10
    $display("ALUOP = %b",t_w_alu_op);

    t_r_f3 = 3'b001;
    #10
    $display("ALUOP = %b",t_w_alu_op);

end

endmodule