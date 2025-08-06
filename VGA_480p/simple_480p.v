
module simple_480p #(
    parameter H_ACTIVE = 640,
    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC_WIDTH = 96,
    parameter H_BACK_PORCH = 48,
    parameter H_TOTAL_PX = 800,

    parameter V_ACTIVE = 480,
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC_WIDTH = 2,
    parameter V_BACK_PORCH = 33,
    parameter V_TOTAL_PX = 525

)(
    input i_pix_clk, // 800*525*60 = 25.2MHZ
    input i_pix_rst,
    
    output [9:0] o_sx,
    output [9:0] o_sy,

    output [3:0] o_display_red_4b,
    output [3:0] o_display_green_4b,
    output [3:0] o_display_blue_4b,

    output o_hsync,
    output o_vsync,

    output o_de
);

    reg [9:0] r_sx;
    assign o_sx = r_sx;
    reg [9:0] r_sy;
    assign o_sy = r_sy;

    localparam H_ACTIVE_END = H_ACTIVE-1;
    localparam H_SYNC_START = H_ACTIVE_END+H_FRONT_PORCH;
    localparam H_SYNC_END = H_SYNC_START + H_SYNC_WIDTH;
    localparam LINE = H_TOTAL_PX-1;

    localparam V_ACTIVE_END = V_ACTIVE-1;
    localparam V_SYNC_START = V_ACTIVE_END+V_FRONT_PORCH;
    localparam V_SYNC_END = V_SYNC_START+V_SYNC_WIDTH;
    localparam SCREEN = V_TOTAL_PX-1;


    assign o_hsync = (r_sx>=H_SYNC_START && r_sx<H_SYNC_END)?0:1; //negative polarity
    assign o_vsync = (r_sy>=V_SYNC_START && r_sy<V_SYNC_END)?0:1; 
    assign o_de = (r_sx < H_ACTIVE) && (r_sy < V_ACTIVE);
    always@(posedge i_pix_clk or negedge i_pix_rst)
    begin
        if(!i_pix_rst)
        begin
            r_sx <= 0;
            r_sy <= 0;
    end
    else
    begin
        if(r_sx == LINE)
        begin
            r_sx <= 0;
            if(r_sy == SCREEN) 
            begin
                r_sy <= 0;
            end
            else 
            begin
                r_sy <= r_sy + 1'b1;
            end
        end
        else 
        begin
            r_sx <= r_sx + 1'b1;
        end
   end
end


    wire w_square;
    assign w_square = (r_sx>260 && r_sx<460) && (r_sy > 140 && r_sy < 340); 
    // square in the middle of the screen

    // white square in the middle of blue bg
    // VGA/DVI - 12 bit color, 4 bits per color channer

    wire [3:0] w_paint_red;
    wire [3:0] w_paint_green;
    wire [3:0] w_paint_blue;
 
    assign w_paint_red = (w_square)?4'b1111:4'h1; // all colors maxed if in square => white
    assign w_paint_green = (w_square)?4'b1111:4'h3;
    assign w_paint_blue = (w_square)?4'b1111:4'h7;

    assign o_display_red_4b = (o_de)?w_paint_red:4'hF; // full red for debug
    assign o_display_green_4b = (o_de)?w_paint_green:4'b0;
    assign o_display_blue_4b = (o_de)?w_paint_blue:4'b0;

    // during the blink period colors must be black




endmodule
