module IF_Mem_Decoder(
    input [31:0] i_addr_f,
    output o_tv_en,
    output o_rv_en,
    output o_txt_en
);


wire w_dm_en;
assign w_dm_en = i_addr_f[20];

assign o_tv_en = !w_dm_en && !i_addr_f[19] && !i_addr_f[18];
assign o_rv_en = !w_dm_en && !i_addr_f[19] && i_addr_f[18];
assign o_txt_en = !w_dm_en && i_addr_f[19] && !i_addr_f[18];


endmodule