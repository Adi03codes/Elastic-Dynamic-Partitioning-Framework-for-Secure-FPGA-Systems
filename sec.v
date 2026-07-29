`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Elastic Dynamic Partitioning Framework
// Module  : security_monitor
//////////////////////////////////////////////////////////////////////////////////

module security_monitor(

    input clk,
    input rst,

    input parity_error,
    input timeout_error,
    input voltage_fault,
    input temperature_fault,

    output reg anomaly_detected,
    output reg [1:0] severity

);

//---------------------------------------------------------
// Security Monitor
//---------------------------------------------------------

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        anomaly_detected <= 1'b0;
        severity <= 2'b00;

    end

    else
    begin

        anomaly_detected <= 1'b0;
        severity <= 2'b00;

        //-------------------------------------------------
        // Critical Fault
        //-------------------------------------------------

        if(voltage_fault || temperature_fault)
        begin
            anomaly_detected <= 1'b1;
            severity <= 2'b11;
        end

        //-------------------------------------------------
        // Medium Fault
        //-------------------------------------------------

        else if(timeout_error)
        begin
            anomaly_detected <= 1'b1;
            severity <= 2'b10;
        end

        //-------------------------------------------------
        // Minor Fault
        //-------------------------------------------------

        else if(parity_error)
        begin
            anomaly_detected <= 1'b1;
            severity <= 2'b01;
        end

    end

end

endmodule