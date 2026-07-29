`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Elastic Dynamic Partitioning Framework
// Module  : resource_allocator
//////////////////////////////////////////////////////////////////////////////////

module resource_allocator(

    input clk,
    input rst,

    input allocate,
    input release,

    input [1:0] request_partition,

    output reg allocation_success,
    output reg allocation_failed,

    output reg [3:0] partition_status

);

//---------------------------------------------------------
// Partition Status
// 0 = Free
// 1 = Allocated
//---------------------------------------------------------

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        partition_status <= 4'b0000;
        allocation_success <= 1'b0;
        allocation_failed <= 1'b0;

    end

    else
    begin

        allocation_success <= 1'b0;
        allocation_failed <= 1'b0;

        //-------------------------------------------------
        // Allocate Request
        //-------------------------------------------------

        if(allocate)
        begin

            case(request_partition)

                2'd0:
                begin
                    if(!partition_status[0])
                    begin
                        partition_status[0] <= 1'b1;
                        allocation_success <= 1'b1;
                    end
                    else
                        allocation_failed <= 1'b1;
                end

                2'd1:
                begin
                    if(!partition_status[1])
                    begin
                        partition_status[1] <= 1'b1;
                        allocation_success <= 1'b1;
                    end
                    else
                        allocation_failed <= 1'b1;
                end

                2'd2:
                begin
                    if(!partition_status[2])
                    begin
                        partition_status[2] <= 1'b1;
                        allocation_success <= 1'b1;
                    end
                    else
                        allocation_failed <= 1'b1;
                end

                2'd3:
                begin
                    if(!partition_status[3])
                    begin
                        partition_status[3] <= 1'b1;
                        allocation_success <= 1'b1;
                    end
                    else
                        allocation_failed <= 1'b1;
                end

            endcase

        end

        //-------------------------------------------------
        // Release Request
        //-------------------------------------------------

        if(release)
        begin

            case(request_partition)

                2'd0: partition_status[0] <= 1'b0;
                2'd1: partition_status[1] <= 1'b0;
                2'd2: partition_status[2] <= 1'b0;
                2'd3: partition_status[3] <= 1'b0;

            endcase

        end

    end

end

endmodule