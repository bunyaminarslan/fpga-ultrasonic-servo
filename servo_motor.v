module servo_motor (
    input wire clk,                 // Saat sinyali (örneğin 50 MHz)
    input wire [7:0] duty_cycle,    // Duty cycle (0-180 derece arası kontrol)
    output reg servo_control        // PWM çıkışı
);
    // Sabitler
    parameter CLOCK_FREQ = 50_000_000; // Saat frekansı (50 MHz)
    parameter PWM_PERIOD = 20_000_000; // 20 ms PWM periyodu (50 Hz)

    reg [31:0] counter = 0;         // Sayaç
    reg [31:0] pwm_high_time = 0;   // PWM yüksek süre (duty cycle'a göre ayarlanır)

    always @(posedge clk) begin
        // PWM yüksek zamanını duty_cycle'a göre ayarla (1 ms - 2 ms arası)
        pwm_high_time <= (1000 + (duty_cycle * 1000 / 180)) * (CLOCK_FREQ / 1000);

        // Sayaç PWM periyoduna ulaştığında sıfırlanır
        if (counter >= PWM_PERIOD) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // PWM sinyali üretimi
        if (counter < pwm_high_time) begin
            servo_control <= 1;
        end else begin
            servo_control <= 0;
        end
    end
endmodule
