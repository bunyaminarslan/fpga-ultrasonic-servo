module radar_system(
    input clk,             // 100MHz clock from Basys-3 board
    input rst,             // Reset signal
    output pwm,            // Servo motor PWM control
    output trig,           // Ultrasonic sensor trig signal
    input echo,            // Ultrasonic sensor echo signal
    output [3:0] vga_red,  // VGA Red signal (4-bit)
    output [3:0] vga_green,// VGA Green signal (4-bit)
    output [3:0] vga_blue, // VGA Blue signal (4-bit)
    output hsync,          // VGA horizontal sync
    output vsync           // VGA vertical sync
);

    // Signals for the ultrasonic sensor
    wire [15:0] distance;
    
    // Clock divider to generate 25MHz for VGA
    reg [1:0] clk_div;
    wire clk_25MHz;
    
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    assign clk_25MHz = clk_div[1];
    
    // Instantiate servo motor module
    servo_motor servo_inst(
        .clk(clk),
        .rst(rst),
        .pwm(pwm)
    );
    
    // Instantiate ultrasonic sensor module
    ultrasonic_sensor sensor_inst(
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .echo(echo),
        .distance(distance)
    );
    
    // VGA signal generation
    wire [9:0] pixel_x, pixel_y;
    wire video_on;
    
//    vga_controller vga_inst(
//        .clk(clk_25MHz),
//        .rst(rst),
//        .hsync(hsync),
//        .vsync(vsync)
////        .pixel_x(pixel_x),
////        .pixel_y(pixel_y),
////        .video_on(video_on)
//    );
    
    // Radar display logic
    reg [3:0] red, green, blue;
    
    always @(*) begin
        if (video_on) begin
            // Simple radar display: color changes with distance
            if (pixel_x == distance[9:0]) begin
                red = 4'b1111;
                green = 4'b0000;
                blue = 4'b0000;
            end else begin
                red = 4'b0000;
                green = 4'b1111;
                blue = 4'b0000;
            end
        end else begin
            red = 4'b0000;
            green = 4'b0000;
            blue = 4'b0000;
        end
    end
    
    assign vga_red = red;
    assign vga_green = green;
    assign vga_blue = blue;

endmodule
