module ultrasonic_sensor(
    input clk,
    input rst,
    output reg trig,
    input echo, 
    output reg [15:0] distance
    );
    
    reg [19:0] trig_counter = 0;
    reg [19:0] echo_counter = 0;
    reg measuring = 0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trig_counter <= 0;
            echo_counter <= 0;
            trig <= 0;
            measuring <= 0;
            distance <= 0;
        end
        else begin
            // Tetik sinyali gönderme
            if (trig_counter < 1000)  // 10us tetik sinyali
                trig <= 1;
            else
                trig <= 0;
            trig_counter <= trig_counter + 1;
            
            // Yankı sinyalini ölçme
            if (echo == 1) begin
                echo_counter <= echo_counter + 1;
                measuring <= 1;
            end
            else if (measuring) begin
                // Yankı bittiğinde mesafe hesapla
                distance <= echo_counter / 58;  // uS to cm
                echo_counter <= 0;
                measuring <= 0;
            end
            
            if (trig_counter >= 1200000)  // 60ms aralık ile ölçüm döngüsü
                trig_counter <= 0;
        end
    end
endmodule
