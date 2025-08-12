module Mem_Instr(
    input i_rst,
    input [31:0] i_adr,
    output [31:0] o_instr
);

    reg [7:0] r_mem_instr [128:0];

    reg [31:0] r_instr_out;
    assign {o_instr[31:24] , o_instr[23:16] , o_instr[15:8] , o_instr[7:0]} = 
           {r_mem_instr[i_adr+3] , r_mem_instr[i_adr+2] , r_mem_instr[i_adr+1] , r_mem_instr[i_adr]};

    always@(posedge i_rst)
    begin
        r_mem_instr[32'h3] = 8'h00 ; r_mem_instr[32'h2] = 8'h40 ; r_mem_instr[32'h1] = 8'h02 ; r_mem_instr[32'h0] = 8'h93 ;
        //addi x5,zero,4;

        r_mem_instr[32'h7] = 8'h00 ; r_mem_instr[32'h6] = 8'h42 ; r_mem_instr[32'h5] = 8'ha3 ; r_mem_instr[32'h4] = 8'h83 ;
        //lw x7,4(x5)

        r_mem_instr[32'hb] = 8'h00 ; r_mem_instr[32'ha] = 8'h53 ; r_mem_instr[32'h9] = 8'h82 ; r_mem_instr[32'h8] = 8'hb3 ;
        //add x5,x7,x5

        r_mem_instr[32'hf] = 8'h00 ; r_mem_instr[32'he] = 8'h53 ; r_mem_instr[32'hd] = 8'he3 ; r_mem_instr[32'hc] = 8'hb3 ;
        //or x7,x7,x5

        r_mem_instr[32'h13] = 8'h00 ; r_mem_instr[32'h12] = 8'h53 ; r_mem_instr[32'h11] = 8'hf3 ; r_mem_instr[32'h10] = 8'hb3 ;
        //and x7,x7,x5

        r_mem_instr[32'h17] = 8'h00 ; r_mem_instr[32'h16] = 8'h80 ; r_mem_instr[32'h15] = 8'h02 ; r_mem_instr[32'h14] = 8'h93 ;
        //addi x5,zero,8

        r_mem_instr[32'h1b] = 8'h00 ; r_mem_instr[32'h1a] = 8'h70 ; r_mem_instr[32'h19] = 8'h03 ; r_mem_instr[32'h18] = 8'h13 ;
        //addi x6,zero,7

        r_mem_instr[32'h1f] = 8'h02 ; r_mem_instr[32'h1e] = 8'h62 ; r_mem_instr[32'h1d] = 8'h88 ; r_mem_instr[32'h1c] = 8'h63 ;
        //beq x5,x6,0x30 (L1)

        r_mem_instr[32'h23] = 8'h00 ; r_mem_instr[32'h22] = 8'h13 ; r_mem_instr[32'h21] = 8'h03 ; r_mem_instr[32'h20] = 8'h13 ;
        //addi x6,x6,1

        r_mem_instr[32'h27] = 8'h02 ; r_mem_instr[32'h26] = 8'h62 ; r_mem_instr[32'h25] = 8'h88 ; r_mem_instr[32'h24] = 8'h63 ;
        //beq x5,x6,0x30 (L1)

        r_mem_instr[32'h2b] = 8'h00 ; r_mem_instr[32'h2a] = 8'h40 ; r_mem_instr[32'h29] = 8'h00 ; r_mem_instr[32'h28] = 8'h93 ;
        //addi x1,zero,4

        r_mem_instr[32'h2f] = 8'h00 ; r_mem_instr[32'h2e] = 8'h80 ; r_mem_instr[32'h2d] = 8'h01 ; r_mem_instr[32'h2c] = 8'h13 ;
        //addi x2,zero,8




        r_mem_instr[32'h33] = 8'h01 ; r_mem_instr[32'h32] = 8'h00 ; r_mem_instr[32'h31] = 8'h02 ; r_mem_instr[32'h30] = 8'h93; // (L1)
        //addi x5,zero,16

        r_mem_instr[32'h37] = 8'h00 ; r_mem_instr[32'h36] = 8'h02 ; r_mem_instr[32'h35] = 8'ha3; r_mem_instr[32'h34] = 8'h03 ;
        //lw x6,0(x5)

        r_mem_instr[32'h3b] = 8'h02 ; r_mem_instr[32'h3a] = 8'h62 ; r_mem_instr[32'h39] = 8'ha0 ; r_mem_instr[32'h38] = 8'h23 ;
        //sw x6,32(x5)

        r_mem_instr[32'h3f] = 8'h06 ; r_mem_instr[32'h3e] = 8'h00 ; r_mem_instr[32'h3d] = 8'h00 ; r_mem_instr[32'h3c] = 8'hef ;
        //jal x1,0x60 (L2)

        r_mem_instr[32'h43] = 8'h02 ; r_mem_instr[32'h42] = 8'h52 ; r_mem_instr[32'h41] = 8'h88 ; r_mem_instr[32'h40] = 8'h63 ;
        //beq x5,x5,0x30 (L1)

        r_mem_instr[32'h47] = 8'h00 ; r_mem_instr[32'h46] = 8'h00 ; r_mem_instr[32'h45] = 8'h00 ; r_mem_instr[32'h44] = 8'h13 ;
        //addi x0,x0,0

        r_mem_instr[32'h4b] = 8'h00 ; r_mem_instr[32'h4a] = 8'h00 ; r_mem_instr[32'h49] = 8'h00 ; r_mem_instr[32'h48] = 8'h13 ;
        //addi x0,x0,0



        r_mem_instr[32'h63] = 8'h00 ; r_mem_instr[32'h62] = 8'h13 ; r_mem_instr[32'h61] = 8'h03 ; r_mem_instr[32'h60] = 8'h13 ; // (L2)
        //addi x6,x6,1

        r_mem_instr[32'h67] = 8'h00 ; r_mem_instr[32'h66] = 8'h00 ; r_mem_instr[32'h65] = 8'h80 ; r_mem_instr[32'h64] = 8'he7 ;
        //jalr x1,0(x1)

        r_mem_instr[32'h6b] = 8'h00 ; r_mem_instr[32'h6a] = 8'h00 ; r_mem_instr[32'h69] = 8'h00 ; r_mem_instr[32'h68] = 8'h13 ;
        //addi x0,x0,0

        r_mem_instr[32'h6f] = 8'h00 ; r_mem_instr[32'h6e] = 8'h00 ; r_mem_instr[32'h6d] = 8'h00 ; r_mem_instr[32'h6c] = 8'h13 ;
        //addi x0,x0,0


    end


endmodule