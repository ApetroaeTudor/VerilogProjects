module hdmi_top(
    input i_clk,
    input i_rst_n,

    output o_ELVDS_HDMI_CLK_P,
    output o_ELVDS_HDMI_CLK_N,

    output [2:0] o_ELVDS_HDMI_DATA_P, // ch 0 - BLUE, ch 1 - GREEN, ch 2 - RED
    output [2:0] o_ELVDS_HDMI_DATA_N

);

    wire [9:0] w_sx;
    wire [9:0] w_sy;

    wire [3:0] w_display_red_4b;
    wire [3:0] w_display_green_4b;
    wire [3:0] w_display_blue_4b;

    wire [7:0] w_display_red_8b;
    wire [7:0] w_display_green_8b;
    wire [7:0] w_display_blue_8b;

    assign w_display_red_8b = {w_display_red_4b,w_display_red_4b};
    assign w_display_green_8b = {w_display_green_4b,w_display_green_4b};
    assign w_display_blue_8b = {w_display_blue_4b,w_display_blue_4b};

    wire w_hsync;
    wire w_vsync;

    wire w_de;

    wire w_clk_27m;
    wire w_clk_270m;



    simple_480p simple_480p_inst(.i_pix_clk(w_clk_27m),
                                 .i_pix_rst(i_rst_n),
                                 .o_sx(w_sx),
                                 .o_sy(w_sy),
                                 .o_display_red_4b(w_display_red_4b),
                                 .o_display_green_4b(w_display_green_4b),
                                 .o_display_blue_4b(w_display_blue_4b),
                                 .o_hsync(w_hsync),
                                 .o_vsync(w_vsync),
                                 .o_de(w_de));


    
    Gowin_rPLL IP_rPLL_27_270_27_inst(
        .clkout(w_clk_270m), //output clkout // 270
        .clkoutd(w_clk_27m), //output clkoutd // 27
        .clkin(i_clk) //input clkin // 27
    );



	DVI_TX_Top IP_DVI_TX_ELVDS(
		.I_rst_n(i_rst_n), //input I_rst_n
		.I_serial_clk(w_clk_270m), //input I_serial_clk
		.I_rgb_clk(w_clk_27m), //input I_rgb_clk
		.I_rgb_vs(w_vsync), //input I_rgb_vs
		.I_rgb_hs(w_hsync), //input I_rgb_hs
		.I_rgb_de(w_de), //input I_rgb_de
		.I_rgb_r(w_display_red_8b), //input [7:0] I_rgb_r
		.I_rgb_g(w_display_green_8b), //input [7:0] I_rgb_g
		.I_rgb_b(w_display_blue_8b), //input [7:0] I_rgb_b
		.O_tmds_clk_p(o_ELVDS_HDMI_CLK_P), //output O_tmds_clk_p
		.O_tmds_clk_n(o_ELVDS_HDMI_CLK_N), //output O_tmds_clk_n
		.O_tmds_data_p(o_ELVDS_HDMI_DATA_P), //output [2:0] O_tmds_data_p
		.O_tmds_data_n(o_ELVDS_HDMI_DATA_N) //output [2:0] O_tmds_data_n
	);


endmodule
