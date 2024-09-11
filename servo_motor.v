module servo_motor(
    input clk,
    input rst,
    output reg pwm
    );
    
    reg [19:0] counter = 0;  // 20ms'lik period için sayaç
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            pwm <= 0;
        end
        else begin
            counter <= counter + 1;
            if (counter < 200000)  // 2 ms boyunca lojik 1
                pwm <= 1;
            else
                pwm <= 0;  // 18 ms boyunca lojik 0
            if (counter >= 1000000)  // 20 ms'lik periyot
                counter <= 0;
        end
    end
endmodule
