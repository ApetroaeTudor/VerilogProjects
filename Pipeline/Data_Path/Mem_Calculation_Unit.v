module Mem_Calculation_Unit(
    input [31:0] i_addr_m,
    output [31:0] o_effective_addr_m,

    output o_glb_en,
    output o_stk_en,
    output o_io_en,
    output o_dm_en
);

// 2MB memory
// 0x00000000 - 0x001fffff

// 0x00000000 - 0x000fffff -> Instr Mem
// 0x000fffff - 0x001fffff -> Data Mem

// Data Mem -> effective addr = i_addr - 0x00100000
//   dm_en = i_addr_m[20]


assign o_dm_en = i_addr_m[20];

assign o_glb_en = o_dm_en && !i_addr_m[19] && !i_addr_m[18];
assign o_stk_en = o_dm_en && !i_addr_m[19] && i_addr_m[18];
assign o_io_en = o_dm_en && i_addr_m[19];

assign o_effective_addr_m = (o_dm_en)?
    {i_addr_m[31:20]&12'b0,i_addr_m[19:0]}:i_addr_m;

endmodule