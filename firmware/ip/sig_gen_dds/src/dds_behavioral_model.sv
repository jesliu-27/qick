//-----------------------------------------------------------------------------
// Title      : Direct Digital Synthesis (DDS) Behavioral Model
// Project    : HRL Clinic 2025-26
//-----------------------------------------------------------------------------
// File       : dds_behavioral_model.sv
// Author     : Jessic Liu
// Date       : 09/16/2025
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module dds_behavioral_model # (
    // Reserve for Parameters
    parameter LUT_SIZE = 32 // Lookup Table size
) (
    input   logic        aclk, // clock at @ ??? MHz
    input   logic        s_axis_phase_tvalid,
    input   logic [71:0] s_axis_phase_tdata,
    output  logic        m_axis_data_tvalid,
    output  logic [31:0] m_axis_data_tdata
)

logic [31:0] phase_inc;     // PINC from AXIS
logic [31:0] phase_acc;     // phase accumulator result


// --------- UNPACK s_axis_phase_data --------------------------
// s_axis_phase_tdata format
// |------------|------------|------------|------------|
// |    71 .. 65|          64|    63 .. 32|     31 .. 0|
// |------------|------------|------------|------------|
// |       7'h00|            |            |        PINC|
// |------------|------------|------------|------------|
// Phase Increment (PINC): 32 bit, phase step per clock the downstream DDS accumulator should add.
// phase_v1_r1: 32 bit, phase seed to load into the DDS accumulator on a sync/load event.
// sync_reg_r7: 1, 1-bit strobe telling the DDS to load those values this cycle.

assign phase_inc = s_axis_phase_tdata[31:0];
// --------- PHASE ACCUMULATOR -------------------
always_ff @(posedge aclk) begin
    if(!s_axis_phase_tvalid) begin
        phase_acc <= phase_acc; 
    end else begin
        phase_acc = phase_acc + phase_inc; 
    end
end

// --------- SINE LUT ----------------------------


endmodule