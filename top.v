module dpr_controller(
    input clk,
    input rst,
    input anomaly_detected,
    input reconfig_done,

    output reg start_reconfig,
    output reg [1:0] state
);

localparam IDLE      = 2'b00;
localparam DETECT    = 2'b01;
localparam RECONFIG  = 2'b10;
localparam COMPLETE  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        start_reconfig <= 0;
    end
    else
    begin
        case(state)

        IDLE:
        begin
            start_reconfig <= 0;
            if(anomaly_detected)
                state <= DETECT;
        end

        DETECT:
        begin
            start_reconfig <= 1;
            state <= RECONFIG;
        end

        RECONFIG:
        begin
            if(reconfig_done)
            begin
                start_reconfig <= 0;
                state <= COMPLETE;
            end
        end

        COMPLETE:
        begin
            state <= IDLE;
        end

        endcase
    end
end

endmodule