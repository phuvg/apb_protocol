////////////////////////////////////////////////////////////////////////////////
// Filename    : tb_apb_protocol_read_without_wait_states.v
// Description : 
//
// Author      : Phu Vuong
// History     : May, 23 2022 : Initial 	
//
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module tb_apb_protocol_read_without_wait_states();
    ////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
    parameter                       ADDR_WIDTH = 8;
    parameter                       DATA_WIDTH = 8;
    parameter                       PSEL_WIDTH = 1;
    parameter                       CLK_PERIOD = 1; //T=1ns => F=1GHz
    ////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //clk and reset
    reg                           PCLK_i;
    reg                           PRESET_i;
    //-----------------------
    //mode (read/write)
    reg   [1:0]                   PMODE_i; //00:NOP  10:READ  11:WRITE
    wire                          PWRITE_o;
    //-----------------------
    //addr
    reg   [ADDR_WIDTH-1:0]        PADDR_i;
    wire  [ADDR_WIDTH-1:0]        PADDR_o;
    //-----------------------
    //select slave
    reg   [PSEL_WIDTH-1:0]        PSEL_i;
    //-----------------------
    //master control
    wire                          PENABLE_o;
    wire  [PSEL_WIDTH-1:0]        PSEL_o;
    reg                           PREADY_i;
    wire                          PREADY_o;
    //-----------------------
    //wrte/read data
    reg   [DATA_WIDTH-1:0]        PWDATA_i;
    wire  [DATA_WIDTH-1:0]        PWDATA_o;
    reg   [DATA_WIDTH-1:0]        PRDATA_i;
    wire  [DATA_WIDTH-1:0]        PRDATA_o;
    //-----------------------
    //error response
    wire                          PSLVERR_o;
    ////////////////////////////////////////////////////////////////////////////
    //testbench internal logic
    ////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    //instance
    ////////////////////////////////////////////////////////////////////////////
    apb_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .PSEL_WIDTH(PSEL_WIDTH)
    ) iapb_master_00(
        //-----------------------
        //clk and reset
        .PCLK_i(PCLK_i),
        .PRESET_i(PRESET_i),
        //-----------------------
        //mode (read/write)
        .PMODE_i(PMODE_i),
        .PWRITE_o(PWRITE_o),
        //-----------------------
        //addr
        .PADDR_i(PADDR_i),
        .PADDR_o(PADDR_o),
        //-----------------------
        //select slave
        .PSEL_i(PSEL_i),
        //-----------------------
        //master control
        .PENABLE_o(PENABLE_o),
        .PSEL_o(PSEL_o),
        .PREADY_i(PREADY_i),
        .PREADY_o(PREADY_o),
        //-----------------------
        //wrte/read data
        .PWDATA_i(PWDATA_i),
        .PWDATA_o(PWDATA_o),
        .PRDATA_i(PRDATA_i),
        .PRDATA_o(PRDATA_o),
        //-----------------------
        //error response
        .PSLVERR_o(PSLVERR_o)
    );
    ////////////////////////////////////////////////////////////////////////////
    //testbench
    ////////////////////////////////////////////////////////////////////////////
    //----------------------------
    //test case
    initial begin
        $display(">> start sim");
        PCLK_i = 1'b0;
        PRESET_i = 1'b1;
        PADDR_i = {{(ADDR_WIDTH-1){1'b0}}, 1'b0};
        PMODE_i = 2'b00;
        PREADY_i = 1'b0;
        PSEL_i = {(PSEL_WIDTH){1'b1}};
        PWDATA_i = {(DATA_WIDTH){1'b0}};
        PRDATA_i = {(DATA_WIDTH){1'b0}};
        #(5.5 * CLK_PERIOD)  PMODE_i = 2'b10; PRDATA_i = 'h28; PADDR_i = 'h15; PREADY_i = 1'b1;
        #(2 * CLK_PERIOD) PRDATA_i = 'h72; PADDR_i = 'h1;
        #(2 * CLK_PERIOD) PRDATA_i = 'h66; PADDR_i = 'h2;
        #(2 * CLK_PERIOD) PRDATA_i = 'h9; PADDR_i = 'h3;
        #(2 * CLK_PERIOD) PRDATA_i = 'h87; PADDR_i = 'h4;
        #(2 * CLK_PERIOD) PRDATA_i = 'h44; PADDR_i = 'h5;
        #(2 * CLK_PERIOD) PRDATA_i = 'h54; PADDR_i = 'h6;
        #(2 * CLK_PERIOD) PRDATA_i = 'h00; PADDR_i = 'h0; PMODE_i = 2'b00;
        #(10 * CLK_PERIOD);
        $display(">> end sim.");
        $finish;
    end
    //----------------------------
    //clock gen
    always begin
        #(0.5 * CLK_PERIOD) PCLK_i <= ~PCLK_i;
    end
    ////////////////////////////////////////////////////////////////////////////
    //task
    ////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////
    //dump waveform
    ////////////////////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("wf_apb_protocol_read_without_wait_states.vcd");
        $dumpvars;
    end
endmodule
