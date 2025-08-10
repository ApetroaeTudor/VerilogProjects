module TOP(
    input i_clk,
    input i_rst_n,
    input i_enable_btn,
    
    output o_led_signal,
    output o_debug
);

    wire i_enable_btn_p;
    wire i_rst_p;
    
    assign i_rst_p = ~ i_rst_n;
    assign i_enable_btn_p = ~i_enable_btn;

    wire w_debounced_btn;
    wire w_debounced_rst_p;


    Debounce Debounce_Btn_Inst(.i_clk(i_clk),
                               .i_btn(i_enable_btn_p),
                               .o_btn(w_debounced_btn));

    Debounce Debounce_Rst_Inst(.i_clk(i_clk),
                               .i_btn(i_rst_p),
                               .o_btn(w_debounced_rst_p));

    

    wire w_d_s_btn;
    wire w_d_s_rst_p;
    Sync Sync_Btn_Inst(.i_clk(i_clk),
                       .i_signal(w_debounced_btn),
                       .o_signal(w_d_s_btn));

    Sync Sync_Rst_Inst(.i_clk(i_clk),
                       .i_signal(w_debounced_rst_p),
                       .o_signal(w_d_s_rst_p));


    wire w_d_s_o_btn;
    wire w_d_s_o_rst_p;
    One_Period One_Period_Btn_Inst(.i_clk(i_clk),
                                   .i_sync_signal(w_d_s_btn),
                                   .o_op_signal(w_d_s_o_btn));
    
    One_Period One_Period_Rst_Inst(.i_clk(i_clk),
                                   .i_sync_signal(w_d_s_rst_p),
                                   .o_op_signal(w_d_s_o_rst_p));

    

    wire [31:0] w_mem_location_32h;
    Single_Cycle Single_Cycle_Inst(.i_clk(i_clk),
                                   .i_enable_btn_d_s_o(w_d_s_o_btn),
                                   .i_rst_n(~w_d_s_o_rst_p),
                                   .o_mem_location_32h(w_mem_location_32h));


    LED_Control LED_Control_Inst(.i_clk(i_clk),
                                 .i_rst_n(~w_d_s_o_rst_p),
                                 .i_mem_link(w_mem_location_32h),
                                 .o_led_signal(o_led_signal));   
    



    reg r_debug = 1'b1;
    assign o_debug = r_debug;
    always@(posedge i_clk)
    begin
        if(w_d_s_o_btn)
        begin
            r_debug<=~r_debug;
        end
    end

                   


endmodule