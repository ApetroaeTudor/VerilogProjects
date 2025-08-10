module One_Period(
   input i_clk,
   input i_sync_signal,
   output o_op_signal
);

   reg r_previous_signal = 1'b0;
   assign o_op_signal = ~r_previous_signal & i_sync_signal;

   always@(posedge i_clk)
   begin
       r_previous_signal <= i_sync_signal;
   end

endmodule