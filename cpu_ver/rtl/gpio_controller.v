module gpio_4pins (
    input wire clk,
    input wire reset,
    input wire [3:0] dir,
    input wire [3:0] out_data,
    inout wire [3:0] pins,
    output reg [3:0] in_data
);
    assign pins[0] = (dir[0]) ? out_data[0] : 1'bz;
    assign pins[1] = (dir[1]) ? out_data[1] : 1'bz;
    assign pins[2] = (dir[2]) ? out_data[2] : 1'bz;
    assign pins[3] = (dir[3]) ? out_data[3] : 1'bz;

    always @(posedge clk or posedge reset) begin
        if (reset) in_data <= 4'b0;
        else begin
            if (!dir[0]) in_data[0] <= pins[0];
            if (!dir[1]) in_data[1] <= pins[1];
            if (!dir[2]) in_data[2] <= pins[2];
            if (!dir[3]) in_data[3] <= pins[3];
        end
    end
endmodule

module gpio_28pins (
    input wire clk,
    input wire reset,
    input wire [27:0] dir,
    input wire [27:0] out_data,
    inout wire [27:0] pins,
    output wire [27:0] in_data
);

    // Instantiate 7 groups of 4 GPIOs
    gpio_4pins group0 (
        .clk(clk), .reset(reset),
        .dir(dir[3:0]), .out_data(out_data[3:0]), .pins(pins[3:0]), .in_data(in_data[3:0])
    );
    gpio_4pins group1 (
        .clk(clk), .reset(reset),
        .dir(dir[7:4]), .out_data(out_data[7:4]), .pins(pins[7:4]), .in_data(in_data[7:4])
    );
    gpio_4pins group2 (
        .clk(clk), .reset(reset),
        .dir(dir[11:8]), .out_data(out_data[11:8]), .pins(pins[11:8]), .in_data(in_data[11:8])
    );
    gpio_4pins group3 (
        .clk(clk), .reset(reset),
        .dir(dir[15:12]), .out_data(out_data[15:12]), .pins(pins[15:12]), .in_data(in_data[15:12])
    );
    gpio_4pins group4 (
        .clk(clk), .reset(reset),
        .dir(dir[19:16]), .out_data(out_data[19:16]), .pins(pins[19:16]), .in_data(in_data[19:16])
    );
    gpio_4pins group5 (
        .clk(clk), .reset(reset),
        .dir(dir[23:20]), .out_data(out_data[23:20]), .pins(pins[23:20]), .in_data(in_data[23:20])
    );
    gpio_4pins group6 (
        .clk(clk), .reset(reset),
        .dir(dir[27:24]), .out_data(out_data[27:24]), .pins(pins[27:24]), .in_data(in_data[27:24])
    );

endmodule
