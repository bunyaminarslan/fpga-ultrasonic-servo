module radar_system(
    input wire clk,             // 100MHz clock from Basys-3 board
    input wire rst,             // Reset signal
    output wire pwm,            // Servo motor PWM control
    output wire trig,           // Ultrasonic sensor trig signal
    input wire echo,            // Ultrasonic sensor echo signal
    output wire [3:0] vga_red,  // VGA Red signal (4-bit)
    output wire [3:0] vga_green,// VGA Green signal (4-bit)
    output wire [3:0] vga_blue, // VGA Blue signal (4-bit)
    output wire hsync,          // VGA horizontal sync
    output wire vsync           // VGA vertical sync
);

    // Signals for the ultrasonic sensor
    wire [15:0] distance;
    
    // Clock divider to generate 25MHz for VGA
    reg [1:0] clk_div = 2'b00;
    wire clk_25MHz;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_div <= 2'b00;
        end else begin
            clk_div <= clk_div + 1;
        end
    end
    assign clk_25MHz = clk_div[1];
    
    // Instantiate servo motor module
    servo_motor servo_inst(
        .clk(clk),
        .duty_cycle(8'd90),  // Example duty cycle (should be adjusted according to your design)
        .servo_control(pwm)
    );
    
    // Instantiate ultrasonic sensor module
    ultrasonic_sensor sensor_inst(
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .echo(echo),
        .distance(distance)
    );
    
   //VGA signal generation
   wire [9:0] pixel_x, pixel_y;
   parameter video_on = 1;
 
   vga_controller vga_inst(
       .pin_sysclk(clk),
//       .rst(rst),
       .pin_vga_hsync_n(pin_vga_hsync_n),
       .pin_vga_vsync_n(pin_vga_vsync_n)
//       .vga_pixel_row(vga_pixel_row),
//       .vga_pixel_column(vga_pixel_column)
//       .video_on(video_on)
   );
 
   // Radar display logic
   reg [3:0] red, green, blue;
 
   always @(*) begin
       if (video_on) begin
           // Simple radar display: color changes with distance
           if (pixel_x < distance[9:0]) begin
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
