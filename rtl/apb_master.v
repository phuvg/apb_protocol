////////////////////////////////////////////////////////////////////////////////
// Filename    : apb_master.v
// Description : 
//
// Author      : Phu Vuong
// History     : May, 21 2022 : Initial 	
//
////////////////////////////////////////////////////////////////////////////////
module apb_master (
    //-----------------------
    //clk and reset
    PCLK_i,
    PRESET_i,
    //-----------------------
    //mode (read/write)
    PMODE_i,
    PWRITE_o,
    //-----------------------
    //addr
    PADDR_i,
    PADDR_o,
    //-----------------------
    //select slave
    PSEL_i,
    //-----------------------
    //master control
    PENABLE_o,
    PSEL_o,
    PREADY_i,
    PREADY_o,
    //-----------------------
    //wrte/read data
    PWDATA_i,
    PWDATA_o,
    PRDATA_i,
    PRDATA_o,
    //-----------------------
    //error response
    PSLVERR_o
);
    ////////////////////////////////////////////////////////////////////////////
    //param declaration
    ////////////////////////////////////////////////////////////////////////////
    parameter                       ADDR_WIDTH = 8;
    parameter                       DATA_WIDTH = 8;
    parameter                       PSEL_WIDTH = 2;
    ////////////////////////////////////////////////////////////////////////////
    //port declaration
    ////////////////////////////////////////////////////////////////////////////
    //-----------------------
    //clk and reset
    input                           PCLK_i;
    input                           PRESET_i;
    //-----------------------
    //mode (read/write)
    input   [1:0]                   PMODE_i; //00:NOP  10:READ  11:WRITE
    output                          PWRITE_o;
    //-----------------------
    //addr
    input   [ADDR_WIDTH-1:0]        PADDR_i;
    output  [ADDR_WIDTH-1:0]        PADDR_o;
    //-----------------------
    //select slave
    input   [PSEL_WIDTH-1:0]        PSEL_i;
    //-----------------------
    //master control
    output                          PENABLE_o;
    output  [PSEL_WIDTH-1:0]        PSEL_o;
    input                           PREADY_i;
    output                          PREADY_o;
    //-----------------------
    //wrte/read data
    input   [DATA_WIDTH-1:0]        PWDATA_i;
    output  [DATA_WIDTH-1:0]        PWDATA_o;
    input   [DATA_WIDTH-1:0]        PRDATA_i;
    output  [DATA_WIDTH-1:0]        PRDATA_o;
    //-----------------------
    //error response
    output                          PSLVERR_o;
    ////////////////////////////////////////////////////////////////////////////
    //wire - reg name declaration
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    //ABP BUS description
    ////////////////////////////////////////////////////////////////////////////
    //-------------------------------
    //FSM - state declaration
    //-------------------------------
    parameter   IDLE    =   2'b00;
    parameter   SETUP   =   2'b01;
    parameter   ACCESS  =   2'b11;
    //-------------------------------
    //FSM - register state declaration
    //-------------------------------
    reg     [1:0]           current_state;
    reg     [1:0]           next_state;
    //-------------------------------
    //FSM - internal connection
    //-------------------------------
    //-------------------------------
    //FSM - combinational next state logic
    //-------------------------------
    always @(*) begin
        case(current_state)
            IDLE: begin
                next_state = (PMODE_i[1]) ? SETUP : IDLE;
            end
            SETUP: begin
                next_state = ACCESS;
            end
            ACCESS: begin
                next_state = (PREADY_i) ? (
                                (PMODE_i[1]) ? SETUP : IDLE
                            ) : ACCESS;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    //-------------------------------
    //FSM - state FF transition
    //-------------------------------
    always @(posedge PCLK_i or negedge PRESET_i) begin
        if(!PRESET_i) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    //-------------------------------
    //FSM - combinational output logic
    //-------------------------------
    assign PSEL_o = (current_state == SETUP || current_state == ACCESS) ? PSEL_i : {(PSEL_WIDTH){1'b0}};
    assign PENABLE_o = (current_state == ACCESS) ? 1 : 0;
    assign PWRITE_o = PMODE_i[0];
    assign PADDR_o = PADDR_i;
    assign PWDATA_o = PWDATA_i;
    assign PRDATA_o = (current_state == ACCESS) ? PRDATA_i : {(DATA_WIDTH){1'b0}};
    assign PREADY_o = (current_state == ACCESS) ? 1'b1 : 1'b0;
    assign PSLVERR_o = 1'b0;
endmodule
