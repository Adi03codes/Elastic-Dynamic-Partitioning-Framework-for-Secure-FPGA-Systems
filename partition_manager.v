`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Elastic Dynamic Partitioning Framework for Secure FPGA Systems
// Module  : partition_manager
// Author  : Adinath M
//////////////////////////////////////////////////////////////////////////////////

module partition_manager(

    input clk,
    input rst,

    input [1:0] partition_request,
    input reconfig_done,

    output reg [3:0] active_partition,
    output reg partition_busy,
    output reg reconfig_start

);

//---------------------------------------------------------
// State Encoding
//---------------------------------------------------------

parameter IDLE        = 3'd0;
parameter SELECT      = 3'd1;
parameter ACTIVATE    = 3'd2;
parameter WAIT_DONE   = 3'd3;
parameter COMPLETE    = 3'd4;

reg [2:0] state;

//---------------------------------------------------------
// FSM
//---------------------------------------------------------

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        state <= IDLE;
        active_partition <= 4'b0001;
        partition_busy <= 0;
        reconfig_start <= 0;

    end

    else

    begin

        case(state)

        //-------------------------------------------------
        IDLE:
        //-------------------------------------------------

        begin

            partition_busy <= 0;
            reconfig_start <= 0;

            if(partition_request != 2'b00)
                state <= SELECT;

        end

        //-------------------------------------------------
        SELECT:
        //-------------------------------------------------

        begin

            partition_busy <= 1;

            case(partition_request)

                2'b00: active_partition <= 4'b0001;

                2'b01: active_partition <= 4'b0010;

                2'b10: active_partition <= 4'b0100;

                2'b11: active_partition <= 4'b1000;

            endcase

            state <= ACTIVATE;

        end

        //-------------------------------------------------
        ACTIVATE:
        //-------------------------------------------------

        begin

            reconfig_start <= 1;
            state <= WAIT_DONE;

        end

        //-------------------------------------------------
        WAIT_DONE:
        //-------------------------------------------------

        begin

            if(reconfig_done)
            begin

                reconfig_start <= 0;
                state <= COMPLETE;

            end

        end

        //-------------------------------------------------
        COMPLETE:
        //-------------------------------------------------

        begin

            partition_busy <= 0;
            state <= IDLE;

        end

        //-------------------------------------------------

        default:

            state <= IDLE;

        //-------------------------------------------------

        endcase

    end

end

endmodule