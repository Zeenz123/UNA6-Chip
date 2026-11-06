`default_nettype none

module tt_um_una6_chip (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // All bidirectional pins configured as outputs
    assign uio_oe = 8'hFF;
    
    // Internal active-high reset
    wire reset = ~rst_n;
    
    // Unused input path for uio
    wire _unused = &{ena, uio_in, 1'b0};

    // Instantiate UNA top-level core
    UNA una_core (
        .CLK           (clk),
        .RST           (reset),
        .INPUT         (ui_in[7:0]),
        .DATAOUT       (uo_out[7:0]),
        .OUTSIDECONTROL(uio_out[5:0]),
        .X             (uio_out[6]),
        .Y             (uio_out[7])
    );

endmodule

// ============================================================================
// File: Adder.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Adder                                                        **
 **                                                                          **
 *****************************************************************************/

module Adder( carryIn,
              carryOut,
              dataA,
              dataB,
              result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter extendedBits = 1;
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input                carryIn;
   input [nrOfBits-1:0] dataA;
   input [nrOfBits-1:0] dataB;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output                carryOut;
   output [nrOfBits-1:0] result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [extendedBits-1:0] s_extendedDataA;
   wire [extendedBits-1:0] s_extendedDataB;
   wire [extendedBits-1:0] s_sumResult;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   assign   {carryOut, result} = dataA + dataB + carryIn;

endmodule


// ============================================================================
// File: Comparator.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Comparator                                                   **
 **                                                                          **
 *****************************************************************************/

module Comparator( aEqualsB,
                   aGreaterThanB,
                   aLessThanB,
                   dataA,
                   dataB );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter nrOfBits = 1;
   parameter twosComplement = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [nrOfBits-1:0] dataA;
   input [nrOfBits-1:0] dataB;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output aEqualsB;
   output aGreaterThanB;
   output aLessThanB;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_signedGreater;
   wire s_signedLess;
   wire s_unsignedGreater;
   wire s_unsignedLess;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   assign s_signedLess      = ($signed(dataA) < $signed(dataB));
   assign s_unsignedLess    = (dataA < dataB);
   assign s_signedGreater   = ($signed(dataA) > $signed(dataB));
   assign s_unsignedGreater = (dataA > dataB);

   assign aEqualsB      = (dataA == dataB);
   assign aGreaterThanB = (twosComplement==1) ? s_signedGreater : s_unsignedGreater;
   assign aLessThanB    = (twosComplement==1) ? s_signedLess : s_unsignedLess;

endmodule


// ============================================================================
// File: Shifter_11_bit.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Shifter_11_bit                                               **
 **                                                                          **
 *****************************************************************************/

module Shifter_11_bit( dataA,
                       result,
                       shiftAmount );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter shifterMode = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [10:0] dataA;
   input [3:0]  shiftAmount;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [10:0] result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [10:0] s_stage0Result;
   wire        s_stage0ShiftIn;
   wire [10:0] s_stage1Result;
   wire [1:0]  s_stage1ShiftIn;
   wire [10:0] s_stage2Result;
   wire [3:0]  s_stage2ShiftIn;
   wire [10:0] s_stage3Result;
   wire [7:0]  s_stage3ShiftIn;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   /*******************************************************************************
   ** ShifterMode represents when:                                               **
   ** 0 : Logical Shift Left                                                     **
   ** 1 : Rotate Left                                                            **
   ** 2 :                                                                        **
   ** Logical Shift Right                                                        **
   ** 3 : Arithmetic Shift Right                                                 **
   ** 4 : Rotate Right                                                           **
   *******************************************************************************/

   /*******************************************************************************
   ** Stage 0 of the binary shift tree is defined here                           **
   *******************************************************************************/
   assign s_stage0ShiftIn = ((shifterMode == 1) || (shifterMode == 3))
        ? dataA[shifterMode] : (10 == 4) ? dataA[0] : 0;

   assign s_stage0Result  = (shiftAmount == 0)
        ? dataA
        : ((shifterMode == 0) || (shifterMode == 1))
           ? {dataA[9:0],s_stage0ShiftIn}
           : {s_stage0ShiftIn,dataA[10:1]};

   /*******************************************************************************
   ** Stage 1 of the binary shift tree is defined here                           **
   *******************************************************************************/
   assign s_stage1ShiftIn = (shifterMode == 1) ?
                              s_stage0Result[10:9] :
                              (shifterMode == 3) ?
                              { 2{s_stage0Result[10]} } :
                              (shifterMode == 4) ?
                              s_stage0Result[1:0] : 0;

   assign s_stage1Result  = (shiftAmount[1]==0) ?
                              s_stage0Result :
                              ((shifterMode == 0)||(shifterMode == 1)) ?
                              {s_stage0Result[8:0],s_stage1ShiftIn} :
                              {s_stage1ShiftIn,s_stage0Result[10:2]};

   /*******************************************************************************
   ** Stage 2 of the binary shift tree is defined here                           **
   *******************************************************************************/
   assign s_stage2ShiftIn = (shifterMode == 1) ?
                              s_stage1Result[10:7] :
                              (shifterMode == 3) ?
                              { 4{s_stage1Result[10]} } :
                              (shifterMode == 4) ?
                              s_stage1Result[3:0] : 0;

   assign s_stage2Result  = (shiftAmount[2]==0) ?
                              s_stage1Result :
                              ((shifterMode == 0)||(shifterMode == 1)) ?
                              {s_stage1Result[6:0],s_stage2ShiftIn} :
                              {s_stage2ShiftIn,s_stage1Result[10:4]};

   /*******************************************************************************
   ** Stage 3 of the binary shift tree is defined here                           **
   *******************************************************************************/
   assign s_stage3ShiftIn = (shifterMode == 1) ?
                              s_stage2Result[10:3] :
                              (shifterMode == 3) ?
                              { 8{s_stage2Result[10]} } :
                              (shifterMode == 4) ?
                              s_stage2Result[7:0] : 0;

   assign s_stage3Result  = (shiftAmount[3]==0) ?
                              s_stage2Result :
                              ((shifterMode == 0)||(shifterMode == 1)) ?
                              {s_stage2Result[2:0],s_stage3ShiftIn} :
                              {s_stage3ShiftIn,s_stage2Result[10:8]};

   /*******************************************************************************
   ** The result is assigned here                                                **
   *******************************************************************************/
   assign result = s_stage3Result;

endmodule


// ============================================================================
// File: Subtractor.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Subtractor                                                   **
 **                                                                          **
 *****************************************************************************/

module Subtractor( borrowIn,
                   borrowOut,
                   dataA,
                   dataB,
                   result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter extendedBits = 1;
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input                borrowIn;
   input [nrOfBits-1:0] dataA;
   input [nrOfBits-1:0] dataB;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output                borrowOut;
   output [nrOfBits-1:0] result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire                    n_bIn;
   wire                    s_carry;
   wire [extendedBits-1:0] s_extendeddataA;
   wire [extendedBits-1:0] s_extendeddataB;
   wire [extendedBits-1:0] s_sumresult;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   assign n_bIn = ~borrowIn;
   assign {s_carry,result} = dataA + ~(dataB) + n_bIn;
   assign borrowOut        = ~s_carry;

endmodule


// ============================================================================
// File: ABS16.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : ABS16                                                        **
 **                                                                          **
 *****************************************************************************/

module ABS16( Input_1,
              Input_bus_1,
              Output_1,
              Output_2,
              Output_bus_1 );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input        Input_1;
   input [15:0] Input_bus_1;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output        Output_1;
   output        Output_2;
   output [15:0] Output_bus_1;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [15:0] s_logisimBus67;
   wire [15:0] s_logisimBus68;
   wire        s_logisimNet0;
   wire        s_logisimNet1;
   wire        s_logisimNet10;
   wire        s_logisimNet11;
   wire        s_logisimNet12;
   wire        s_logisimNet13;
   wire        s_logisimNet14;
   wire        s_logisimNet15;
   wire        s_logisimNet16;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet19;
   wire        s_logisimNet2;
   wire        s_logisimNet20;
   wire        s_logisimNet21;
   wire        s_logisimNet22;
   wire        s_logisimNet23;
   wire        s_logisimNet24;
   wire        s_logisimNet25;
   wire        s_logisimNet26;
   wire        s_logisimNet27;
   wire        s_logisimNet28;
   wire        s_logisimNet29;
   wire        s_logisimNet3;
   wire        s_logisimNet30;
   wire        s_logisimNet31;
   wire        s_logisimNet32;
   wire        s_logisimNet33;
   wire        s_logisimNet34;
   wire        s_logisimNet35;
   wire        s_logisimNet36;
   wire        s_logisimNet37;
   wire        s_logisimNet38;
   wire        s_logisimNet39;
   wire        s_logisimNet4;
   wire        s_logisimNet40;
   wire        s_logisimNet41;
   wire        s_logisimNet42;
   wire        s_logisimNet43;
   wire        s_logisimNet44;
   wire        s_logisimNet45;
   wire        s_logisimNet46;
   wire        s_logisimNet47;
   wire        s_logisimNet48;
   wire        s_logisimNet49;
   wire        s_logisimNet5;
   wire        s_logisimNet50;
   wire        s_logisimNet51;
   wire        s_logisimNet52;
   wire        s_logisimNet53;
   wire        s_logisimNet54;
   wire        s_logisimNet55;
   wire        s_logisimNet56;
   wire        s_logisimNet57;
   wire        s_logisimNet58;
   wire        s_logisimNet59;
   wire        s_logisimNet6;
   wire        s_logisimNet60;
   wire        s_logisimNet61;
   wire        s_logisimNet62;
   wire        s_logisimNet63;
   wire        s_logisimNet64;
   wire        s_logisimNet65;
   wire        s_logisimNet66;
   wire        s_logisimNet7;
   wire        s_logisimNet8;
   wire        s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus67[15:0] = Input_bus_1;
   assign s_logisimNet39       = Input_1;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_1     = s_logisimNet56;
   assign Output_2     = s_logisimBus67[15];
   assign Output_bus_1 = s_logisimBus68[15:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // NOT Gate
   assign s_logisimNet56 = ~s_logisimNet59;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimBus67[15]),
               .input2(s_logisimNet39),
               .result(s_logisimNet17));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimBus67[0]),
               .input2(s_logisimNet17),
               .result(s_logisimNet7));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimBus67[1]),
               .input2(s_logisimNet17),
               .result(s_logisimNet44));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimBus67[2]),
               .input2(s_logisimNet17),
               .result(s_logisimNet14));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimBus67[3]),
               .input2(s_logisimNet17),
               .result(s_logisimNet51));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimBus67[4]),
               .input2(s_logisimNet17),
               .result(s_logisimNet46));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimBus67[5]),
               .input2(s_logisimNet17),
               .result(s_logisimNet58));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_8 (.input1(s_logisimBus67[6]),
               .input2(s_logisimNet17),
               .result(s_logisimNet47));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_9 (.input1(s_logisimBus67[7]),
               .input2(s_logisimNet17),
               .result(s_logisimNet13));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_10 (.input1(s_logisimBus67[8]),
                .input2(s_logisimNet17),
                .result(s_logisimNet19));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_11 (.input1(s_logisimBus67[9]),
                .input2(s_logisimNet17),
                .result(s_logisimNet2));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_12 (.input1(s_logisimBus67[10]),
                .input2(s_logisimNet17),
                .result(s_logisimNet12));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_13 (.input1(s_logisimBus67[11]),
                .input2(s_logisimNet17),
                .result(s_logisimNet11));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_14 (.input1(s_logisimBus67[12]),
                .input2(s_logisimNet17),
                .result(s_logisimNet30));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_15 (.input1(s_logisimBus67[13]),
                .input2(s_logisimNet17),
                .result(s_logisimNet52));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_16 (.input1(s_logisimBus67[14]),
                .input2(s_logisimNet17),
                .result(s_logisimNet10));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_17 (.input1(s_logisimBus67[15]),
                .input2(s_logisimNet17),
                .result(s_logisimNet45));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_18 (.input1(s_logisimNet55),
                .input2(s_logisimNet30),
                .result(s_logisimNet50));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_19 (.input1(s_logisimNet50),
                .input2(s_logisimNet52),
                .result(s_logisimNet20));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_20 (.input1(s_logisimNet20),
                .input2(s_logisimNet10),
                .result(s_logisimNet4));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_21 (.input1(s_logisimNet4),
                .input2(s_logisimNet45),
                .result(s_logisimNet59));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_22 (.input1(s_logisimNet7),
                .input2(s_logisimNet17),
                .result(s_logisimNet29));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_23 (.input1(s_logisimNet44),
                .input2(s_logisimNet29),
                .result(s_logisimNet8));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_24 (.input1(s_logisimNet14),
                .input2(s_logisimNet8),
                .result(s_logisimNet36));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_25 (.input1(s_logisimNet51),
                .input2(s_logisimNet36),
                .result(s_logisimNet48));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_26 (.input1(s_logisimNet46),
                .input2(s_logisimNet48),
                .result(s_logisimNet38));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_27 (.input1(s_logisimNet58),
                .input2(s_logisimNet38),
                .result(s_logisimNet21));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_28 (.input1(s_logisimNet21),
                .input2(s_logisimNet47),
                .result(s_logisimNet3));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_29 (.input1(s_logisimNet3),
                .input2(s_logisimNet13),
                .result(s_logisimNet5));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_30 (.input1(s_logisimNet5),
                .input2(s_logisimNet19),
                .result(s_logisimNet42));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_31 (.input1(s_logisimNet42),
                .input2(s_logisimNet2),
                .result(s_logisimNet9));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_32 (.input1(s_logisimNet12),
                .input2(s_logisimNet9),
                .result(s_logisimNet37));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_33 (.input1(s_logisimNet11),
                .input2(s_logisimNet37),
                .result(s_logisimNet55));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_34 (.input1(s_logisimNet30),
                .input2(s_logisimNet55),
                .result(s_logisimBus68[12]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_35 (.input1(s_logisimNet50),
                .input2(s_logisimNet52),
                .result(s_logisimBus68[13]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_36 (.input1(s_logisimNet20),
                .input2(s_logisimNet10),
                .result(s_logisimBus68[14]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_37 (.input1(s_logisimNet4),
                .input2(s_logisimNet45),
                .result(s_logisimBus68[15]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_38 (.input1(s_logisimNet7),
                .input2(s_logisimNet17),
                .result(s_logisimBus68[0]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_39 (.input1(s_logisimNet44),
                .input2(s_logisimNet29),
                .result(s_logisimBus68[1]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_40 (.input1(s_logisimNet14),
                .input2(s_logisimNet8),
                .result(s_logisimBus68[2]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_41 (.input1(s_logisimNet51),
                .input2(s_logisimNet36),
                .result(s_logisimBus68[3]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_42 (.input1(s_logisimNet46),
                .input2(s_logisimNet48),
                .result(s_logisimBus68[4]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_43 (.input1(s_logisimNet58),
                .input2(s_logisimNet38),
                .result(s_logisimBus68[5]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_44 (.input1(s_logisimNet47),
                .input2(s_logisimNet21),
                .result(s_logisimBus68[6]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_45 (.input1(s_logisimNet3),
                .input2(s_logisimNet13),
                .result(s_logisimBus68[7]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_46 (.input1(s_logisimNet5),
                .input2(s_logisimNet19),
                .result(s_logisimBus68[8]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_47 (.input1(s_logisimNet42),
                .input2(s_logisimNet2),
                .result(s_logisimBus68[9]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_48 (.input1(s_logisimNet12),
                .input2(s_logisimNet9),
                .result(s_logisimBus68[10]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_49 (.input1(s_logisimNet11),
                .input2(s_logisimNet37),
                .result(s_logisimBus68[11]));


endmodule


// ============================================================================
// File: ABS8B.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : ABS8B                                                        **
 **                                                                          **
 *****************************************************************************/

module ABS8B( Input_bus_1,
              Output_1,
              Output_bus_1 );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [7:0] Input_bus_1;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       Output_1;
   output [6:0] Output_bus_1;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [6:0] s_logisimBus28;
   wire [7:0] s_logisimBus8;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet14;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet17;
   wire       s_logisimNet18;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet20;
   wire       s_logisimNet21;
   wire       s_logisimNet22;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet27;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet4;
   wire       s_logisimNet5;
   wire       s_logisimNet6;
   wire       s_logisimNet7;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus8[7:0] = Input_bus_1;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_1     = s_logisimBus8[7];
   assign Output_bus_1 = s_logisimBus28[6:0];

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimBus8[0]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet18));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimBus8[1]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet7));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimBus8[2]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet6));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimBus8[3]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet17));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimBus8[4]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet12));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimBus8[5]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet13));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimBus8[6]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet23));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_8 (.input1(s_logisimNet18),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet2));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_9 (.input1(s_logisimNet7),
               .input2(s_logisimNet2),
               .result(s_logisimNet3));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_10 (.input1(s_logisimNet6),
                .input2(s_logisimNet3),
                .result(s_logisimNet0));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_11 (.input1(s_logisimNet17),
                .input2(s_logisimNet0),
                .result(s_logisimNet15));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_12 (.input1(s_logisimNet12),
                .input2(s_logisimNet15),
                .result(s_logisimNet4));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_13 (.input1(s_logisimNet13),
                .input2(s_logisimNet4),
                .result(s_logisimNet5));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_14 (.input1(s_logisimNet18),
                .input2(s_logisimBus8[7]),
                .result(s_logisimBus28[0]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_15 (.input1(s_logisimNet7),
                .input2(s_logisimNet2),
                .result(s_logisimBus28[1]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_16 (.input1(s_logisimNet6),
                .input2(s_logisimNet3),
                .result(s_logisimBus28[2]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_17 (.input1(s_logisimNet17),
                .input2(s_logisimNet0),
                .result(s_logisimBus28[3]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_18 (.input1(s_logisimNet12),
                .input2(s_logisimNet15),
                .result(s_logisimBus28[4]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_19 (.input1(s_logisimNet13),
                .input2(s_logisimNet4),
                .result(s_logisimBus28[5]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_20 (.input1(s_logisimNet23),
                .input2(s_logisimNet5),
                .result(s_logisimBus28[6]));


endmodule


// ============================================================================
// File: ABSOLUTE.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : ABSOLUTE                                                     **
 **                                                                          **
 *****************************************************************************/

module ABSOLUTE( Input_1,
                 Input_bus_1,
                 Output_1,
                 Output_bus_1 );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       Input_1;
   input [9:0] Input_bus_1;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       Output_1;
   output [9:0] Output_bus_1;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [9:0] s_logisimBus14;
   wire [9:0] s_logisimBus43;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet17;
   wire       s_logisimNet18;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet20;
   wire       s_logisimNet21;
   wire       s_logisimNet22;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet27;
   wire       s_logisimNet28;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet30;
   wire       s_logisimNet31;
   wire       s_logisimNet32;
   wire       s_logisimNet33;
   wire       s_logisimNet34;
   wire       s_logisimNet35;
   wire       s_logisimNet36;
   wire       s_logisimNet37;
   wire       s_logisimNet38;
   wire       s_logisimNet39;
   wire       s_logisimNet4;
   wire       s_logisimNet40;
   wire       s_logisimNet41;
   wire       s_logisimNet42;
   wire       s_logisimNet44;
   wire       s_logisimNet5;
   wire       s_logisimNet6;
   wire       s_logisimNet7;
   wire       s_logisimNet8;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus43[9:0] = Input_bus_1;
   assign s_logisimNet37      = Input_1;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_1     = s_logisimNet44;
   assign Output_bus_1 = s_logisimBus14[9:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // NOT Gate
   assign s_logisimNet44 = ~s_logisimNet41;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet21),
               .input2(s_logisimNet3),
               .result(s_logisimNet41));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet29),
               .input2(s_logisimNet7),
               .result(s_logisimNet36));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet13),
               .input2(s_logisimNet36),
               .result(s_logisimNet30));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet10),
               .input2(s_logisimNet30),
               .result(s_logisimNet22));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet0),
               .input2(s_logisimNet22),
               .result(s_logisimNet1));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimNet6),
               .input2(s_logisimNet1),
               .result(s_logisimNet4));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimNet38),
               .input2(s_logisimNet4),
               .result(s_logisimNet35));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_8 (.input1(s_logisimNet35),
               .input2(s_logisimNet2),
               .result(s_logisimNet24));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_9 (.input1(s_logisimNet24),
               .input2(s_logisimNet31),
               .result(s_logisimNet27));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_10 (.input1(s_logisimNet27),
                .input2(s_logisimNet32),
                .result(s_logisimNet21));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_11 (.input1(s_logisimNet29),
                .input2(s_logisimNet7),
                .result(s_logisimBus14[0]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_12 (.input1(s_logisimNet13),
                .input2(s_logisimNet36),
                .result(s_logisimBus14[1]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_13 (.input1(s_logisimNet10),
                .input2(s_logisimNet30),
                .result(s_logisimBus14[2]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_14 (.input1(s_logisimNet0),
                .input2(s_logisimNet22),
                .result(s_logisimBus14[3]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_15 (.input1(s_logisimNet6),
                .input2(s_logisimNet1),
                .result(s_logisimBus14[4]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_16 (.input1(s_logisimNet38),
                .input2(s_logisimNet4),
                .result(s_logisimBus14[5]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_17 (.input1(s_logisimNet2),
                .input2(s_logisimNet35),
                .result(s_logisimBus14[6]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_18 (.input1(s_logisimNet24),
                .input2(s_logisimNet31),
                .result(s_logisimBus14[7]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_19 (.input1(s_logisimNet27),
                .input2(s_logisimNet32),
                .result(s_logisimBus14[8]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_20 (.input1(s_logisimNet21),
                .input2(s_logisimNet3),
                .result(s_logisimBus14[9]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_21 (.input1(s_logisimBus43[9]),
                .input2(s_logisimNet37),
                .result(s_logisimNet7));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_22 (.input1(s_logisimBus43[0]),
                .input2(s_logisimNet7),
                .result(s_logisimNet29));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_23 (.input1(s_logisimBus43[1]),
                .input2(s_logisimNet7),
                .result(s_logisimNet13));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_24 (.input1(s_logisimBus43[2]),
                .input2(s_logisimNet7),
                .result(s_logisimNet10));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_25 (.input1(s_logisimBus43[3]),
                .input2(s_logisimNet7),
                .result(s_logisimNet0));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_26 (.input1(s_logisimBus43[4]),
                .input2(s_logisimNet7),
                .result(s_logisimNet6));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_27 (.input1(s_logisimBus43[5]),
                .input2(s_logisimNet7),
                .result(s_logisimNet38));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_28 (.input1(s_logisimBus43[6]),
                .input2(s_logisimNet7),
                .result(s_logisimNet2));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_29 (.input1(s_logisimBus43[7]),
                .input2(s_logisimNet7),
                .result(s_logisimNet31));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_30 (.input1(s_logisimBus43[8]),
                .input2(s_logisimNet7),
                .result(s_logisimNet32));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_31 (.input1(s_logisimBus43[9]),
                .input2(s_logisimNet7),
                .result(s_logisimNet3));


endmodule


// ============================================================================
// File: ADDSUB.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : ADDSUB                                                       **
 **                                                                          **
 *****************************************************************************/

module ADDSUB( A,
               B,
               CIN,
               COUT,
               INVERTB,
               SUM );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [7:0] A;
   input [7:0] B;
   input       CIN;
   input       INVERTB;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       COUT;
   output [7:0] SUM;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus40;
   wire [7:0] s_logisimBus44;
   wire [7:0] s_logisimBus8;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet14;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet17;
   wire       s_logisimNet18;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet20;
   wire       s_logisimNet21;
   wire       s_logisimNet22;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet27;
   wire       s_logisimNet28;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet30;
   wire       s_logisimNet31;
   wire       s_logisimNet32;
   wire       s_logisimNet33;
   wire       s_logisimNet34;
   wire       s_logisimNet35;
   wire       s_logisimNet36;
   wire       s_logisimNet37;
   wire       s_logisimNet38;
   wire       s_logisimNet39;
   wire       s_logisimNet4;
   wire       s_logisimNet41;
   wire       s_logisimNet42;
   wire       s_logisimNet43;
   wire       s_logisimNet5;
   wire       s_logisimNet6;
   wire       s_logisimNet7;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus40[7:0] = A;
   assign s_logisimBus44[7:0] = B;
   assign s_logisimNet14      = INVERTB;
   assign s_logisimNet29      = CIN;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign COUT = s_logisimNet43;
   assign SUM  = s_logisimBus8[7:0];

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimBus44[0]),
               .input2(s_logisimNet14),
               .result(s_logisimNet36));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimBus44[1]),
               .input2(s_logisimNet14),
               .result(s_logisimNet20));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimBus44[2]),
               .input2(s_logisimNet14),
               .result(s_logisimNet37));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimBus44[3]),
               .input2(s_logisimNet14),
               .result(s_logisimNet23));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimBus44[4]),
               .input2(s_logisimNet14),
               .result(s_logisimNet7));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimBus44[5]),
               .input2(s_logisimNet14),
               .result(s_logisimNet27));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimBus44[6]),
               .input2(s_logisimNet14),
               .result(s_logisimNet38));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_8 (.input1(s_logisimBus44[7]),
               .input2(s_logisimNet14),
               .result(s_logisimNet31));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   FA   FA_1 (.A(s_logisimBus40[0]),
              .B(s_logisimNet36),
              .C(s_logisimNet29),
              .COUT(s_logisimNet0),
              .SUM(s_logisimBus8[0]));

   FA   FA_2 (.A(s_logisimBus40[1]),
              .B(s_logisimNet20),
              .C(s_logisimNet0),
              .COUT(s_logisimNet1),
              .SUM(s_logisimBus8[1]));

   FA   FA_3 (.A(s_logisimBus40[2]),
              .B(s_logisimNet37),
              .C(s_logisimNet1),
              .COUT(s_logisimNet2),
              .SUM(s_logisimBus8[2]));

   FA   FA_4 (.A(s_logisimBus40[3]),
              .B(s_logisimNet23),
              .C(s_logisimNet2),
              .COUT(s_logisimNet3),
              .SUM(s_logisimBus8[3]));

   FA   FA_5 (.A(s_logisimBus40[4]),
              .B(s_logisimNet7),
              .C(s_logisimNet3),
              .COUT(s_logisimNet4),
              .SUM(s_logisimBus8[4]));

   FA   FA_6 (.A(s_logisimBus40[5]),
              .B(s_logisimNet27),
              .C(s_logisimNet4),
              .COUT(s_logisimNet5),
              .SUM(s_logisimBus8[5]));

   FA   FA_7 (.A(s_logisimBus40[6]),
              .B(s_logisimNet38),
              .C(s_logisimNet5),
              .COUT(s_logisimNet6),
              .SUM(s_logisimBus8[6]));

   FA   FA_8 (.A(s_logisimBus40[7]),
              .B(s_logisimNet31),
              .C(s_logisimNet6),
              .COUT(s_logisimNet43),
              .SUM(s_logisimBus8[7]));

endmodule


// ============================================================================
// File: Bresenham.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Bresenham                                                    **
 **                                                                          **
 *****************************************************************************/

module Bresenham( CLKIN,
                  EQUAL,
                  INC,
                  RST,
                  X,
                  X1,
                  X2,
                  Y,
                  Y1,
                  Y2,
                  YCHANGE,
                  YEQUAL );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLKIN;
   input       INC;
   input       RST;
   input [7:0] X1;
   input [7:0] X2;
   input [7:0] Y1;
   input [7:0] Y2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       EQUAL;
   output [7:0] X;
   output [7:0] Y;
   output       YCHANGE;
   output       YEQUAL;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [9:0]  s_logisimBus15;
   wire [10:0] s_logisimBus19;
   wire [7:0]  s_logisimBus21;
   wire [9:0]  s_logisimBus23;
   wire [7:0]  s_logisimBus25;
   wire [7:0]  s_logisimBus26;
   wire [7:0]  s_logisimBus27;
   wire [9:0]  s_logisimBus29;
   wire [9:0]  s_logisimBus31;
   wire [2:0]  s_logisimBus33;
   wire [9:0]  s_logisimBus34;
   wire [10:0] s_logisimBus35;
   wire [9:0]  s_logisimBus39;
   wire [9:0]  s_logisimBus4;
   wire [7:0]  s_logisimBus40;
   wire [9:0]  s_logisimBus43;
   wire [7:0]  s_logisimBus44;
   wire [10:0] s_logisimBus45;
   wire [9:0]  s_logisimBus49;
   wire [9:0]  s_logisimBus5;
   wire [3:0]  s_logisimBus56;
   wire [10:0] s_logisimBus59;
   wire [9:0]  s_logisimBus60;
   wire [2:0]  s_logisimBus9;
   wire        s_logisimNet0;
   wire        s_logisimNet1;
   wire        s_logisimNet10;
   wire        s_logisimNet11;
   wire        s_logisimNet12;
   wire        s_logisimNet13;
   wire        s_logisimNet14;
   wire        s_logisimNet16;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet20;
   wire        s_logisimNet22;
   wire        s_logisimNet28;
   wire        s_logisimNet3;
   wire        s_logisimNet30;
   wire        s_logisimNet32;
   wire        s_logisimNet36;
   wire        s_logisimNet37;
   wire        s_logisimNet38;
   wire        s_logisimNet41;
   wire        s_logisimNet42;
   wire        s_logisimNet46;
   wire        s_logisimNet47;
   wire        s_logisimNet48;
   wire        s_logisimNet50;
   wire        s_logisimNet52;
   wire        s_logisimNet53;
   wire        s_logisimNet54;
   wire        s_logisimNet55;
   wire        s_logisimNet57;
   wire        s_logisimNet58;
   wire        s_logisimNet6;
   wire        s_logisimNet61;
   wire        s_logisimNet63;
   wire        s_logisimNet7;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all wiring is defined                                                 **
   *******************************************************************************/
   assign s_logisimBus23[0] = s_logisimNet13;
   assign s_logisimBus23[1] = s_logisimNet13;
   assign s_logisimBus23[2] = s_logisimNet13;
   assign s_logisimBus23[3] = s_logisimNet13;
   assign s_logisimBus23[4] = s_logisimNet13;
   assign s_logisimBus23[5] = s_logisimNet13;
   assign s_logisimBus23[6] = s_logisimNet13;
   assign s_logisimBus23[7] = s_logisimNet13;
   assign s_logisimBus23[8] = s_logisimNet13;
   assign s_logisimBus23[9] = s_logisimNet13;
   assign s_logisimBus31[0] = s_logisimNet12;
   assign s_logisimBus31[1] = s_logisimNet12;
   assign s_logisimBus31[2] = s_logisimNet12;
   assign s_logisimBus31[3] = s_logisimNet12;
   assign s_logisimBus31[4] = s_logisimNet12;
   assign s_logisimBus31[5] = s_logisimNet12;
   assign s_logisimBus31[6] = s_logisimNet12;
   assign s_logisimBus31[7] = s_logisimNet12;
   assign s_logisimBus31[8] = s_logisimNet12;
   assign s_logisimBus31[9] = s_logisimNet12;
   assign s_logisimBus34[8] = s_logisimNet22;
   assign s_logisimBus34[9] = s_logisimNet22;
   assign s_logisimBus39[8] = s_logisimNet36;
   assign s_logisimBus39[9] = s_logisimNet36;

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus21[7:0] = X1;
   assign s_logisimBus26[7:0] = Y2;
   assign s_logisimBus27[7:0] = Y1;
   assign s_logisimBus44[7:0] = X2;
   assign s_logisimNet0       = RST;
   assign s_logisimNet11      = INC;
   assign s_logisimNet6       = CLKIN;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign EQUAL   = s_logisimNet3;
   assign X       = s_logisimBus25[7:0];
   assign Y       = s_logisimBus40[7:0];
   assign YCHANGE = s_logisimNet16;
   assign YEQUAL  = s_logisimNet32;

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Power
   assign  s_logisimNet41  =  1'b1;


   // Constant
   assign  s_logisimBus56[3:0]  =  4'h1;


   // Ground
   assign  s_logisimBus45[10]  =  1'b0;


   // Constant
   assign  s_logisimBus33[2:0]  =  3'b010;


   // Ground
   assign  s_logisimNet38  =  1'b0;


   // Ground
   assign  s_logisimNet54  =  1'b0;


   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   OR_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet30),
               .input2(s_logisimNet50),
               .result(s_logisimNet57));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(10))
      GATES_2 (.input1(s_logisimBus19[9:0]),
               .input2(s_logisimBus23[9:0]),
               .result(s_logisimBus15[9:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(10))
      GATES_3 (.input1(s_logisimBus45[9:0]),
               .input2(s_logisimBus31[9:0]),
               .result(s_logisimBus60[9:0]));

   OR_GATE_BUS #(.BubblesMask(2'b00),
                 .NrOfBits(10))
      GATES_4 (.input1(s_logisimBus15[9:0]),
               .input2(s_logisimBus60[9:0]),
               .result(s_logisimBus43[9:0]));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet53),
               .input2(s_logisimNet10),
               .result(s_logisimNet13));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimNet28),
               .input2(s_logisimNet47),
               .result(s_logisimNet12));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimNet13),
               .input2(s_logisimNet12),
               .result(s_logisimNet50));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_8 (.input1(s_logisimNet0),
               .input2(s_logisimNet14),
               .result(s_logisimNet1));

   AND_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_9 (.input1(s_logisimNet52),
               .input2(s_logisimNet18),
               .input3(s_logisimNet7),
               .result(s_logisimNet58));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_10 (.input1(s_logisimNet7),
                .input2(s_logisimNet13),
                .result(s_logisimNet55));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_11 (.input1(s_logisimNet55),
                .input2(s_logisimNet10),
                .result(s_logisimNet32));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_12 (.input1(s_logisimNet3),
                .input2(s_logisimNet17),
                .result(s_logisimNet16));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_13 (.input1(s_logisimNet30),
                .input2(s_logisimNet12),
                .result(s_logisimNet42));

   Multiplexer_bus_2 #(.nrOfBits(10))
      PLEXERS_14 (.enable(1'b1),
                  .muxIn_0(s_logisimBus4[9:0]),
                  .muxIn_1(s_logisimBus49[9:0]),
                  .muxOut(s_logisimBus29[9:0]),
                  .sel(s_logisimNet30));

   Decoder_8   PLEXERS_15 (.decoderOut_0(s_logisimNet14),
                           .decoderOut_1(s_logisimNet30),
                           .decoderOut_2(s_logisimNet18),
                           .decoderOut_3(s_logisimNet10),
                           .decoderOut_4(s_logisimNet28),
                           .decoderOut_5(),
                           .decoderOut_6(),
                           .decoderOut_7(),
                           .enable(1'b1),
                           .sel(s_logisimBus9[2:0]));

   Shifter_11_bit #(.shifterMode(0))
      ARITH_16 (.dataA(s_logisimBus59[10:0]),
                .result(s_logisimBus35[10:0]),
                .shiftAmount(s_logisimBus56[3:0]));

   Comparator #(.nrOfBits(11),
                .twosComplement(1))
      ARITH_17 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet48),
                .dataA(s_logisimBus19[10:0]),
                .dataB(s_logisimBus35[10:0]));

   Comparator #(.nrOfBits(11),
                .twosComplement(1))
      ARITH_18 (.aEqualsB(),
                .aGreaterThanB(s_logisimNet37),
                .aLessThanB(),
                .dataA(s_logisimBus45[10:0]),
                .dataB(s_logisimBus35[10:0]));

   Adder #(.extendedBits(11),
           .nrOfBits(10))
      ARITH_19 (.carryIn(1'b0),
                .carryOut(),
                .dataA(s_logisimBus59[9:0]),
                .dataB(s_logisimBus43[9:0]),
                .result(s_logisimBus4[9:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_20 (.aEqualsB(s_logisimNet52),
                .aGreaterThanB(),
                .aLessThanB(),
                .dataA(s_logisimBus25[7:0]),
                .dataB(s_logisimBus44[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_21 (.aEqualsB(s_logisimNet7),
                .aGreaterThanB(),
                .aLessThanB(),
                .dataA(s_logisimBus40[7:0]),
                .dataB(s_logisimBus26[7:0]));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_22 (.borrowIn(1'b0),
                .borrowOut(s_logisimNet36),
                .dataA(s_logisimBus21[7:0]),
                .dataB(s_logisimBus44[7:0]),
                .result(s_logisimBus39[7:0]));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_23 (.borrowIn(1'b0),
                .borrowOut(s_logisimNet22),
                .dataA(s_logisimBus27[7:0]),
                .dataB(s_logisimBus26[7:0]),
                .result(s_logisimBus34[7:0]));

   Subtractor #(.extendedBits(11),
                .nrOfBits(10))
      ARITH_24 (.borrowIn(1'b0),
                .borrowOut(s_logisimBus59[10]),
                .dataA(s_logisimBus45[9:0]),
                .dataB(s_logisimBus5[9:0]),
                .result(s_logisimBus49[9:0]));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(10))
      MEMORY_25 (.clock(s_logisimNet6),
                 .clockEnable(s_logisimNet57),
                 .d(s_logisimBus29[9:0]),
                 .q(s_logisimBus59[9:0]),
                 .reset(s_logisimNet0),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(1))
      MEMORY_26 (.clock(s_logisimNet6),
                 .clockEnable(s_logisimNet18),
                 .d(s_logisimNet48),
                 .q(s_logisimNet53),
                 .reset(s_logisimNet0),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(1))
      MEMORY_27 (.clock(s_logisimNet6),
                 .clockEnable(s_logisimNet18),
                 .d(s_logisimNet37),
                 .q(s_logisimNet47),
                 .reset(s_logisimNet0),
                 .tick(1'b1));

   LogisimCounter #(.invertClock(0),
                    .maxVal(8'hFF),
                    .mode(0),
                    .width(8))
      MEMORY_28 (.clear(1'b0),
                 .clock(s_logisimNet6),
                 .compareOut(),
                 .countValue(s_logisimBus25[7:0]),
                 .enable(s_logisimNet13),
                 .load(s_logisimNet14),
                 .loadData(s_logisimBus21[7:0]),
                 .tick(1'b1),
                 .upNotDown(s_logisimNet36));

   LogisimCounter #(.invertClock(0),
                    .maxVal(8'hFF),
                    .mode(0),
                    .width(8))
      MEMORY_29 (.clear(1'b0),
                 .clock(s_logisimNet6),
                 .compareOut(),
                 .countValue(s_logisimBus40[7:0]),
                 .enable(s_logisimNet12),
                 .load(s_logisimNet14),
                 .loadData(s_logisimBus27[7:0]),
                 .tick(1'b1),
                 .upNotDown(s_logisimNet22));

   S_R_FLIPFLOP #(.invertClockEnable(0))
      MEMORY_30 (.clock(s_logisimNet6),
                 .preset(1'b0),
                 .q(s_logisimNet3),
                 .qBar(),
                 .r(s_logisimNet1),
                 .reset(1'b0),
                 .s(s_logisimNet58),
                 .tick(1'b1));

   S_R_FLIPFLOP #(.invertClockEnable(0))
      MEMORY_31 (.clock(s_logisimNet6),
                 .preset(1'b0),
                 .q(s_logisimNet61),
                 .qBar(s_logisimNet17),
                 .r(s_logisimNet42),
                 .reset(1'b0),
                 .s(s_logisimNet11),
                 .tick(1'b1));

   LogisimCounter #(.invertClock(0),
                    .maxVal(3'b111),
                    .mode(0),
                    .width(3))
      MEMORY_32 (.clear(s_logisimNet0),
                 .clock(s_logisimNet6),
                 .compareOut(),
                 .countValue(s_logisimBus9[2:0]),
                 .enable(s_logisimNet61),
                 .load(s_logisimNet28),
                 .loadData(s_logisimBus33[2:0]),
                 .tick(1'b1),
                 .upNotDown(1'b0));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   ABSOLUTE   ABSOLUTE_2 (.Input_1(s_logisimNet41),
                          .Input_bus_1(s_logisimBus5[9:0]),
                          .Output_1(s_logisimBus19[10]),
                          .Output_bus_1(s_logisimBus19[9:0]));

   ABSOLUTE   ABSOLUTE_1 (.Input_1(s_logisimNet38),
                          .Input_bus_1(s_logisimBus39[9:0]),
                          .Output_1(),
                          .Output_bus_1(s_logisimBus45[9:0]));

   ABSOLUTE   ABSOLUTE_3 (.Input_1(s_logisimNet54),
                          .Input_bus_1(s_logisimBus34[9:0]),
                          .Output_1(),
                          .Output_bus_1(s_logisimBus5[9:0]));

endmodule


// ============================================================================
// File: BRESENY.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : BRESENY                                                      **
 **                                                                          **
 *****************************************************************************/

module BRESENY( CLKIN,
                INC,
                Output_1,
                RST,
                X,
                X1,
                X2,
                Y,
                Y1,
                Y2 );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLKIN;
   input       INC;
   input       RST;
   input [7:0] X1;
   input [7:0] X2;
   input [7:0] Y1;
   input [7:0] Y2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       Output_1;
   output [7:0] X;
   output [7:0] Y;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [2:0]  s_logisimBus11;
   wire [7:0]  s_logisimBus12;
   wire [9:0]  s_logisimBus16;
   wire [9:0]  s_logisimBus25;
   wire [7:0]  s_logisimBus27;
   wire [7:0]  s_logisimBus28;
   wire [3:0]  s_logisimBus29;
   wire [9:0]  s_logisimBus3;
   wire [10:0] s_logisimBus31;
   wire [9:0]  s_logisimBus35;
   wire [7:0]  s_logisimBus37;
   wire [9:0]  s_logisimBus38;
   wire [10:0] s_logisimBus39;
   wire [9:0]  s_logisimBus40;
   wire [7:0]  s_logisimBus41;
   wire [7:0]  s_logisimBus42;
   wire [2:0]  s_logisimBus43;
   wire [10:0] s_logisimBus47;
   wire [9:0]  s_logisimBus5;
   wire [10:0] s_logisimBus8;
   wire        s_logisimNet0;
   wire        s_logisimNet1;
   wire        s_logisimNet10;
   wire        s_logisimNet13;
   wire        s_logisimNet15;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet19;
   wire        s_logisimNet2;
   wire        s_logisimNet20;
   wire        s_logisimNet21;
   wire        s_logisimNet22;
   wire        s_logisimNet23;
   wire        s_logisimNet24;
   wire        s_logisimNet26;
   wire        s_logisimNet30;
   wire        s_logisimNet32;
   wire        s_logisimNet33;
   wire        s_logisimNet34;
   wire        s_logisimNet4;
   wire        s_logisimNet44;
   wire        s_logisimNet45;
   wire        s_logisimNet46;
   wire        s_logisimNet48;
   wire        s_logisimNet49;
   wire        s_logisimNet51;
   wire        s_logisimNet6;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all wiring is defined                                                 **
   *******************************************************************************/
   assign s_logisimBus25[8] = s_logisimNet0;
   assign s_logisimBus25[9] = s_logisimNet0;
   assign s_logisimBus35[8] = s_logisimNet26;
   assign s_logisimBus35[9] = s_logisimNet26;

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus12[7:0] = X2;
   assign s_logisimBus27[7:0] = Y1;
   assign s_logisimBus28[7:0] = X1;
   assign s_logisimBus42[7:0] = Y2;
   assign s_logisimNet13      = RST;
   assign s_logisimNet21      = CLKIN;
   assign s_logisimNet44      = INC;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_1 = s_logisimNet34;
   assign X        = s_logisimBus41[7:0];
   assign Y        = s_logisimBus37[7:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Constant
   assign  s_logisimBus43[2:0]  =  3'b010;


   // Ground
   assign  s_logisimNet45  =  1'b0;


   // Ground
   assign  s_logisimNet17  =  1'b0;


   // Power
   assign  s_logisimNet46  =  1'b1;


   // Constant
   assign  s_logisimBus29[3:0]  =  4'h1;


   // Ground
   assign  s_logisimBus47[10]  =  1'b0;


   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   OR_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet2),
               .input2(s_logisimNet22),
               .result(s_logisimNet30));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet15),
               .input2(s_logisimNet18),
               .result(s_logisimNet10));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet20),
               .input2(s_logisimNet49),
               .result(s_logisimNet1));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet10),
               .input2(s_logisimNet1),
               .result(s_logisimNet22));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet2),
               .input2(s_logisimNet1),
               .result(s_logisimNet23));

   Decoder_8   PLEXERS_6 (.decoderOut_0(s_logisimNet33),
                          .decoderOut_1(s_logisimNet2),
                          .decoderOut_2(s_logisimNet4),
                          .decoderOut_3(s_logisimNet18),
                          .decoderOut_4(s_logisimNet20),
                          .decoderOut_5(),
                          .decoderOut_6(),
                          .decoderOut_7(),
                          .enable(1'b1),
                          .sel(s_logisimBus11[2:0]));

   Multiplexer_bus_2 #(.nrOfBits(10))
      PLEXERS_7 (.enable(1'b1),
                 .muxIn_0(s_logisimBus16[9:0]),
                 .muxIn_1(s_logisimBus3[9:0]),
                 .muxOut(s_logisimBus40[9:0]),
                 .sel(s_logisimNet2));

   Multiplexer_bus_2 #(.nrOfBits(10))
      PLEXERS_8 (.enable(1'b1),
                 .muxIn_0(s_logisimBus47[9:0]),
                 .muxIn_1(s_logisimBus39[9:0]),
                 .muxOut(s_logisimBus38[9:0]),
                 .sel(s_logisimNet10));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_9 (.borrowIn(1'b0),
               .borrowOut(s_logisimNet26),
               .dataA(s_logisimBus28[7:0]),
               .dataB(s_logisimBus12[7:0]),
               .result(s_logisimBus35[7:0]));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_10 (.borrowIn(1'b0),
                .borrowOut(s_logisimNet0),
                .dataA(s_logisimBus27[7:0]),
                .dataB(s_logisimBus42[7:0]),
                .result(s_logisimBus25[7:0]));

   Subtractor #(.extendedBits(11),
                .nrOfBits(10))
      ARITH_11 (.borrowIn(1'b0),
                .borrowOut(s_logisimBus31[10]),
                .dataA(s_logisimBus47[9:0]),
                .dataB(s_logisimBus5[9:0]),
                .result(s_logisimBus3[9:0]));

   Shifter_11_bit #(.shifterMode(0))
      ARITH_12 (.dataA(s_logisimBus31[10:0]),
                .result(s_logisimBus8[10:0]),
                .shiftAmount(s_logisimBus29[3:0]));

   Adder #(.extendedBits(11),
           .nrOfBits(10))
      ARITH_13 (.carryIn(1'b0),
                .carryOut(),
                .dataA(s_logisimBus31[9:0]),
                .dataB(s_logisimBus38[9:0]),
                .result(s_logisimBus16[9:0]));

   Comparator #(.nrOfBits(11),
                .twosComplement(1))
      ARITH_14 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet24),
                .dataA(s_logisimBus39[10:0]),
                .dataB(s_logisimBus8[10:0]));

   Comparator #(.nrOfBits(11),
                .twosComplement(1))
      ARITH_15 (.aEqualsB(),
                .aGreaterThanB(s_logisimNet32),
                .aLessThanB(),
                .dataA(s_logisimBus47[10:0]),
                .dataB(s_logisimBus8[10:0]));

   LogisimCounter #(.invertClock(0),
                    .maxVal(3'b111),
                    .mode(0),
                    .width(3))
      MEMORY_16 (.clear(s_logisimNet13),
                 .clock(s_logisimNet21),
                 .compareOut(),
                 .countValue(s_logisimBus11[2:0]),
                 .enable(s_logisimNet48),
                 .load(s_logisimNet20),
                 .loadData(s_logisimBus43[2:0]),
                 .tick(1'b1),
                 .upNotDown(1'b0));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(10))
      MEMORY_17 (.clock(s_logisimNet21),
                 .clockEnable(s_logisimNet30),
                 .d(s_logisimBus40[9:0]),
                 .q(s_logisimBus31[9:0]),
                 .reset(s_logisimNet13),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(1))
      MEMORY_18 (.clock(s_logisimNet21),
                 .clockEnable(s_logisimNet4),
                 .d(s_logisimNet24),
                 .q(s_logisimNet15),
                 .reset(s_logisimNet13),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(1))
      MEMORY_19 (.clock(s_logisimNet21),
                 .clockEnable(s_logisimNet4),
                 .d(s_logisimNet32),
                 .q(s_logisimNet49),
                 .reset(s_logisimNet13),
                 .tick(1'b1));

   LogisimCounter #(.invertClock(0),
                    .maxVal(8'hFF),
                    .mode(0),
                    .width(8))
      MEMORY_20 (.clear(1'b0),
                 .clock(s_logisimNet21),
                 .compareOut(),
                 .countValue(s_logisimBus41[7:0]),
                 .enable(s_logisimNet10),
                 .load(s_logisimNet33),
                 .loadData(s_logisimBus28[7:0]),
                 .tick(1'b1),
                 .upNotDown(s_logisimNet26));

   LogisimCounter #(.invertClock(0),
                    .maxVal(8'hFF),
                    .mode(0),
                    .width(8))
      MEMORY_21 (.clear(1'b0),
                 .clock(s_logisimNet21),
                 .compareOut(),
                 .countValue(s_logisimBus37[7:0]),
                 .enable(s_logisimNet1),
                 .load(s_logisimNet33),
                 .loadData(s_logisimBus27[7:0]),
                 .tick(1'b1),
                 .upNotDown(s_logisimNet0));

   S_R_FLIPFLOP #(.invertClockEnable(0))
      MEMORY_22 (.clock(s_logisimNet21),
                 .preset(1'b0),
                 .q(s_logisimNet48),
                 .qBar(s_logisimNet34),
                 .r(s_logisimNet23),
                 .reset(1'b0),
                 .s(s_logisimNet44),
                 .tick(1'b1));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   ABSOLUTE   ABSOLUTE_1 (.Input_1(s_logisimNet45),
                          .Input_bus_1(s_logisimBus35[9:0]),
                          .Output_1(),
                          .Output_bus_1(s_logisimBus47[9:0]));

   ABSOLUTE   ABSOLUTE_3 (.Input_1(s_logisimNet17),
                          .Input_bus_1(s_logisimBus25[9:0]),
                          .Output_1(),
                          .Output_bus_1(s_logisimBus5[9:0]));

   ABSOLUTE   ABSOLUTE_2 (.Input_1(s_logisimNet46),
                          .Input_bus_1(s_logisimBus5[9:0]),
                          .Output_1(s_logisimBus39[10]),
                          .Output_bus_1(s_logisimBus39[9:0]));

endmodule


// ============================================================================
// File: CNTRL.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : CNTRL                                                        **
 **                                                                          **
 *****************************************************************************/

module CNTRL( CLK,
              CONTROL,
              DELAY,
              FLAGS,
              GPUDONE,
              Input_bus_1,
              LDX,
              LDY,
              MATH,
              MUX,
              OPERAND,
              OUTPUT,
              POP,
              PUSH,
              REGADD,
              RST,
              SAVEA,
              SAVEREG,
              STARTGPU,
              SVB );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLK;
   input [6:0] FLAGS;
   input       GPUDONE;
   input [7:0] Input_bus_1;
   input       RST;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [5:0] CONTROL;
   output       DELAY;
   output       LDX;
   output       LDY;
   output       MATH;
   output [1:0] MUX;
   output [7:0] OPERAND;
   output       OUTPUT;
   output       POP;
   output       PUSH;
   output [3:0] REGADD;
   output       SAVEA;
   output       SAVEREG;
   output       STARTGPU;
   output       SVB;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [6:0]  s_logisimBus0;
   wire [7:0]  s_logisimBus10;
   wire [7:0]  s_logisimBus19;
   wire [19:0] s_logisimBus20;
   wire [5:0]  s_logisimBus25;
   wire [5:0]  s_logisimBus33;
   wire [3:0]  s_logisimBus35;
   wire [7:0]  s_logisimBus38;
   wire [5:0]  s_logisimBus42;
   wire [8:0]  s_logisimBus45;
   wire [2:0]  s_logisimBus53;
   wire [7:0]  s_logisimBus7;
   wire [7:0]  s_logisimBus8;
   wire        s_logisimNet11;
   wire        s_logisimNet12;
   wire        s_logisimNet13;
   wire        s_logisimNet14;
   wire        s_logisimNet15;
   wire        s_logisimNet16;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet2;
   wire        s_logisimNet21;
   wire        s_logisimNet22;
   wire        s_logisimNet23;
   wire        s_logisimNet24;
   wire        s_logisimNet26;
   wire        s_logisimNet27;
   wire        s_logisimNet29;
   wire        s_logisimNet3;
   wire        s_logisimNet30;
   wire        s_logisimNet31;
   wire        s_logisimNet32;
   wire        s_logisimNet34;
   wire        s_logisimNet39;
   wire        s_logisimNet4;
   wire        s_logisimNet40;
   wire        s_logisimNet41;
   wire        s_logisimNet43;
   wire        s_logisimNet44;
   wire        s_logisimNet46;
   wire        s_logisimNet47;
   wire        s_logisimNet48;
   wire        s_logisimNet49;
   wire        s_logisimNet5;
   wire        s_logisimNet50;
   wire        s_logisimNet51;
   wire        s_logisimNet52;
   wire        s_logisimNet6;
   wire        s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all wiring is defined                                                 **
   *******************************************************************************/
   assign s_logisimBus35[0] = s_logisimBus10[4];
   assign s_logisimBus35[1] = s_logisimBus10[5];
   assign s_logisimBus35[2] = s_logisimBus10[6];
   assign s_logisimBus35[3] = s_logisimBus10[7];
   assign s_logisimBus45[0] = s_logisimBus35[0];
   assign s_logisimBus45[1] = s_logisimBus35[1];
   assign s_logisimBus45[2] = s_logisimBus35[2];
   assign s_logisimBus45[3] = s_logisimBus35[3];
   assign s_logisimBus45[8] = s_logisimNet4;
   assign s_logisimBus8[0]  = s_logisimNet46;
   assign s_logisimBus8[1]  = s_logisimNet47;
   assign s_logisimBus8[2]  = s_logisimNet48;
   assign s_logisimBus8[3]  = s_logisimNet49;
   assign s_logisimBus8[4]  = s_logisimNet50;
   assign s_logisimBus8[5]  = s_logisimNet51;
   assign s_logisimBus8[6]  = s_logisimNet52;
   assign s_logisimNet4     = s_logisimBus10[0];
   assign s_logisimNet46    = s_logisimBus0[0];
   assign s_logisimNet47    = s_logisimBus0[1];
   assign s_logisimNet48    = s_logisimBus0[2];
   assign s_logisimNet49    = s_logisimBus0[3];
   assign s_logisimNet50    = s_logisimBus0[4];
   assign s_logisimNet51    = s_logisimBus0[5];
   assign s_logisimNet52    = s_logisimBus0[6];

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus0[6:0]  = FLAGS;
   assign s_logisimBus19[7:0] = Input_bus_1;
   assign s_logisimBus8[7]    = GPUDONE;
   assign s_logisimNet18      = CLK;
   assign s_logisimNet6       = RST;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign CONTROL  = s_logisimBus42[5:0];
   assign DELAY    = s_logisimBus20[8];
   assign LDX      = s_logisimBus20[9];
   assign LDY      = s_logisimBus20[10];
   assign MATH     = s_logisimBus20[5];
   assign MUX      = s_logisimBus20[14:13];
   assign OPERAND  = s_logisimBus19[7:0];
   assign OUTPUT   = s_logisimBus20[12];
   assign POP      = s_logisimBus20[6];
   assign PUSH     = s_logisimBus20[7];
   assign REGADD   = s_logisimBus10[3:0];
   assign SAVEA    = s_logisimBus20[3];
   assign SAVEREG  = s_logisimBus20[2];
   assign STARTGPU = s_logisimBus20[11];
   assign SVB      = s_logisimBus20[4];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Bit Extender
   assign  s_logisimBus33[0]  =  s_logisimBus7[0];
   assign  s_logisimBus33[1]  =  s_logisimBus7[1];
   assign  s_logisimBus33[2]  =  s_logisimBus7[2];
   assign  s_logisimBus33[3]  =  s_logisimBus7[3];
   assign  s_logisimBus33[4]  =  s_logisimBus7[4];
   assign  s_logisimBus33[5]  =  s_logisimBus7[5];


   // Bit Extender
   assign  s_logisimBus25[0]  =  s_logisimBus20[15];
   assign  s_logisimBus25[1]  =  s_logisimBus20[16];
   assign  s_logisimBus25[2]  =  1'b0;
   assign  s_logisimBus25[3]  =  1'b0;
   assign  s_logisimBus25[4]  =  1'b0;
   assign  s_logisimBus25[5]  =  1'b0;


   // Ground
   assign  s_logisimBus53[2:0]  =  3'b000;


   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(8))
      GATES_1 (.input1(s_logisimBus7[7:0]),
               .input2(s_logisimBus8[7:0]),
               .result(s_logisimBus38[7:0]));

   OR_GATE_8_INPUTS #(.BubblesMask(8'h00))
      GATES_2 (.input1(s_logisimBus38[0]),
               .input2(s_logisimBus38[1]),
               .input3(s_logisimBus38[2]),
               .input4(s_logisimBus38[3]),
               .input5(s_logisimBus38[4]),
               .input6(s_logisimBus38[5]),
               .input7(s_logisimBus38[6]),
               .input8(s_logisimBus38[7]),
               .result(s_logisimBus45[4]));

   PLA_PLA_1   PLA_1 (.index(s_logisimBus45[8:0]),
                      .result(s_logisimBus20[19:0]));

   OR_GATE #(.BubblesMask(2'b01))
      GATES_4 (.input1(s_logisimBus20[18]),
               .input2(s_logisimBus8[7]),
               .result(s_logisimNet22));

   Multiplexer_bus_2 #(.nrOfBits(6))
      PLEXERS_5 (.enable(1'b1),
                 .muxIn_0(s_logisimBus25[5:0]),
                 .muxIn_1(s_logisimBus33[5:0]),
                 .muxOut(s_logisimBus42[5:0]),
                 .sel(s_logisimBus20[17]));

   LogisimCounter #(.invertClock(0),
                    .maxVal(3'b111),
                    .mode(0),
                    .width(3))
      MEMORY_6 (.clear(s_logisimNet6),
                .clock(s_logisimNet18),
                .compareOut(),
                .countValue(s_logisimBus45[7:5]),
                .enable(s_logisimNet22),
                .load(s_logisimBus20[1]),
                .loadData(s_logisimBus53[2:0]),
                .tick(1'b1),
                .upNotDown(1'b0));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(8))
      MEMORY_7 (.clock(s_logisimNet18),
                .clockEnable(s_logisimBus20[0]),
                .d(s_logisimBus19[7:0]),
                .q(s_logisimBus10[7:0]),
                .reset(s_logisimNet6),
                .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(8))
      MEMORY_8 (.clock(s_logisimNet18),
                .clockEnable(s_logisimBus20[19]),
                .d(s_logisimBus19[7:0]),
                .q(s_logisimBus7[7:0]),
                .reset(s_logisimNet6),
                .tick(1'b1));


endmodule


// ============================================================================
// File: DLY.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : DLY                                                          **
 **                                                                          **
 *****************************************************************************/

module DLY( ADDRESS,
            CLK,
            ENCLK,
            RST,
            SET );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [23:0] ADDRESS;
   input        CLK;
   input        RST;
   input        SET;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output ENCLK;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [23:0] s_logisimBus2;
   wire        s_logisimNet0;
   wire        s_logisimNet1;
   wire        s_logisimNet3;
   wire        s_logisimNet4;
   wire        s_logisimNet5;
   wire        s_logisimNet6;
   wire        s_logisimNet7;
   wire        s_logisimNet8;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus2[23:0] = ADDRESS;
   assign s_logisimNet0       = SET;
   assign s_logisimNet4       = CLK;
   assign s_logisimNet5       = RST;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign ENCLK = s_logisimNet1;

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Ground
   assign  s_logisimNet8  =  1'b0;


   // NOT Gate
   assign s_logisimNet7 = ~s_logisimNet4;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet3),
               .input2(s_logisimNet0),
               .result(s_logisimNet6));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet3),
               .input2(s_logisimNet4),
               .result(s_logisimNet1));

   LogisimCounter #(.invertClock(0),
                    .maxVal(24'hFFFFFF),
                    .mode(0),
                    .width(24))
      MEMORY_3 (.clear(s_logisimNet5),
                .clock(s_logisimNet7),
                .compareOut(s_logisimNet3),
                .countValue(),
                .enable(s_logisimNet0),
                .load(s_logisimNet6),
                .loadData(s_logisimBus2[23:0]),
                .tick(1'b1),
                .upNotDown(s_logisimNet8));


endmodule


// ============================================================================
// File: FA.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : FA                                                           **
 **                                                                          **
 *****************************************************************************/

module FA( A,
           B,
           C,
           COUT,
           SUM );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input A;
   input B;
   input C;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output COUT;
   output SUM;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_logisimNet0;
   wire s_logisimNet1;
   wire s_logisimNet2;
   wire s_logisimNet3;
   wire s_logisimNet4;
   wire s_logisimNet5;
   wire s_logisimNet6;
   wire s_logisimNet7;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimNet1 = B;
   assign s_logisimNet2 = C;
   assign s_logisimNet6 = A;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign COUT = s_logisimNet5;
   assign SUM  = s_logisimNet7;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet1),
               .input2(s_logisimNet6),
               .result(s_logisimNet4));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet6),
               .input2(s_logisimNet1),
               .result(s_logisimNet3));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet2),
               .input2(s_logisimNet3),
               .result(s_logisimNet0));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet2),
               .input2(s_logisimNet3),
               .result(s_logisimNet7));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet0),
               .input2(s_logisimNet4),
               .result(s_logisimNet5));


endmodule


// ============================================================================
// File: GRAPHICSCARD.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : GRAPHICSCARD                                                 **
 **                                                                          **
 *****************************************************************************/

module GRAPHICSCARD( CLK,
                     COORD,
                     DATA,
                     DONE,
                     LDX,
                     LDY,
                     RST,
                     START,
                     X,
                     Y );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLK;
   input [7:0] DATA;
   input       LDX;
   input       LDY;
   input       RST;
   input       START;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] COORD;
   output       DONE;
   output       X;
   output       Y;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus10;
   wire [7:0] s_logisimBus11;
   wire [7:0] s_logisimBus12;
   wire [7:0] s_logisimBus13;
   wire [7:0] s_logisimBus14;
   wire [7:0] s_logisimBus15;
   wire [7:0] s_logisimBus16;
   wire [7:0] s_logisimBus8;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet2;
   wire       s_logisimNet3;
   wire       s_logisimNet4;
   wire       s_logisimNet5;
   wire       s_logisimNet6;
   wire       s_logisimNet7;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus16[7:0] = DATA;
   assign s_logisimNet3       = CLK;
   assign s_logisimNet4       = LDX;
   assign s_logisimNet5       = LDY;
   assign s_logisimNet6       = START;
   assign s_logisimNet9       = RST;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign COORD = s_logisimBus8[7:0];
   assign DONE  = s_logisimNet7;
   assign X     = s_logisimNet1;
   assign Y     = s_logisimNet0;

   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   SORTSHIFT   SORTSHIFT_1 (.CLK(s_logisimNet3),
                            .COORDATA(s_logisimBus16[7:0]),
                            .LDX(s_logisimNet4),
                            .LDY(s_logisimNet5),
                            .RST(s_logisimNet9),
                            .SORT(s_logisimNet6),
                            .SORTED(s_logisimNet2),
                            .X1(s_logisimBus10[7:0]),
                            .X2(s_logisimBus14[7:0]),
                            .XMID(s_logisimBus12[7:0]),
                            .Y1(s_logisimBus11[7:0]),
                            .Y2(s_logisimBus15[7:0]),
                            .YMID(s_logisimBus13[7:0]));

   TRIANGLE   TRIANGLE_1 (.CLK(s_logisimNet3),
                          .COORD(s_logisimBus8[7:0]),
                          .DONE(s_logisimNet7),
                          .SET(s_logisimNet9),
                          .START(s_logisimNet2),
                          .X(s_logisimNet1),
                          .XLOW(s_logisimBus14[7:0]),
                          .XMID(s_logisimBus12[7:0]),
                          .XTOP(s_logisimBus10[7:0]),
                          .Y(s_logisimNet0),
                          .YLOW(s_logisimBus15[7:0]),
                          .YMID(s_logisimBus13[7:0]),
                          .YTOP(s_logisimBus11[7:0]));

endmodule


// ============================================================================
// File: HORIZONTAL.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : HORIZONTAL                                                   **
 **                                                                          **
 *****************************************************************************/

module HORIZONTAL( CLK,
                   EQUAL,
                   Input_bus_1,
                   Input_bus_2,
                   LINE,
                   RST,
                   X,
                   X1,
                   X2,
                   XWRITE,
                   Y,
                   YTHENX );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLK;
   input [7:0] Input_bus_1;
   input [7:0] Input_bus_2;
   input       LINE;
   input       RST;
   input [7:0] X1;
   input [7:0] X2;
   input       XWRITE;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       EQUAL;
   output       X;
   output       Y;
   output [7:0] YTHENX;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus14;
   wire [1:0] s_logisimBus16;
   wire [1:0] s_logisimBus17;
   wire [7:0] s_logisimBus22;
   wire [7:0] s_logisimBus3;
   wire [7:0] s_logisimBus5;
   wire [7:0] s_logisimBus8;
   wire [7:0] s_logisimBus9;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet15;
   wire       s_logisimNet18;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet20;
   wire       s_logisimNet21;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet4;
   wire       s_logisimNet6;
   wire       s_logisimNet7;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus3[7:0] = Input_bus_2;
   assign s_logisimBus5[7:0] = X2;
   assign s_logisimBus8[7:0] = Input_bus_1;
   assign s_logisimBus9[7:0] = X1;
   assign s_logisimNet0      = XWRITE;
   assign s_logisimNet19     = CLK;
   assign s_logisimNet6      = LINE;
   assign s_logisimNet7      = RST;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign EQUAL  = s_logisimNet18;
   assign X      = s_logisimNet1;
   assign Y      = s_logisimNet11;
   assign YTHENX = s_logisimBus22[7:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Constant
   assign  s_logisimBus17[1:0]  =  2'b10;


   // NOT Gate
   assign s_logisimNet24 = ~s_logisimNet6;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE #(.BubblesMask(2'b10))
      GATES_1 (.input1(s_logisimNet13),
               .input2(s_logisimNet20),
               .result(s_logisimNet21));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet13),
               .input2(s_logisimNet2),
               .result(s_logisimNet1));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet12),
               .input2(s_logisimNet1),
               .result(s_logisimNet20));

   AND_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_4 (.input1(s_logisimNet12),
               .input2(s_logisimNet15),
               .input3(s_logisimNet0),
               .result(s_logisimNet26));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet26),
               .input2(s_logisimNet4),
               .result(s_logisimNet18));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimNet24),
               .input2(s_logisimNet0),
               .result(s_logisimNet2));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimNet24),
               .input2(s_logisimNet7),
               .result(s_logisimNet25));

   Decoder_4   PLEXERS_8 (.decoderOut_0(s_logisimNet10),
                          .decoderOut_1(s_logisimNet11),
                          .decoderOut_2(s_logisimNet13),
                          .decoderOut_3(s_logisimNet4),
                          .enable(1'b1),
                          .sel(s_logisimBus16[1:0]));

   Multiplexer_bus_2 #(.nrOfBits(8))
      PLEXERS_9 (.enable(1'b1),
                 .muxIn_0(s_logisimBus14[7:0]),
                 .muxIn_1(s_logisimBus8[7:0]),
                 .muxOut(s_logisimBus22[7:0]),
                 .sel(s_logisimNet11));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_10 (.borrowIn(1'b0),
                .borrowOut(s_logisimNet23),
                .dataA(s_logisimBus5[7:0]),
                .dataB(s_logisimBus9[7:0]),
                .result());

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_11 (.aEqualsB(s_logisimNet12),
                .aGreaterThanB(),
                .aLessThanB(),
                .dataA(s_logisimBus14[7:0]),
                .dataB(s_logisimBus9[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_12 (.aEqualsB(s_logisimNet15),
                .aGreaterThanB(),
                .aLessThanB(),
                .dataA(s_logisimBus8[7:0]),
                .dataB(s_logisimBus3[7:0]));

   LogisimCounter #(.invertClock(0),
                    .maxVal(2'b11),
                    .mode(0),
                    .width(2))
      MEMORY_13 (.clear(s_logisimNet25),
                 .clock(s_logisimNet19),
                 .compareOut(),
                 .countValue(s_logisimBus16[1:0]),
                 .enable(s_logisimNet6),
                 .load(s_logisimNet21),
                 .loadData(s_logisimBus17[1:0]),
                 .tick(1'b1),
                 .upNotDown(1'b0));

   LogisimCounter #(.invertClock(0),
                    .maxVal(8'hFF),
                    .mode(0),
                    .width(8))
      MEMORY_14 (.clear(s_logisimNet7),
                 .clock(s_logisimNet19),
                 .compareOut(),
                 .countValue(s_logisimBus14[7:0]),
                 .enable(s_logisimNet1),
                 .load(s_logisimNet10),
                 .loadData(s_logisimBus5[7:0]),
                 .tick(1'b1),
                 .upNotDown(s_logisimNet23));


endmodule


// ============================================================================
// File: MATH.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : MATH                                                         **
 **                                                                          **
 *****************************************************************************/

module MATH( ALU,
             ALUOUT,
             CLK,
             CNTRL,
             DATAIN,
             FLAGS,
             RST,
             SVA,
             SVB );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       ALU;
   input       CLK;
   input [7:0] CNTRL;
   input [7:0] DATAIN;
   input       RST;
   input       SVA;
   input       SVB;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] ALUOUT;
   output [6:0] FLAGS;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0]  s_logisimBus0;
   wire [6:0]  s_logisimBus11;
   wire [7:0]  s_logisimBus19;
   wire [15:0] s_logisimBus21;
   wire [7:0]  s_logisimBus23;
   wire [7:0]  s_logisimBus25;
   wire [15:0] s_logisimBus28;
   wire [7:0]  s_logisimBus3;
   wire [7:0]  s_logisimBus33;
   wire [7:0]  s_logisimBus34;
   wire [6:0]  s_logisimBus36;
   wire [7:0]  s_logisimBus37;
   wire [7:0]  s_logisimBus4;
   wire [7:0]  s_logisimBus40;
   wire [3:0]  s_logisimBus46;
   wire [7:0]  s_logisimBus54;
   wire [15:0] s_logisimBus57;
   wire [7:0]  s_logisimBus58;
   wire [7:0]  s_logisimBus8;
   wire        s_logisimNet1;
   wire        s_logisimNet10;
   wire        s_logisimNet12;
   wire        s_logisimNet14;
   wire        s_logisimNet15;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet20;
   wire        s_logisimNet22;
   wire        s_logisimNet24;
   wire        s_logisimNet26;
   wire        s_logisimNet27;
   wire        s_logisimNet29;
   wire        s_logisimNet30;
   wire        s_logisimNet31;
   wire        s_logisimNet32;
   wire        s_logisimNet35;
   wire        s_logisimNet38;
   wire        s_logisimNet39;
   wire        s_logisimNet41;
   wire        s_logisimNet42;
   wire        s_logisimNet43;
   wire        s_logisimNet44;
   wire        s_logisimNet45;
   wire        s_logisimNet47;
   wire        s_logisimNet48;
   wire        s_logisimNet49;
   wire        s_logisimNet5;
   wire        s_logisimNet50;
   wire        s_logisimNet51;
   wire        s_logisimNet52;
   wire        s_logisimNet53;
   wire        s_logisimNet55;
   wire        s_logisimNet56;
   wire        s_logisimNet59;
   wire        s_logisimNet6;
   wire        s_logisimNet60;
   wire        s_logisimNet62;
   wire        s_logisimNet63;
   wire        s_logisimNet64;
   wire        s_logisimNet65;
   wire        s_logisimNet67;
   wire        s_logisimNet68;
   wire        s_logisimNet69;
   wire        s_logisimNet7;
   wire        s_logisimNet70;
   wire        s_logisimNet71;
   wire        s_logisimNet72;
   wire        s_logisimNet73;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all wiring is defined                                                 **
   *******************************************************************************/
   assign s_logisimBus23[0] = s_logisimNet30;
   assign s_logisimBus23[1] = s_logisimNet65;
   assign s_logisimBus23[2] = s_logisimNet50;
   assign s_logisimBus23[3] = s_logisimNet6;
   assign s_logisimBus23[4] = s_logisimNet62;
   assign s_logisimBus23[5] = s_logisimNet41;
   assign s_logisimBus23[6] = s_logisimNet67;
   assign s_logisimBus23[7] = s_logisimNet47;
   assign s_logisimBus36[1] = s_logisimNet12;
   assign s_logisimBus40[0] = s_logisimNet38;
   assign s_logisimBus40[1] = s_logisimNet49;
   assign s_logisimBus40[2] = s_logisimNet5;
   assign s_logisimBus40[3] = s_logisimNet63;
   assign s_logisimBus40[4] = s_logisimNet42;
   assign s_logisimBus40[5] = s_logisimNet68;
   assign s_logisimBus40[6] = s_logisimNet55;
   assign s_logisimBus40[7] = s_logisimNet29;
   assign s_logisimBus46[0] = s_logisimNet69;
   assign s_logisimBus46[1] = s_logisimNet70;
   assign s_logisimBus46[2] = s_logisimNet71;
   assign s_logisimBus46[3] = s_logisimNet72;
   assign s_logisimNet12    = s_logisimBus4[7];
   assign s_logisimNet29    = s_logisimBus21[14];
   assign s_logisimNet30    = s_logisimBus21[9];
   assign s_logisimNet38    = s_logisimBus21[15];
   assign s_logisimNet41    = s_logisimBus21[14];
   assign s_logisimNet42    = s_logisimBus21[11];
   assign s_logisimNet47    = s_logisimBus21[8];
   assign s_logisimNet49    = s_logisimBus21[8];
   assign s_logisimNet5     = s_logisimBus21[9];
   assign s_logisimNet50    = s_logisimBus21[11];
   assign s_logisimNet55    = s_logisimBus21[13];
   assign s_logisimNet6     = s_logisimBus21[12];
   assign s_logisimNet62    = s_logisimBus21[13];
   assign s_logisimNet63    = s_logisimBus21[10];
   assign s_logisimNet65    = s_logisimBus21[10];
   assign s_logisimNet67    = s_logisimBus21[15];
   assign s_logisimNet68    = s_logisimBus21[12];
   assign s_logisimNet69    = s_logisimBus33[4];
   assign s_logisimNet70    = s_logisimBus33[5];
   assign s_logisimNet71    = s_logisimBus33[6];
   assign s_logisimNet72    = s_logisimBus33[7];

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus33[7:0] = CNTRL;
   assign s_logisimBus37[7:0] = DATAIN;
   assign s_logisimNet1       = SVB;
   assign s_logisimNet14      = SVA;
   assign s_logisimNet22      = ALU;
   assign s_logisimNet31      = CLK;
   assign s_logisimNet7       = RST;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign ALUOUT = s_logisimBus4[7:0];
   assign FLAGS  = s_logisimBus11[6:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Ground
   assign  s_logisimBus19[7:0]  =  8'h00;


   // Ground
   assign  s_logisimNet73  =  1'b0;


   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(8))
      GATES_1 (.input1(s_logisimBus21[7:0]),
               .input2(s_logisimBus21[15:8]),
               .result(s_logisimBus25[7:0]));

   OR_GATE_BUS #(.BubblesMask(2'b00),
                 .NrOfBits(8))
      GATES_2 (.input1(s_logisimBus21[7:0]),
               .input2(s_logisimBus21[15:8]),
               .result(s_logisimBus3[7:0]));

   XOR_GATE_BUS_ONEHOT #(.BubblesMask(2'b00),
                         .NrOfBits(8))
      GATES_3 (.input1(s_logisimBus21[7:0]),
               .input2(s_logisimBus21[15:8]),
               .result(s_logisimBus34[7:0]));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet22),
               .input2(s_logisimBus33[3]),
               .result(s_logisimNet18));

   NOR_GATE_8_INPUTS #(.BubblesMask(8'h00))
      GATES_5 (.input1(s_logisimBus4[0]),
               .input2(s_logisimBus4[1]),
               .input3(s_logisimBus4[2]),
               .input4(s_logisimBus4[3]),
               .input5(s_logisimBus4[4]),
               .input6(s_logisimBus4[5]),
               .input7(s_logisimBus4[6]),
               .input8(s_logisimNet12),
               .result(s_logisimBus36[6]));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimBus11[0]),
               .input2(s_logisimBus33[0]),
               .result(s_logisimNet39));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimNet39),
               .input2(s_logisimBus33[1]),
               .result(s_logisimNet52));

   Multiplexer_bus_16 #(.nrOfBits(8))
      PLEXERS_8 (.enable(1'b1),
                 .muxIn_0(s_logisimBus54[7:0]),
                 .muxIn_1(s_logisimBus25[7:0]),
                 .muxIn_10(s_logisimBus40[7:0]),
                 .muxIn_11(s_logisimBus21[15:8]),
                 .muxIn_12(s_logisimBus0[7:0]),
                 .muxIn_13(s_logisimBus19[7:0]),
                 .muxIn_14(s_logisimBus19[7:0]),
                 .muxIn_15(s_logisimBus19[7:0]),
                 .muxIn_2(s_logisimBus3[7:0]),
                 .muxIn_3(s_logisimBus34[7:0]),
                 .muxIn_4(s_logisimBus28[7:0]),
                 .muxIn_5(s_logisimBus28[15:8]),
                 .muxIn_6(s_logisimBus57[7:0]),
                 .muxIn_7(s_logisimBus57[15:8]),
                 .muxIn_8(s_logisimBus8[7:0]),
                 .muxIn_9(s_logisimBus23[7:0]),
                 .muxOut(s_logisimBus4[7:0]),
                 .sel(s_logisimBus46[3:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(1))
      ARITH_9 (.aEqualsB(),
               .aGreaterThanB(s_logisimBus36[2]),
               .aLessThanB(s_logisimBus36[3]),
               .dataA(s_logisimBus21[15:8]),
               .dataB(s_logisimBus21[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_10 (.aEqualsB(),
                .aGreaterThanB(s_logisimBus36[4]),
                .aLessThanB(s_logisimBus36[5]),
                .dataA(s_logisimBus21[15:8]),
                .dataB(s_logisimBus21[7:0]));

   LogisimRNG #(.initialState0(64'hC81A0D35C50EB982),
                .initialState1(64'h506E90F594419A89),
                .initialState2(64'h734D0E03E6F349E9),
                .initialState3(64'h8A4763566F4D6D62),
                .nrOfBits(8))
      MEMORY_11 (.clear(s_logisimNet7),
                 .clock(s_logisimNet31),
                 .enable(s_logisimNet22),
                 .q(s_logisimBus0[7:0]),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(1))
      MEMORY_12 (.clock(s_logisimNet31),
                 .clockEnable(s_logisimNet22),
                 .d(s_logisimNet20),
                 .q(s_logisimBus36[0]),
                 .reset(s_logisimNet73),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(7))
      MEMORY_13 (.clock(s_logisimNet31),
                 .clockEnable(s_logisimNet18),
                 .d(s_logisimBus36[6:0]),
                 .q(s_logisimBus11[6:0]),
                 .reset(s_logisimNet7),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(8))
      MEMORY_14 (.clock(s_logisimNet31),
                 .clockEnable(s_logisimNet14),
                 .d(s_logisimBus37[7:0]),
                 .q(s_logisimBus21[15:8]),
                 .reset(s_logisimNet7),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(8))
      MEMORY_15 (.clock(s_logisimNet31),
                 .clockEnable(s_logisimNet1),
                 .d(s_logisimBus37[7:0]),
                 .q(s_logisimBus21[7:0]),
                 .reset(s_logisimNet7),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(8))
      MEMORY_16 (.clock(s_logisimNet31),
                 .clockEnable(s_logisimNet1),
                 .d(s_logisimBus21[7:0]),
                 .q(s_logisimBus58[7:0]),
                 .reset(s_logisimNet7),
                 .tick(1'b1));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   NEGMULTI   NEGMULTI_1 (.Input_bus_1(s_logisimBus21[7:0]),
                          .Input_bus_2(s_logisimBus21[15:8]),
                          .Output_bus_1(s_logisimBus28[15:0]));

   NEGDIVIDE   NEGDIVIDE_1 (.Input_bus_1(s_logisimBus21[15:0]),
                            .Input_bus_2(s_logisimBus58[7:0]),
                            .Output_bus_1(s_logisimBus57[15:0]),
                            .Output_bus_2(s_logisimBus8[7:0]));

   ADDSUB   ADDSUB_1 (.A(s_logisimBus21[15:8]),
                      .B(s_logisimBus21[7:0]),
                      .CIN(s_logisimNet52),
                      .COUT(s_logisimNet20),
                      .INVERTB(s_logisimBus33[2]),
                      .SUM(s_logisimBus54[7:0]));

endmodule


// ============================================================================
// File: NEGDIVIDE.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : NEGDIVIDE                                                    **
 **                                                                          **
 *****************************************************************************/

module NEGDIVIDE( Input_bus_1,
                  Input_bus_2,
                  Output_bus_1,
                  Output_bus_2 );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [15:0] Input_bus_1;
   input [7:0]  Input_bus_2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [15:0] Output_bus_1;
   output [7:0]  Output_bus_2;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0]  s_logisimBus0;
   wire [6:0]  s_logisimBus104;
   wire [7:0]  s_logisimBus11;
   wire [7:0]  s_logisimBus14;
   wire [7:0]  s_logisimBus15;
   wire [7:0]  s_logisimBus16;
   wire [7:0]  s_logisimBus2;
   wire [7:0]  s_logisimBus3;
   wire [7:0]  s_logisimBus39;
   wire [7:0]  s_logisimBus48;
   wire [7:0]  s_logisimBus49;
   wire [7:0]  s_logisimBus51;
   wire [7:0]  s_logisimBus52;
   wire [7:0]  s_logisimBus6;
   wire [15:0] s_logisimBus64;
   wire [13:0] s_logisimBus67;
   wire [7:0]  s_logisimBus69;
   wire [7:0]  s_logisimBus77;
   wire [15:0] s_logisimBus83;
   wire [13:0] s_logisimBus86;
   wire [7:0]  s_logisimBus88;
   wire [7:0]  s_logisimBus89;
   wire [15:0] s_logisimBus91;
   wire [15:0] s_logisimBus93;
   wire        s_logisimNet10;
   wire        s_logisimNet100;
   wire        s_logisimNet101;
   wire        s_logisimNet102;
   wire        s_logisimNet103;
   wire        s_logisimNet105;
   wire        s_logisimNet107;
   wire        s_logisimNet12;
   wire        s_logisimNet13;
   wire        s_logisimNet17;
   wire        s_logisimNet20;
   wire        s_logisimNet21;
   wire        s_logisimNet22;
   wire        s_logisimNet23;
   wire        s_logisimNet24;
   wire        s_logisimNet25;
   wire        s_logisimNet26;
   wire        s_logisimNet28;
   wire        s_logisimNet29;
   wire        s_logisimNet30;
   wire        s_logisimNet31;
   wire        s_logisimNet32;
   wire        s_logisimNet34;
   wire        s_logisimNet35;
   wire        s_logisimNet38;
   wire        s_logisimNet4;
   wire        s_logisimNet40;
   wire        s_logisimNet41;
   wire        s_logisimNet42;
   wire        s_logisimNet43;
   wire        s_logisimNet44;
   wire        s_logisimNet45;
   wire        s_logisimNet47;
   wire        s_logisimNet50;
   wire        s_logisimNet53;
   wire        s_logisimNet54;
   wire        s_logisimNet55;
   wire        s_logisimNet56;
   wire        s_logisimNet57;
   wire        s_logisimNet58;
   wire        s_logisimNet59;
   wire        s_logisimNet60;
   wire        s_logisimNet61;
   wire        s_logisimNet62;
   wire        s_logisimNet65;
   wire        s_logisimNet68;
   wire        s_logisimNet7;
   wire        s_logisimNet70;
   wire        s_logisimNet71;
   wire        s_logisimNet72;
   wire        s_logisimNet73;
   wire        s_logisimNet74;
   wire        s_logisimNet76;
   wire        s_logisimNet78;
   wire        s_logisimNet8;
   wire        s_logisimNet81;
   wire        s_logisimNet84;
   wire        s_logisimNet85;
   wire        s_logisimNet87;
   wire        s_logisimNet9;
   wire        s_logisimNet90;
   wire        s_logisimNet92;
   wire        s_logisimNet94;
   wire        s_logisimNet95;
   wire        s_logisimNet96;
   wire        s_logisimNet97;
   wire        s_logisimNet99;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all wiring is defined                                                 **
   *******************************************************************************/
   assign s_logisimBus0[0]  = s_logisimNet94;
   assign s_logisimBus0[1]  = s_logisimNet58;
   assign s_logisimBus0[2]  = s_logisimNet105;
   assign s_logisimBus0[3]  = s_logisimNet81;
   assign s_logisimBus0[4]  = s_logisimNet41;
   assign s_logisimBus0[5]  = s_logisimNet97;
   assign s_logisimBus0[6]  = s_logisimNet71;
   assign s_logisimBus11[0] = s_logisimNet96;
   assign s_logisimBus14[0] = s_logisimNet7;
   assign s_logisimBus15[0] = s_logisimNet40;
   assign s_logisimBus16[0] = s_logisimNet61;
   assign s_logisimBus2[0]  = s_logisimNet74;
   assign s_logisimBus39[0] = s_logisimNet43;
   assign s_logisimBus3[0]  = s_logisimNet62;
   assign s_logisimBus48[0] = s_logisimNet73;
   assign s_logisimBus49[0] = s_logisimNet10;
   assign s_logisimBus52[0] = s_logisimNet44;
   assign s_logisimBus6[0]  = s_logisimNet35;
   assign s_logisimBus77[0] = s_logisimNet42;
   assign s_logisimBus88[0] = s_logisimNet53;
   assign s_logisimBus89[0] = s_logisimNet87;
   assign s_logisimNet10    = s_logisimBus67[0];
   assign s_logisimNet105   = s_logisimBus104[2];
   assign s_logisimNet35    = s_logisimBus67[4];
   assign s_logisimNet40    = s_logisimBus67[11];
   assign s_logisimNet41    = s_logisimBus104[4];
   assign s_logisimNet42    = s_logisimBus67[7];
   assign s_logisimNet43    = s_logisimBus67[1];
   assign s_logisimNet44    = s_logisimBus67[6];
   assign s_logisimNet53    = s_logisimBus67[9];
   assign s_logisimNet58    = s_logisimBus104[1];
   assign s_logisimNet61    = s_logisimBus67[3];
   assign s_logisimNet62    = s_logisimBus67[5];
   assign s_logisimNet7     = s_logisimBus67[2];
   assign s_logisimNet71    = s_logisimBus104[6];
   assign s_logisimNet73    = s_logisimBus67[8];
   assign s_logisimNet74    = s_logisimBus67[13];
   assign s_logisimNet81    = s_logisimBus104[3];
   assign s_logisimNet87    = s_logisimBus67[12];
   assign s_logisimNet94    = s_logisimBus104[0];
   assign s_logisimNet96    = s_logisimBus67[10];
   assign s_logisimNet97    = s_logisimBus104[5];

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus51[7:0]  = Input_bus_2;
   assign s_logisimBus64[15:0] = Input_bus_1;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_bus_1 = s_logisimBus93[15:0];
   assign Output_bus_2 = s_logisimBus69[7:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Bit Extender
   assign  s_logisimBus67[0]  =  s_logisimBus83[0];
   assign  s_logisimBus67[1]  =  s_logisimBus83[1];
   assign  s_logisimBus67[2]  =  s_logisimBus83[2];
   assign  s_logisimBus67[3]  =  s_logisimBus83[3];
   assign  s_logisimBus67[4]  =  s_logisimBus83[4];
   assign  s_logisimBus67[5]  =  s_logisimBus83[5];
   assign  s_logisimBus67[6]  =  s_logisimBus83[6];
   assign  s_logisimBus67[7]  =  s_logisimBus83[7];
   assign  s_logisimBus67[8]  =  s_logisimBus83[8];
   assign  s_logisimBus67[9]  =  s_logisimBus83[9];
   assign  s_logisimBus67[10]  =  s_logisimBus83[10];
   assign  s_logisimBus67[11]  =  s_logisimBus83[11];
   assign  s_logisimBus67[12]  =  s_logisimBus83[12];
   assign  s_logisimBus67[13]  =  s_logisimBus83[13];


   // Ground
   assign  s_logisimBus0[7]  =  1'b0;


   // Ground
   assign  s_logisimBus2[7:1]  =  {3'b000, 4'h0};


   // Bit Extender
   assign  s_logisimBus91[0]  =  s_logisimBus86[0];
   assign  s_logisimBus91[1]  =  s_logisimBus86[1];
   assign  s_logisimBus91[2]  =  s_logisimBus86[2];
   assign  s_logisimBus91[3]  =  s_logisimBus86[3];
   assign  s_logisimBus91[4]  =  s_logisimBus86[4];
   assign  s_logisimBus91[5]  =  s_logisimBus86[5];
   assign  s_logisimBus91[6]  =  s_logisimBus86[6];
   assign  s_logisimBus91[7]  =  s_logisimBus86[7];
   assign  s_logisimBus91[8]  =  s_logisimBus86[8];
   assign  s_logisimBus91[9]  =  s_logisimBus86[9];
   assign  s_logisimBus91[10]  =  s_logisimBus86[10];
   assign  s_logisimBus91[11]  =  s_logisimBus86[11];
   assign  s_logisimBus91[12]  =  s_logisimBus86[12];
   assign  s_logisimBus91[13]  =  s_logisimBus86[13];
   assign  s_logisimBus91[14]  =  s_logisimBus86[13];
   assign  s_logisimBus91[15]  =  s_logisimBus86[13];


   // Ground
   assign  s_logisimNet107  =  1'b0;


   // NOT Gate
   assign s_logisimBus86[7] = ~s_logisimNet76;

   // NOT Gate
   assign s_logisimBus86[6] = ~s_logisimNet50;

   // NOT Gate
   assign s_logisimBus86[13] = ~s_logisimNet65;

   // NOT Gate
   assign s_logisimBus86[5] = ~s_logisimNet103;

   // NOT Gate
   assign s_logisimBus86[12] = ~s_logisimNet90;

   // NOT Gate
   assign s_logisimBus86[4] = ~s_logisimNet4;

   // NOT Gate
   assign s_logisimBus86[11] = ~s_logisimNet100;

   // NOT Gate
   assign s_logisimBus86[3] = ~s_logisimNet99;

   // NOT Gate
   assign s_logisimBus86[10] = ~s_logisimNet102;

   // NOT Gate
   assign s_logisimBus86[2] = ~s_logisimNet101;

   // NOT Gate
   assign s_logisimBus86[9] = ~s_logisimNet85;

   // NOT Gate
   assign s_logisimBus86[1] = ~s_logisimNet84;

   // NOT Gate
   assign s_logisimBus86[8] = ~s_logisimNet59;

   // NOT Gate
   assign s_logisimBus86[0] = ~s_logisimNet60;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet78),
               .input2(s_logisimNet20),
               .result(s_logisimNet17));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_2 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet76),
               .dataA(s_logisimBus77[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_3 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet50),
               .dataA(s_logisimBus52[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_4 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet65),
               .dataA(s_logisimBus2[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_5 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet103),
               .dataA(s_logisimBus3[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_6 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet90),
               .dataA(s_logisimBus89[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_7 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet4),
               .dataA(s_logisimBus6[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_8 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet100),
               .dataA(s_logisimBus15[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_9 (.aEqualsB(),
               .aGreaterThanB(),
               .aLessThanB(s_logisimNet99),
               .dataA(s_logisimBus16[7:0]),
               .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_10 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet102),
                .dataA(s_logisimBus11[7:0]),
                .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_11 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet101),
                .dataA(s_logisimBus14[7:0]),
                .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_12 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet85),
                .dataA(s_logisimBus88[7:0]),
                .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_13 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet84),
                .dataA(s_logisimBus39[7:0]),
                .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_14 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet59),
                .dataA(s_logisimBus48[7:0]),
                .dataB(s_logisimBus0[7:0]));

   Comparator #(.nrOfBits(8),
                .twosComplement(0))
      ARITH_15 (.aEqualsB(),
                .aGreaterThanB(),
                .aLessThanB(s_logisimNet60),
                .dataA(s_logisimBus49[7:0]),
                .dataB(s_logisimBus0[7:0]));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   ABS8B   ABS8B_1 (.Input_bus_1(s_logisimBus51[7:0]),
                    .Output_1(s_logisimNet20),
                    .Output_bus_1(s_logisimBus104[6:0]));

   ABS16   ABS16_2 (.Input_1(s_logisimNet107),
                    .Input_bus_1(s_logisimBus64[15:0]),
                    .Output_1(),
                    .Output_2(s_logisimNet78),
                    .Output_bus_1(s_logisimBus83[15:0]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_7 (.A(s_logisimBus77[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet30),
                                                  .ENABLESUB(s_logisimBus86[7]),
                                                  .Input_1(s_logisimNet22),
                                                  .SUM(s_logisimBus52[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_8 (.A(s_logisimBus52[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet68),
                                                  .ENABLESUB(s_logisimBus86[6]),
                                                  .Input_1(s_logisimNet30),
                                                  .SUM(s_logisimBus3[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_1 (.A(s_logisimBus2[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet92),
                                                  .ENABLESUB(s_logisimBus86[13]),
                                                  .Input_1(s_logisimNet65),
                                                  .SUM(s_logisimBus89[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_9 (.A(s_logisimBus3[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet31),
                                                  .ENABLESUB(s_logisimBus86[5]),
                                                  .Input_1(s_logisimNet68),
                                                  .SUM(s_logisimBus6[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_2 (.A(s_logisimBus89[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet38),
                                                  .ENABLESUB(s_logisimBus86[12]),
                                                  .Input_1(s_logisimNet92),
                                                  .SUM(s_logisimBus15[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_10 (.A(s_logisimBus6[7:0]),
                                                   .B(s_logisimBus0[7:0]),
                                                   .COUT(s_logisimNet45),
                                                   .ENABLESUB(s_logisimBus86[4]),
                                                   .Input_1(s_logisimNet31),
                                                   .SUM(s_logisimBus16[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_3 (.A(s_logisimBus15[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet25),
                                                  .ENABLESUB(s_logisimBus86[11]),
                                                  .Input_1(s_logisimNet38),
                                                  .SUM(s_logisimBus11[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_11 (.A(s_logisimBus16[7:0]),
                                                   .B(s_logisimBus0[7:0]),
                                                   .COUT(s_logisimNet26),
                                                   .ENABLESUB(s_logisimBus86[3]),
                                                   .Input_1(s_logisimNet45),
                                                   .SUM(s_logisimBus14[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_4 (.A(s_logisimBus11[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet21),
                                                  .ENABLESUB(s_logisimBus86[10]),
                                                  .Input_1(s_logisimNet25),
                                                  .SUM(s_logisimBus88[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_12 (.A(s_logisimBus14[7:0]),
                                                   .B(s_logisimBus0[7:0]),
                                                   .COUT(s_logisimNet95),
                                                   .ENABLESUB(s_logisimBus86[2]),
                                                   .Input_1(s_logisimNet26),
                                                   .SUM(s_logisimBus39[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_5 (.A(s_logisimBus88[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(),
                                                  .ENABLESUB(s_logisimBus86[9]),
                                                  .Input_1(s_logisimNet21),
                                                  .SUM(s_logisimBus48[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_13 (.A(s_logisimBus39[7:0]),
                                                   .B(s_logisimBus0[7:0]),
                                                   .COUT(s_logisimNet47),
                                                   .ENABLESUB(s_logisimBus86[1]),
                                                   .Input_1(s_logisimNet95),
                                                   .SUM(s_logisimBus49[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_6 (.A(s_logisimBus48[7:0]),
                                                  .B(s_logisimBus0[7:0]),
                                                  .COUT(s_logisimNet22),
                                                  .ENABLESUB(s_logisimBus86[8]),
                                                  .Input_1(s_logisimNet21),
                                                  .SUM(s_logisimBus77[7:1]));

   SUBTRACTFORNEGDIVIDE   SUBTRACTFORNEGDIVIDE_14 (.A(s_logisimBus49[7:0]),
                                                   .B(s_logisimBus0[7:0]),
                                                   .COUT(s_logisimBus69[7]),
                                                   .ENABLESUB(s_logisimBus86[0]),
                                                   .Input_1(s_logisimNet47),
                                                   .SUM(s_logisimBus69[6:0]));

   ABS16   ABS16_1 (.Input_1(s_logisimNet17),
                    .Input_bus_1(s_logisimBus91[15:0]),
                    .Output_1(),
                    .Output_2(),
                    .Output_bus_1(s_logisimBus93[15:0]));

endmodule


// ============================================================================
// File: NEGMULTI.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : NEGMULTI                                                     **
 **                                                                          **
 *****************************************************************************/

module NEGMULTI( Input_bus_1,
                 Input_bus_2,
                 Output_bus_1 );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [7:0] Input_bus_1;
   input [7:0] Input_bus_2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [15:0] Output_bus_1;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [6:0]  s_logisimBus12;
   wire [10:0] s_logisimBus13;
   wire [13:0] s_logisimBus15;
   wire [7:0]  s_logisimBus16;
   wire [13:0] s_logisimBus21;
   wire [7:0]  s_logisimBus22;
   wire [7:0]  s_logisimBus26;
   wire [6:0]  s_logisimBus30;
   wire [6:0]  s_logisimBus31;
   wire [6:0]  s_logisimBus32;
   wire [6:0]  s_logisimBus33;
   wire [7:0]  s_logisimBus38;
   wire [7:0]  s_logisimBus39;
   wire [9:0]  s_logisimBus40;
   wire [10:0] s_logisimBus42;
   wire [6:0]  s_logisimBus43;
   wire [6:0]  s_logisimBus44;
   wire [7:0]  s_logisimBus45;
   wire [9:0]  s_logisimBus46;
   wire [15:0] s_logisimBus51;
   wire [7:0]  s_logisimBus52;
   wire [6:0]  s_logisimBus55;
   wire [6:0]  s_logisimBus56;
   wire [6:0]  s_logisimBus57;
   wire [6:0]  s_logisimBus58;
   wire [6:0]  s_logisimBus6;
   wire [7:0]  s_logisimBus64;
   wire [10:0] s_logisimBus66;
   wire [6:0]  s_logisimBus67;
   wire [9:0]  s_logisimBus7;
   wire [7:0]  s_logisimBus71;
   wire [7:0]  s_logisimBus72;
   wire [13:0] s_logisimBus74;
   wire [6:0]  s_logisimBus76;
   wire [15:0] s_logisimBus77;
   wire [7:0]  s_logisimBus82;
   wire [6:0]  s_logisimBus88;
   wire [6:0]  s_logisimBus89;
   wire [7:0]  s_logisimBus9;
   wire        s_logisimNet0;
   wire        s_logisimNet1;
   wire        s_logisimNet10;
   wire        s_logisimNet100;
   wire        s_logisimNet101;
   wire        s_logisimNet102;
   wire        s_logisimNet103;
   wire        s_logisimNet104;
   wire        s_logisimNet105;
   wire        s_logisimNet106;
   wire        s_logisimNet107;
   wire        s_logisimNet108;
   wire        s_logisimNet109;
   wire        s_logisimNet11;
   wire        s_logisimNet110;
   wire        s_logisimNet111;
   wire        s_logisimNet112;
   wire        s_logisimNet113;
   wire        s_logisimNet114;
   wire        s_logisimNet115;
   wire        s_logisimNet116;
   wire        s_logisimNet117;
   wire        s_logisimNet118;
   wire        s_logisimNet119;
   wire        s_logisimNet120;
   wire        s_logisimNet121;
   wire        s_logisimNet122;
   wire        s_logisimNet123;
   wire        s_logisimNet124;
   wire        s_logisimNet125;
   wire        s_logisimNet126;
   wire        s_logisimNet127;
   wire        s_logisimNet128;
   wire        s_logisimNet129;
   wire        s_logisimNet130;
   wire        s_logisimNet131;
   wire        s_logisimNet132;
   wire        s_logisimNet133;
   wire        s_logisimNet134;
   wire        s_logisimNet135;
   wire        s_logisimNet136;
   wire        s_logisimNet137;
   wire        s_logisimNet138;
   wire        s_logisimNet139;
   wire        s_logisimNet14;
   wire        s_logisimNet140;
   wire        s_logisimNet141;
   wire        s_logisimNet142;
   wire        s_logisimNet143;
   wire        s_logisimNet144;
   wire        s_logisimNet145;
   wire        s_logisimNet146;
   wire        s_logisimNet147;
   wire        s_logisimNet148;
   wire        s_logisimNet149;
   wire        s_logisimNet150;
   wire        s_logisimNet151;
   wire        s_logisimNet152;
   wire        s_logisimNet153;
   wire        s_logisimNet154;
   wire        s_logisimNet155;
   wire        s_logisimNet156;
   wire        s_logisimNet157;
   wire        s_logisimNet158;
   wire        s_logisimNet159;
   wire        s_logisimNet160;
   wire        s_logisimNet161;
   wire        s_logisimNet162;
   wire        s_logisimNet163;
   wire        s_logisimNet164;
   wire        s_logisimNet165;
   wire        s_logisimNet166;
   wire        s_logisimNet167;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet19;
   wire        s_logisimNet2;
   wire        s_logisimNet20;
   wire        s_logisimNet23;
   wire        s_logisimNet24;
   wire        s_logisimNet25;
   wire        s_logisimNet27;
   wire        s_logisimNet28;
   wire        s_logisimNet29;
   wire        s_logisimNet3;
   wire        s_logisimNet34;
   wire        s_logisimNet35;
   wire        s_logisimNet36;
   wire        s_logisimNet37;
   wire        s_logisimNet4;
   wire        s_logisimNet41;
   wire        s_logisimNet47;
   wire        s_logisimNet48;
   wire        s_logisimNet49;
   wire        s_logisimNet5;
   wire        s_logisimNet50;
   wire        s_logisimNet53;
   wire        s_logisimNet54;
   wire        s_logisimNet59;
   wire        s_logisimNet60;
   wire        s_logisimNet61;
   wire        s_logisimNet62;
   wire        s_logisimNet63;
   wire        s_logisimNet65;
   wire        s_logisimNet68;
   wire        s_logisimNet69;
   wire        s_logisimNet70;
   wire        s_logisimNet73;
   wire        s_logisimNet75;
   wire        s_logisimNet78;
   wire        s_logisimNet79;
   wire        s_logisimNet8;
   wire        s_logisimNet80;
   wire        s_logisimNet81;
   wire        s_logisimNet83;
   wire        s_logisimNet84;
   wire        s_logisimNet85;
   wire        s_logisimNet86;
   wire        s_logisimNet87;
   wire        s_logisimNet90;
   wire        s_logisimNet91;
   wire        s_logisimNet92;
   wire        s_logisimNet93;
   wire        s_logisimNet94;
   wire        s_logisimNet95;
   wire        s_logisimNet96;
   wire        s_logisimNet97;
   wire        s_logisimNet98;
   wire        s_logisimNet99;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all wiring is defined                                                 **
   *******************************************************************************/
   assign s_logisimBus12[0]  = s_logisimNet4;
   assign s_logisimBus12[1]  = s_logisimNet4;
   assign s_logisimBus12[2]  = s_logisimNet4;
   assign s_logisimBus12[3]  = s_logisimNet4;
   assign s_logisimBus12[4]  = s_logisimNet4;
   assign s_logisimBus12[5]  = s_logisimNet4;
   assign s_logisimBus12[6]  = s_logisimNet4;
   assign s_logisimBus13[0]  = s_logisimNet80;
   assign s_logisimBus13[10] = s_logisimNet75;
   assign s_logisimBus13[1]  = s_logisimNet48;
   assign s_logisimBus13[2]  = s_logisimNet91;
   assign s_logisimBus13[3]  = s_logisimNet69;
   assign s_logisimBus13[4]  = s_logisimNet37;
   assign s_logisimBus13[5]  = s_logisimNet85;
   assign s_logisimBus13[6]  = s_logisimNet62;
   assign s_logisimBus13[7]  = s_logisimNet19;
   assign s_logisimBus13[9]  = s_logisimNet75;
   assign s_logisimBus15[0]  = s_logisimNet10;
   assign s_logisimBus15[10] = s_logisimNet164;
   assign s_logisimBus15[11] = s_logisimNet165;
   assign s_logisimBus15[12] = s_logisimNet166;
   assign s_logisimBus15[13] = s_logisimNet167;
   assign s_logisimBus15[1]  = s_logisimNet10;
   assign s_logisimBus15[2]  = s_logisimNet10;
   assign s_logisimBus15[3]  = s_logisimNet10;
   assign s_logisimBus15[4]  = s_logisimNet158;
   assign s_logisimBus15[5]  = s_logisimNet159;
   assign s_logisimBus15[6]  = s_logisimNet160;
   assign s_logisimBus15[7]  = s_logisimNet161;
   assign s_logisimBus15[8]  = s_logisimNet162;
   assign s_logisimBus15[9]  = s_logisimNet163;
   assign s_logisimBus16[0]  = s_logisimNet93;
   assign s_logisimBus16[1]  = s_logisimNet94;
   assign s_logisimBus16[2]  = s_logisimNet95;
   assign s_logisimBus16[3]  = s_logisimNet96;
   assign s_logisimBus16[4]  = s_logisimNet97;
   assign s_logisimBus16[5]  = s_logisimNet98;
   assign s_logisimBus16[6]  = s_logisimNet99;
   assign s_logisimBus26[0]  = s_logisimNet133;
   assign s_logisimBus26[1]  = s_logisimNet134;
   assign s_logisimBus26[2]  = s_logisimNet135;
   assign s_logisimBus26[3]  = s_logisimNet136;
   assign s_logisimBus26[4]  = s_logisimNet137;
   assign s_logisimBus26[5]  = s_logisimNet138;
   assign s_logisimBus26[6]  = s_logisimNet139;
   assign s_logisimBus30[0]  = s_logisimNet3;
   assign s_logisimBus30[1]  = s_logisimNet3;
   assign s_logisimBus30[2]  = s_logisimNet3;
   assign s_logisimBus30[3]  = s_logisimNet3;
   assign s_logisimBus30[4]  = s_logisimNet3;
   assign s_logisimBus30[5]  = s_logisimNet3;
   assign s_logisimBus30[6]  = s_logisimNet3;
   assign s_logisimBus33[0]  = s_logisimNet0;
   assign s_logisimBus33[1]  = s_logisimNet0;
   assign s_logisimBus33[2]  = s_logisimNet0;
   assign s_logisimBus33[3]  = s_logisimNet0;
   assign s_logisimBus33[4]  = s_logisimNet0;
   assign s_logisimBus33[5]  = s_logisimNet0;
   assign s_logisimBus33[6]  = s_logisimNet0;
   assign s_logisimBus38[0]  = s_logisimNet117;
   assign s_logisimBus38[1]  = s_logisimNet118;
   assign s_logisimBus38[2]  = s_logisimNet119;
   assign s_logisimBus38[3]  = s_logisimNet120;
   assign s_logisimBus38[4]  = s_logisimNet121;
   assign s_logisimBus38[5]  = s_logisimNet122;
   assign s_logisimBus38[6]  = s_logisimNet123;
   assign s_logisimBus39[1]  = s_logisimNet142;
   assign s_logisimBus39[2]  = s_logisimNet143;
   assign s_logisimBus39[3]  = s_logisimNet144;
   assign s_logisimBus39[4]  = s_logisimNet145;
   assign s_logisimBus39[5]  = s_logisimNet146;
   assign s_logisimBus39[6]  = s_logisimNet147;
   assign s_logisimBus39[7]  = s_logisimNet148;
   assign s_logisimBus42[0]  = s_logisimNet29;
   assign s_logisimBus42[1]  = s_logisimNet29;
   assign s_logisimBus42[2]  = s_logisimNet149;
   assign s_logisimBus42[3]  = s_logisimNet150;
   assign s_logisimBus42[4]  = s_logisimNet151;
   assign s_logisimBus42[5]  = s_logisimNet152;
   assign s_logisimBus42[6]  = s_logisimNet153;
   assign s_logisimBus42[7]  = s_logisimNet154;
   assign s_logisimBus42[8]  = s_logisimNet155;
   assign s_logisimBus42[9]  = s_logisimNet156;
   assign s_logisimBus44[0]  = s_logisimNet2;
   assign s_logisimBus44[1]  = s_logisimNet2;
   assign s_logisimBus44[2]  = s_logisimNet2;
   assign s_logisimBus44[3]  = s_logisimNet2;
   assign s_logisimBus44[4]  = s_logisimNet2;
   assign s_logisimBus44[5]  = s_logisimNet2;
   assign s_logisimBus44[6]  = s_logisimNet2;
   assign s_logisimBus46[0]  = s_logisimNet63;
   assign s_logisimBus46[1]  = s_logisimNet20;
   assign s_logisimBus46[2]  = s_logisimNet81;
   assign s_logisimBus46[3]  = s_logisimNet49;
   assign s_logisimBus46[4]  = s_logisimNet92;
   assign s_logisimBus46[5]  = s_logisimNet70;
   assign s_logisimBus46[6]  = s_logisimNet36;
   assign s_logisimBus46[7]  = s_logisimNet86;
   assign s_logisimBus57[0]  = s_logisimNet1;
   assign s_logisimBus57[1]  = s_logisimNet1;
   assign s_logisimBus57[2]  = s_logisimNet1;
   assign s_logisimBus57[3]  = s_logisimNet1;
   assign s_logisimBus57[4]  = s_logisimNet1;
   assign s_logisimBus57[5]  = s_logisimNet1;
   assign s_logisimBus57[6]  = s_logisimNet1;
   assign s_logisimBus64[1]  = s_logisimNet126;
   assign s_logisimBus64[2]  = s_logisimNet127;
   assign s_logisimBus64[3]  = s_logisimNet128;
   assign s_logisimBus64[4]  = s_logisimNet129;
   assign s_logisimBus64[5]  = s_logisimNet130;
   assign s_logisimBus64[6]  = s_logisimNet131;
   assign s_logisimBus64[7]  = s_logisimNet132;
   assign s_logisimBus74[0]  = s_logisimNet59;
   assign s_logisimBus74[10] = s_logisimNet79;
   assign s_logisimBus74[12] = s_logisimNet11;
   assign s_logisimBus74[13] = s_logisimNet11;
   assign s_logisimBus74[1]  = s_logisimNet17;
   assign s_logisimBus74[2]  = s_logisimNet78;
   assign s_logisimBus74[3]  = s_logisimNet47;
   assign s_logisimBus74[4]  = s_logisimNet90;
   assign s_logisimBus74[5]  = s_logisimNet68;
   assign s_logisimBus74[6]  = s_logisimNet35;
   assign s_logisimBus74[7]  = s_logisimNet84;
   assign s_logisimBus74[8]  = s_logisimNet60;
   assign s_logisimBus74[9]  = s_logisimNet18;
   assign s_logisimBus7[0]   = s_logisimNet14;
   assign s_logisimBus7[1]   = s_logisimNet14;
   assign s_logisimBus7[2]   = s_logisimNet87;
   assign s_logisimBus7[3]   = s_logisimNet65;
   assign s_logisimBus7[4]   = s_logisimNet27;
   assign s_logisimBus7[5]   = s_logisimNet83;
   assign s_logisimBus7[6]   = s_logisimNet54;
   assign s_logisimBus7[7]   = s_logisimNet8;
   assign s_logisimBus7[8]   = s_logisimNet73;
   assign s_logisimBus7[9]   = s_logisimNet41;
   assign s_logisimBus82[1]  = s_logisimNet102;
   assign s_logisimBus82[2]  = s_logisimNet103;
   assign s_logisimBus82[3]  = s_logisimNet104;
   assign s_logisimBus82[4]  = s_logisimNet105;
   assign s_logisimBus82[5]  = s_logisimNet106;
   assign s_logisimBus82[6]  = s_logisimNet107;
   assign s_logisimBus82[7]  = s_logisimNet108;
   assign s_logisimBus88[0]  = s_logisimNet24;
   assign s_logisimBus88[1]  = s_logisimNet24;
   assign s_logisimBus88[2]  = s_logisimNet24;
   assign s_logisimBus88[3]  = s_logisimNet24;
   assign s_logisimBus88[4]  = s_logisimNet24;
   assign s_logisimBus88[5]  = s_logisimNet24;
   assign s_logisimBus88[6]  = s_logisimNet24;
   assign s_logisimBus89[0]  = s_logisimNet25;
   assign s_logisimBus89[1]  = s_logisimNet25;
   assign s_logisimBus89[2]  = s_logisimNet25;
   assign s_logisimBus89[3]  = s_logisimNet25;
   assign s_logisimBus89[4]  = s_logisimNet25;
   assign s_logisimBus89[5]  = s_logisimNet25;
   assign s_logisimBus89[6]  = s_logisimNet25;
   assign s_logisimBus9[0]   = s_logisimNet109;
   assign s_logisimBus9[1]   = s_logisimNet110;
   assign s_logisimBus9[2]   = s_logisimNet111;
   assign s_logisimBus9[3]   = s_logisimNet112;
   assign s_logisimBus9[4]   = s_logisimNet113;
   assign s_logisimBus9[5]   = s_logisimNet114;
   assign s_logisimBus9[6]   = s_logisimNet115;
   assign s_logisimNet0      = s_logisimBus58[2];
   assign s_logisimNet1      = s_logisimBus58[1];
   assign s_logisimNet102    = s_logisimBus76[0];
   assign s_logisimNet103    = s_logisimBus76[1];
   assign s_logisimNet104    = s_logisimBus76[2];
   assign s_logisimNet105    = s_logisimBus76[3];
   assign s_logisimNet106    = s_logisimBus76[4];
   assign s_logisimNet107    = s_logisimBus76[5];
   assign s_logisimNet108    = s_logisimBus76[6];
   assign s_logisimNet109    = s_logisimBus67[0];
   assign s_logisimNet110    = s_logisimBus67[1];
   assign s_logisimNet111    = s_logisimBus67[2];
   assign s_logisimNet112    = s_logisimBus67[3];
   assign s_logisimNet113    = s_logisimBus67[4];
   assign s_logisimNet114    = s_logisimBus67[5];
   assign s_logisimNet115    = s_logisimBus67[6];
   assign s_logisimNet117    = s_logisimBus32[0];
   assign s_logisimNet118    = s_logisimBus32[1];
   assign s_logisimNet119    = s_logisimBus32[2];
   assign s_logisimNet120    = s_logisimBus32[3];
   assign s_logisimNet121    = s_logisimBus32[4];
   assign s_logisimNet122    = s_logisimBus32[5];
   assign s_logisimNet123    = s_logisimBus32[6];
   assign s_logisimNet126    = s_logisimBus56[0];
   assign s_logisimNet127    = s_logisimBus56[1];
   assign s_logisimNet128    = s_logisimBus56[2];
   assign s_logisimNet129    = s_logisimBus56[3];
   assign s_logisimNet130    = s_logisimBus56[4];
   assign s_logisimNet131    = s_logisimBus56[5];
   assign s_logisimNet132    = s_logisimBus56[6];
   assign s_logisimNet133    = s_logisimBus43[0];
   assign s_logisimNet134    = s_logisimBus43[1];
   assign s_logisimNet135    = s_logisimBus43[2];
   assign s_logisimNet136    = s_logisimBus43[3];
   assign s_logisimNet137    = s_logisimBus43[4];
   assign s_logisimNet138    = s_logisimBus43[5];
   assign s_logisimNet139    = s_logisimBus43[6];
   assign s_logisimNet142    = s_logisimBus31[0];
   assign s_logisimNet143    = s_logisimBus31[1];
   assign s_logisimNet144    = s_logisimBus31[2];
   assign s_logisimNet145    = s_logisimBus31[3];
   assign s_logisimNet146    = s_logisimBus31[4];
   assign s_logisimNet147    = s_logisimBus31[5];
   assign s_logisimNet148    = s_logisimBus31[6];
   assign s_logisimNet149    = s_logisimBus22[0];
   assign s_logisimNet150    = s_logisimBus22[1];
   assign s_logisimNet151    = s_logisimBus22[2];
   assign s_logisimNet152    = s_logisimBus22[3];
   assign s_logisimNet153    = s_logisimBus22[4];
   assign s_logisimNet154    = s_logisimBus22[5];
   assign s_logisimNet155    = s_logisimBus22[6];
   assign s_logisimNet156    = s_logisimBus22[7];
   assign s_logisimNet158    = s_logisimBus40[0];
   assign s_logisimNet159    = s_logisimBus40[1];
   assign s_logisimNet160    = s_logisimBus40[2];
   assign s_logisimNet161    = s_logisimBus40[3];
   assign s_logisimNet162    = s_logisimBus40[4];
   assign s_logisimNet163    = s_logisimBus40[5];
   assign s_logisimNet164    = s_logisimBus40[6];
   assign s_logisimNet165    = s_logisimBus40[7];
   assign s_logisimNet166    = s_logisimBus40[8];
   assign s_logisimNet167    = s_logisimBus40[9];
   assign s_logisimNet17     = s_logisimBus66[1];
   assign s_logisimNet18     = s_logisimBus66[9];
   assign s_logisimNet19     = s_logisimBus72[7];
   assign s_logisimNet2      = s_logisimBus58[0];
   assign s_logisimNet20     = s_logisimBus52[1];
   assign s_logisimNet24     = s_logisimBus58[6];
   assign s_logisimNet25     = s_logisimBus58[3];
   assign s_logisimNet27     = s_logisimBus38[2];
   assign s_logisimNet3      = s_logisimBus58[5];
   assign s_logisimNet35     = s_logisimBus66[6];
   assign s_logisimNet36     = s_logisimBus52[6];
   assign s_logisimNet37     = s_logisimBus72[4];
   assign s_logisimNet4      = s_logisimBus58[4];
   assign s_logisimNet41     = s_logisimBus38[7];
   assign s_logisimNet47     = s_logisimBus66[3];
   assign s_logisimNet48     = s_logisimBus72[1];
   assign s_logisimNet49     = s_logisimBus52[3];
   assign s_logisimNet54     = s_logisimBus38[4];
   assign s_logisimNet59     = s_logisimBus66[0];
   assign s_logisimNet60     = s_logisimBus66[8];
   assign s_logisimNet62     = s_logisimBus72[6];
   assign s_logisimNet63     = s_logisimBus52[0];
   assign s_logisimNet65     = s_logisimBus38[1];
   assign s_logisimNet68     = s_logisimBus66[5];
   assign s_logisimNet69     = s_logisimBus72[3];
   assign s_logisimNet70     = s_logisimBus52[5];
   assign s_logisimNet73     = s_logisimBus38[6];
   assign s_logisimNet78     = s_logisimBus66[2];
   assign s_logisimNet79     = s_logisimBus66[10];
   assign s_logisimNet8      = s_logisimBus38[5];
   assign s_logisimNet80     = s_logisimBus72[0];
   assign s_logisimNet81     = s_logisimBus52[2];
   assign s_logisimNet83     = s_logisimBus38[3];
   assign s_logisimNet84     = s_logisimBus66[7];
   assign s_logisimNet85     = s_logisimBus72[5];
   assign s_logisimNet86     = s_logisimBus52[7];
   assign s_logisimNet87     = s_logisimBus38[0];
   assign s_logisimNet90     = s_logisimBus66[4];
   assign s_logisimNet91     = s_logisimBus72[2];
   assign s_logisimNet92     = s_logisimBus52[4];
   assign s_logisimNet93     = s_logisimBus55[0];
   assign s_logisimNet94     = s_logisimBus55[1];
   assign s_logisimNet95     = s_logisimBus55[2];
   assign s_logisimNet96     = s_logisimBus55[3];
   assign s_logisimNet97     = s_logisimBus55[4];
   assign s_logisimNet98     = s_logisimBus55[5];
   assign s_logisimNet99     = s_logisimBus55[6];

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus45[7:0] = Input_bus_2;
   assign s_logisimBus71[7:0] = Input_bus_1;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_bus_1 = s_logisimBus51[15:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Ground
   assign  s_logisimBus16[7]  =  1'b0;


   // Ground
   assign  s_logisimBus82[0]  =  1'b0;


   // Ground
   assign  s_logisimBus9[7]  =  1'b0;


   // Ground
   assign  s_logisimBus38[7]  =  1'b0;


   // Ground
   assign  s_logisimBus64[0]  =  1'b0;


   // Ground
   assign  s_logisimBus26[7]  =  1'b0;


   // Ground
   assign  s_logisimBus39[0]  =  1'b0;


   // Ground
   assign  s_logisimNet14  =  1'b0;


   // Ground
   assign  s_logisimNet29  =  1'b0;


   // Ground
   assign  s_logisimNet75  =  1'b0;


   // Ground
   assign  s_logisimBus46[9]  =  1'b0;


   // Ground
   assign  s_logisimNet10  =  1'b0;


   // Ground
   assign  s_logisimNet11  =  1'b0;


   // Bit Extender
   assign  s_logisimBus77[0]  =  s_logisimBus21[0];
   assign  s_logisimBus77[1]  =  s_logisimBus21[1];
   assign  s_logisimBus77[2]  =  s_logisimBus21[2];
   assign  s_logisimBus77[3]  =  s_logisimBus21[3];
   assign  s_logisimBus77[4]  =  s_logisimBus21[4];
   assign  s_logisimBus77[5]  =  s_logisimBus21[5];
   assign  s_logisimBus77[6]  =  s_logisimBus21[6];
   assign  s_logisimBus77[7]  =  s_logisimBus21[7];
   assign  s_logisimBus77[8]  =  s_logisimBus21[8];
   assign  s_logisimBus77[9]  =  s_logisimBus21[9];
   assign  s_logisimBus77[10]  =  s_logisimBus21[10];
   assign  s_logisimBus77[11]  =  s_logisimBus21[11];
   assign  s_logisimBus77[12]  =  s_logisimBus21[12];
   assign  s_logisimBus77[13]  =  s_logisimBus21[13];
   assign  s_logisimBus77[14]  =  1'b0;
   assign  s_logisimBus77[15]  =  1'b0;


   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_1 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus89[6:0]),
               .result(s_logisimBus31[6:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_2 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus33[6:0]),
               .result(s_logisimBus55[6:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_3 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus57[6:0]),
               .result(s_logisimBus76[6:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_4 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus44[6:0]),
               .result(s_logisimBus67[6:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_5 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus88[6:0]),
               .result(s_logisimBus32[6:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_6 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus30[6:0]),
               .result(s_logisimBus56[6:0]));

   AND_GATE_BUS #(.BubblesMask(2'b00),
                  .NrOfBits(7))
      GATES_7 (.input1(s_logisimBus6[6:0]),
               .input2(s_logisimBus12[6:0]),
               .result(s_logisimBus43[6:0]));

   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_8 (.input1(s_logisimNet34),
               .input2(s_logisimNet23),
               .result(s_logisimNet5));

   Adder #(.extendedBits(9),
           .nrOfBits(8))
      ARITH_9 (.carryIn(1'b0),
               .carryOut(s_logisimBus13[8]),
               .dataA(s_logisimBus82[7:0]),
               .dataB(s_logisimBus9[7:0]),
               .result(s_logisimBus72[7:0]));

   Adder #(.extendedBits(9),
           .nrOfBits(8))
      ARITH_10 (.carryIn(1'b0),
                .carryOut(s_logisimBus46[8]),
                .dataA(s_logisimBus64[7:0]),
                .dataB(s_logisimBus26[7:0]),
                .result(s_logisimBus52[7:0]));

   Adder #(.extendedBits(9),
           .nrOfBits(8))
      ARITH_11 (.carryIn(1'b0),
                .carryOut(s_logisimBus42[10]),
                .dataA(s_logisimBus39[7:0]),
                .dataB(s_logisimBus16[7:0]),
                .result(s_logisimBus22[7:0]));

   Adder #(.extendedBits(11),
           .nrOfBits(10))
      ARITH_12 (.carryIn(1'b0),
                .carryOut(),
                .dataA(s_logisimBus7[9:0]),
                .dataB(s_logisimBus46[9:0]),
                .result(s_logisimBus40[9:0]));

   Adder #(.extendedBits(12),
           .nrOfBits(11))
      ARITH_13 (.carryIn(1'b0),
                .carryOut(s_logisimBus74[11]),
                .dataA(s_logisimBus42[10:0]),
                .dataB(s_logisimBus13[10:0]),
                .result(s_logisimBus66[10:0]));

   Adder #(.extendedBits(15),
           .nrOfBits(14))
      ARITH_14 (.carryIn(1'b0),
                .carryOut(),
                .dataA(s_logisimBus15[13:0]),
                .dataB(s_logisimBus74[13:0]),
                .result(s_logisimBus21[13:0]));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   ABS16   ABS16_1 (.Input_1(s_logisimNet5),
                    .Input_bus_1(s_logisimBus77[15:0]),
                    .Output_1(),
                    .Output_2(),
                    .Output_bus_1(s_logisimBus51[15:0]));

   ABS8B   ABS8B_1 (.Input_bus_1(s_logisimBus71[7:0]),
                    .Output_1(s_logisimNet34),
                    .Output_bus_1(s_logisimBus6[6:0]));

   ABS8B   ABS8B_2 (.Input_bus_1(s_logisimBus45[7:0]),
                    .Output_1(s_logisimNet23),
                    .Output_bus_1(s_logisimBus58[6:0]));

endmodule


// ============================================================================
// File: REGISTERS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : REGISTERS                                                    **
 **                                                                          **
 *****************************************************************************/

module REGISTERS( ADDRESS,
                  CLK,
                  DATA,
                  Output_bus_1,
                  Output_bus_2,
                  WRITE );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [3:0] ADDRESS;
   input       CLK;
   input [7:0] DATA;
   input       WRITE;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0]  Output_bus_1;
   output [23:0] Output_bus_2;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [3:0]  s_logisimBus1;
   wire [23:0] s_logisimBus2;
   wire [7:0]  s_logisimBus5;
   wire        s_logisimNet0;
   wire        s_logisimNet7;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus1[3:0] = ADDRESS;
   assign s_logisimBus5[7:0] = DATA;
   assign s_logisimNet0      = WRITE;
   assign s_logisimNet7      = CLK;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign Output_bus_1 = s_logisimBus2[7:0];
   assign Output_bus_2 = s_logisimBus2[23:0];

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   RAMCONTENTS_RAM_1   RAM_1 (.address(s_logisimBus1[3:0]),
                              .clock(s_logisimNet7),
                              .data0In(s_logisimBus5[7:0]),
                              .data0Out(s_logisimBus2[7:0]),
                              .data1In(8'd0),
                              .data1Out(s_logisimBus2[15:8]),
                              .data2In(8'd0),
                              .data2Out(s_logisimBus2[23:16]),
                              .data3In(8'd0),
                              .data3Out(),
                              .lineEnable0In(s_logisimNet0),
                              .lineEnable1In(1'b0),
                              .lineEnable2In(1'b0),
                              .lineEnable3In(1'b0),
                              .tick(1'b1),
                              .we(s_logisimNet0));


endmodule


// ============================================================================
// File: SORTSHIFT.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : SORTSHIFT                                                    **
 **                                                                          **
 *****************************************************************************/

module SORTSHIFT( CLK,
                  COORDATA,
                  LDX,
                  LDY,
                  RST,
                  SORT,
                  SORTED,
                  X1,
                  X2,
                  XMID,
                  Y1,
                  Y2,
                  YMID );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLK;
   input [7:0] COORDATA;
   input       LDX;
   input       LDY;
   input       RST;
   input       SORT;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       SORTED;
   output [7:0] X1;
   output [7:0] X2;
   output [7:0] XMID;
   output [7:0] Y1;
   output [7:0] Y2;
   output [7:0] YMID;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus0;
   wire [7:0] s_logisimBus12;
   wire [7:0] s_logisimBus13;
   wire [7:0] s_logisimBus14;
   wire [7:0] s_logisimBus17;
   wire [7:0] s_logisimBus19;
   wire [7:0] s_logisimBus20;
   wire [7:0] s_logisimBus21;
   wire [7:0] s_logisimBus4;
   wire [7:0] s_logisimBus5;
   wire [7:0] s_logisimBus6;
   wire [7:0] s_logisimBus7;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet18;
   wire       s_logisimNet2;
   wire       s_logisimNet22;
   wire       s_logisimNet3;
   wire       s_logisimNet8;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus17[7:0] = COORDATA;
   assign s_logisimNet1       = CLK;
   assign s_logisimNet10      = LDX;
   assign s_logisimNet15      = RST;
   assign s_logisimNet18      = LDY;
   assign s_logisimNet3       = SORT;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign SORTED = s_logisimNet9;
   assign X1     = s_logisimBus12[7:0];
   assign X2     = s_logisimBus0[7:0];
   assign XMID   = s_logisimBus4[7:0];
   assign Y1     = s_logisimBus19[7:0];
   assign Y2     = s_logisimBus5[7:0];
   assign YMID   = s_logisimBus6[7:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Constant
   assign  s_logisimBus20[7:0]  =  8'h80;


   // NOT Gate
   assign s_logisimNet22 = ~s_logisimNet2;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet8),
               .input2(s_logisimNet11),
               .result(s_logisimNet16));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet16),
               .input2(s_logisimNet3),
               .result(s_logisimNet2));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet22),
               .input2(s_logisimNet3),
               .result(s_logisimNet9));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_4 (.borrowIn(1'b0),
               .borrowOut(s_logisimNet8),
               .dataA(s_logisimBus19[7:0]),
               .dataB(s_logisimBus6[7:0]),
               .result());

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_5 (.borrowIn(1'b0),
               .borrowOut(s_logisimNet11),
               .dataA(s_logisimBus6[7:0]),
               .dataB(s_logisimBus5[7:0]),
               .result());

   Adder #(.extendedBits(9),
           .nrOfBits(8))
      ARITH_6 (.carryIn(1'b0),
               .carryOut(),
               .dataA(s_logisimBus17[7:0]),
               .dataB(s_logisimBus20[7:0]),
               .result(s_logisimBus21[7:0]));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_7 (.borrowIn(1'b0),
               .borrowOut(),
               .dataA(s_logisimBus20[7:0]),
               .dataB(s_logisimBus17[7:0]),
               .result(s_logisimBus14[7:0]));

   SHIFTREG_3_Classic #(.negateClock(1),
                        .nrOfBits(8))
      MEMORY_8 (.D0(s_logisimBus7[7:0]),
                .D1(s_logisimBus0[7:0]),
                .D2(s_logisimBus4[7:0]),
                .Q0(s_logisimBus0[7:0]),
                .Q1(s_logisimBus4[7:0]),
                .Q2(s_logisimBus12[7:0]),
                .clock(s_logisimNet1),
                .parLoad(s_logisimNet2),
                .reset(s_logisimNet15),
                .shiftEnable(s_logisimNet10),
                .shiftIn(s_logisimBus21[7:0]),
                .shiftOut(s_logisimBus7[7:0]),
                .tick(1'b1));

   SHIFTREG_3_Classic #(.negateClock(1),
                        .nrOfBits(8))
      MEMORY_9 (.D0(s_logisimBus13[7:0]),
                .D1(s_logisimBus5[7:0]),
                .D2(s_logisimBus6[7:0]),
                .Q0(s_logisimBus5[7:0]),
                .Q1(s_logisimBus6[7:0]),
                .Q2(s_logisimBus19[7:0]),
                .clock(s_logisimNet1),
                .parLoad(s_logisimNet2),
                .reset(s_logisimNet15),
                .shiftEnable(s_logisimNet18),
                .shiftIn(s_logisimBus14[7:0]),
                .shiftOut(s_logisimBus13[7:0]),
                .tick(1'b1));


endmodule


// ============================================================================
// File: STCK.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : STCK                                                         **
 **                                                                          **
 *****************************************************************************/

module STCK( CLOCK,
             DATA,
             POP,
             PUSH,
             RESET,
             STACKOUT );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLOCK;
   input [7:0] DATA;
   input       POP;
   input       PUSH;
   input       RESET;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] STACKOUT;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0]  s_logisimBus0;
   wire [7:0]  s_logisimBus1;
   wire [7:0]  s_logisimBus5;
   wire [63:0] s_logisimBus6;
   wire [63:0] s_logisimBus7;
   wire [7:0]  s_logisimBus8;
   wire        s_logisimNet2;
   wire        s_logisimNet3;
   wire        s_logisimNet4;
   wire        s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus1[7:0] = DATA;
   assign s_logisimNet2      = POP;
   assign s_logisimNet3      = CLOCK;
   assign s_logisimNet4      = RESET;
   assign s_logisimNet9      = PUSH;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign STACKOUT = s_logisimBus8[7:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Ground
   assign  s_logisimBus0[7:0]  =  8'h00;


   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   SHIFTREG_18_Classic #(.negateClock(0),
                         .nrOfBits(8))
      MEMORY_1 (.D0(s_logisimBus5[7:0]),
                .D1(s_logisimBus6[63:56]),
                .D10(s_logisimBus7[55:48]),
                .D11(s_logisimBus7[47:40]),
                .D12(s_logisimBus7[39:32]),
                .D13(s_logisimBus7[31:24]),
                .D14(s_logisimBus7[23:16]),
                .D15(s_logisimBus7[15:8]),
                .D16(s_logisimBus7[7:0]),
                .D17(s_logisimBus0[7:0]),
                .D2(s_logisimBus6[55:48]),
                .D3(s_logisimBus6[47:40]),
                .D4(s_logisimBus6[39:32]),
                .D5(s_logisimBus6[31:24]),
                .D6(s_logisimBus6[23:16]),
                .D7(s_logisimBus6[15:8]),
                .D8(s_logisimBus6[7:0]),
                .D9(s_logisimBus7[63:56]),
                .Q0(s_logisimBus8[7:0]),
                .Q1(s_logisimBus5[7:0]),
                .Q10(s_logisimBus7[63:56]),
                .Q11(s_logisimBus7[55:48]),
                .Q12(s_logisimBus7[47:40]),
                .Q13(s_logisimBus7[39:32]),
                .Q14(s_logisimBus7[31:24]),
                .Q15(s_logisimBus7[23:16]),
                .Q16(s_logisimBus7[15:8]),
                .Q17(s_logisimBus7[7:0]),
                .Q2(s_logisimBus6[63:56]),
                .Q3(s_logisimBus6[55:48]),
                .Q4(s_logisimBus6[47:40]),
                .Q5(s_logisimBus6[39:32]),
                .Q6(s_logisimBus6[31:24]),
                .Q7(s_logisimBus6[23:16]),
                .Q8(s_logisimBus6[15:8]),
                .Q9(s_logisimBus6[7:0]),
                .clock(s_logisimNet3),
                .parLoad(s_logisimNet2),
                .reset(s_logisimNet4),
                .shiftEnable(s_logisimNet9),
                .shiftIn(s_logisimBus1[7:0]),
                .shiftOut(),
                .tick(1'b1));


endmodule


// ============================================================================
// File: SUBTRACTFORNEGDIVIDE.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : SUBTRACTFORNEGDIVIDE                                         **
 **                                                                          **
 *****************************************************************************/

module SUBTRACTFORNEGDIVIDE( A,
                             B,
                             COUT,
                             ENABLESUB,
                             Input_1,
                             SUM );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [7:0] A;
   input [7:0] B;
   input       ENABLESUB;
   input       Input_1;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       COUT;
   output [6:0] SUM;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus17;
   wire [7:0] s_logisimBus34;
   wire [7:0] s_logisimBus39;
   wire [6:0] s_logisimBus6;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet14;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet18;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet20;
   wire       s_logisimNet21;
   wire       s_logisimNet22;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet27;
   wire       s_logisimNet28;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet30;
   wire       s_logisimNet31;
   wire       s_logisimNet32;
   wire       s_logisimNet33;
   wire       s_logisimNet35;
   wire       s_logisimNet36;
   wire       s_logisimNet37;
   wire       s_logisimNet38;
   wire       s_logisimNet4;
   wire       s_logisimNet5;
   wire       s_logisimNet7;
   wire       s_logisimNet8;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus34[7:0] = B;
   assign s_logisimBus39[7:0] = A;
   assign s_logisimNet4       = ENABLESUB;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign COUT = s_logisimNet36;
   assign SUM  = s_logisimBus6[6:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // NOT Gate
   assign s_logisimBus17 = ~s_logisimBus34;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimBus17[0]),
               .input2(s_logisimNet4),
               .result(s_logisimNet19));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimBus17[1]),
               .input2(s_logisimNet4),
               .result(s_logisimNet20));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimBus17[2]),
               .input2(s_logisimNet4),
               .result(s_logisimNet21));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimBus17[3]),
               .input2(s_logisimNet4),
               .result(s_logisimNet22));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimBus17[4]),
               .input2(s_logisimNet4),
               .result(s_logisimNet1));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimBus17[5]),
               .input2(s_logisimNet4),
               .result(s_logisimNet2));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimBus17[6]),
               .input2(s_logisimNet4),
               .result(s_logisimNet3));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   FA   FA_1 (.A(s_logisimBus39[0]),
              .B(s_logisimNet19),
              .C(s_logisimNet4),
              .COUT(s_logisimNet24),
              .SUM(s_logisimBus6[0]));

   FA   FA_2 (.A(s_logisimBus39[1]),
              .B(s_logisimNet20),
              .C(s_logisimNet24),
              .COUT(s_logisimNet25),
              .SUM(s_logisimBus6[1]));

   FA   FA_3 (.A(s_logisimBus39[2]),
              .B(s_logisimNet21),
              .C(s_logisimNet25),
              .COUT(s_logisimNet26),
              .SUM(s_logisimBus6[2]));

   FA   FA_4 (.A(s_logisimBus39[3]),
              .B(s_logisimNet22),
              .C(s_logisimNet26),
              .COUT(s_logisimNet27),
              .SUM(s_logisimBus6[3]));

   FA   FA_5 (.A(s_logisimBus39[4]),
              .B(s_logisimNet1),
              .C(s_logisimNet27),
              .COUT(s_logisimNet28),
              .SUM(s_logisimBus6[4]));

   FA   FA_6 (.A(s_logisimBus39[5]),
              .B(s_logisimNet2),
              .C(s_logisimNet28),
              .COUT(s_logisimNet29),
              .SUM(s_logisimBus6[5]));

   FA   FA_7 (.A(s_logisimBus39[6]),
              .B(s_logisimNet3),
              .C(s_logisimNet29),
              .COUT(s_logisimNet36),
              .SUM(s_logisimBus6[6]));

endmodule


// ============================================================================
// File: TRIANGLE.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : TRIANGLE                                                     **
 **                                                                          **
 *****************************************************************************/

module TRIANGLE( CLK,
                 COORD,
                 DONE,
                 SET,
                 START,
                 X,
                 XLOW,
                 XMID,
                 XTOP,
                 Y,
                 YLOW,
                 YMID,
                 YTOP );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLK;
   input       SET;
   input       START;
   input [7:0] XLOW;
   input [7:0] XMID;
   input [7:0] XTOP;
   input [7:0] YLOW;
   input [7:0] YMID;
   input [7:0] YTOP;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] COORD;
   output       DONE;
   output       X;
   output       Y;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus12;
   wire [7:0] s_logisimBus13;
   wire [7:0] s_logisimBus14;
   wire [7:0] s_logisimBus18;
   wire [7:0] s_logisimBus20;
   wire [7:0] s_logisimBus21;
   wire [7:0] s_logisimBus22;
   wire [7:0] s_logisimBus26;
   wire [7:0] s_logisimBus27;
   wire [7:0] s_logisimBus28;
   wire [7:0] s_logisimBus33;
   wire [7:0] s_logisimBus34;
   wire [7:0] s_logisimBus40;
   wire [7:0] s_logisimBus5;
   wire [7:0] s_logisimBus6;
   wire [7:0] s_logisimBus7;
   wire [7:0] s_logisimBus9;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet17;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet30;
   wire       s_logisimNet31;
   wire       s_logisimNet32;
   wire       s_logisimNet35;
   wire       s_logisimNet36;
   wire       s_logisimNet37;
   wire       s_logisimNet38;
   wire       s_logisimNet39;
   wire       s_logisimNet4;
   wire       s_logisimNet8;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus20[7:0] = YTOP;
   assign s_logisimBus26[7:0] = YMID;
   assign s_logisimBus27[7:0] = XMID;
   assign s_logisimBus5[7:0]  = YLOW;
   assign s_logisimBus6[7:0]  = XTOP;
   assign s_logisimBus9[7:0]  = XLOW;
   assign s_logisimNet11      = CLK;
   assign s_logisimNet15      = START;
   assign s_logisimNet29      = SET;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign COORD = s_logisimBus28[7:0];
   assign DONE  = s_logisimNet4;
   assign X     = s_logisimNet30;
   assign Y     = s_logisimNet39;

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Constant
   assign  s_logisimBus7[7:0]  =  8'h40;


   // NOT Gate
   assign s_logisimNet32 = ~s_logisimBus28[7];

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   OR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_1 (.input1(s_logisimNet15),
               .input2(s_logisimNet23),
               .input3(s_logisimNet4),
               .result(s_logisimNet19));

   OR_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_2 (.input1(s_logisimNet15),
               .input2(s_logisimNet23),
               .input3(s_logisimNet2),
               .result(s_logisimNet3));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet1),
               .input2(s_logisimNet25),
               .result(s_logisimNet24));

   OR_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet10),
               .input2(s_logisimNet24),
               .result(s_logisimNet38));

   AND_GATE_3_INPUTS #(.BubblesMask(3'b000))
      GATES_5 (.input1(s_logisimNet2),
               .input2(s_logisimNet10),
               .input3(s_logisimNet8),
               .result(s_logisimNet37));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_6 (.input1(s_logisimNet36),
               .input2(s_logisimNet10),
               .result(s_logisimNet23));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_7 (.input1(s_logisimNet16),
               .input2(s_logisimNet32),
               .result(s_logisimNet39));

   AND_GATE_3_INPUTS #(.BubblesMask(3'b010))
      GATES_8 (.input1(s_logisimNet35),
               .input2(s_logisimBus28[7]),
               .input3(s_logisimNet0),
               .result(s_logisimNet30));

   Multiplexer_bus_2 #(.nrOfBits(8))
      PLEXERS_9 (.enable(1'b1),
                 .muxIn_0(s_logisimBus6[7:0]),
                 .muxIn_1(s_logisimBus9[7:0]),
                 .muxOut(s_logisimBus13[7:0]),
                 .sel(s_logisimNet8));

   Multiplexer_bus_2 #(.nrOfBits(8))
      PLEXERS_10 (.enable(1'b1),
                  .muxIn_0(s_logisimBus20[7:0]),
                  .muxIn_1(s_logisimBus5[7:0]),
                  .muxOut(s_logisimBus33[7:0]),
                  .sel(s_logisimNet8));

   Multiplexer_bus_2 #(.nrOfBits(8))
      PLEXERS_11 (.enable(1'b1),
                  .muxIn_0(s_logisimBus9[7:0]),
                  .muxIn_1(s_logisimBus6[7:0]),
                  .muxOut(s_logisimBus40[7:0]),
                  .sel(s_logisimNet8));

   Multiplexer_bus_2 #(.nrOfBits(8))
      PLEXERS_12 (.enable(1'b1),
                  .muxIn_0(s_logisimBus5[7:0]),
                  .muxIn_1(s_logisimBus20[7:0]),
                  .muxOut(s_logisimBus18[7:0]),
                  .sel(s_logisimNet8));

   Subtractor #(.extendedBits(9),
                .nrOfBits(8))
      ARITH_13 (.borrowIn(1'b0),
                .borrowOut(),
                .dataA(s_logisimBus14[7:0]),
                .dataB(s_logisimBus7[7:0]),
                .result(s_logisimBus28[7:0]));

   S_R_FLIPFLOP #(.invertClockEnable(0))
      MEMORY_14 (.clock(s_logisimNet11),
                 .preset(1'b0),
                 .q(s_logisimNet8),
                 .qBar(s_logisimNet36),
                 .r(s_logisimNet15),
                 .reset(1'b0),
                 .s(s_logisimNet10),
                 .tick(1'b1));

   S_R_FLIPFLOP #(.invertClockEnable(0))
      MEMORY_15 (.clock(s_logisimNet11),
                 .preset(1'b0),
                 .q(s_logisimNet4),
                 .qBar(),
                 .r(s_logisimNet15),
                 .reset(s_logisimNet29),
                 .s(s_logisimNet37),
                 .tick(1'b1));

   REGISTER_FLIP_FLOP #(.invertClock(0),
                        .nrOfBits(1))
      MEMORY_16 (.clock(s_logisimNet11),
                 .clockEnable(s_logisimNet16),
                 .d(s_logisimNet32),
                 .q(s_logisimNet0),
                 .reset(s_logisimNet15),
                 .tick(1'b1));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   Bresenham   Bresenham_1 (.CLKIN(s_logisimNet11),
                            .EQUAL(s_logisimNet10),
                            .INC(s_logisimNet3),
                            .RST(s_logisimNet19),
                            .X(s_logisimBus34[7:0]),
                            .X1(s_logisimBus13[7:0]),
                            .X2(s_logisimBus27[7:0]),
                            .Y(s_logisimBus12[7:0]),
                            .Y1(s_logisimBus33[7:0]),
                            .Y2(s_logisimBus26[7:0]),
                            .YCHANGE(s_logisimNet1),
                            .YEQUAL(s_logisimNet31));

   BRESENY   BRESENY_1 (.CLKIN(s_logisimNet11),
                        .INC(s_logisimNet3),
                        .Output_1(s_logisimNet25),
                        .RST(s_logisimNet19),
                        .X(s_logisimBus21[7:0]),
                        .X1(s_logisimBus13[7:0]),
                        .X2(s_logisimBus40[7:0]),
                        .Y(s_logisimBus22[7:0]),
                        .Y1(s_logisimBus33[7:0]),
                        .Y2(s_logisimBus18[7:0]));

   HORIZONTAL   HORIZONTAL_1 (.CLK(s_logisimNet11),
                              .EQUAL(s_logisimNet2),
                              .Input_bus_1(s_logisimBus12[7:0]),
                              .Input_bus_2(s_logisimBus22[7:0]),
                              .LINE(s_logisimNet38),
                              .RST(s_logisimNet4),
                              .X(s_logisimNet35),
                              .X1(s_logisimBus21[7:0]),
                              .X2(s_logisimBus34[7:0]),
                              .XWRITE(s_logisimNet31),
                              .Y(s_logisimNet16),
                              .YTHENX(s_logisimBus14[7:0]));

endmodule


// ============================================================================
// File: UNA.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : UNA                                                          **
 **                                                                          **
 *****************************************************************************/

module UNA( CLK,
            DATAOUT,
            INPUT,
            OUTSIDECONTROL,
            RST,
            X,
            Y );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       CLK;
   input [7:0] INPUT;
   input       RST;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] DATAOUT;
   output [5:0] OUTSIDECONTROL;
   output       X;
   output       Y;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [6:0]  s_logisimBus0;
   wire [1:0]  s_logisimBus11;
   wire [7:0]  s_logisimBus12;
   wire [3:0]  s_logisimBus14;
   wire [7:0]  s_logisimBus15;
   wire [7:0]  s_logisimBus19;
   wire [7:0]  s_logisimBus20;
   wire [7:0]  s_logisimBus21;
   wire [5:0]  s_logisimBus23;
   wire [7:0]  s_logisimBus26;
   wire [23:0] s_logisimBus27;
   wire [7:0]  s_logisimBus7;
   wire [7:0]  s_logisimBus9;
   wire        s_logisimNet1;
   wire        s_logisimNet10;
   wire        s_logisimNet13;
   wire        s_logisimNet16;
   wire        s_logisimNet17;
   wire        s_logisimNet18;
   wire        s_logisimNet2;
   wire        s_logisimNet22;
   wire        s_logisimNet24;
   wire        s_logisimNet25;
   wire        s_logisimNet28;
   wire        s_logisimNet29;
   wire        s_logisimNet3;
   wire        s_logisimNet30;
   wire        s_logisimNet31;
   wire        s_logisimNet4;
   wire        s_logisimNet5;
   wire        s_logisimNet6;
   wire        s_logisimNet8;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus12[7:0] = INPUT;
   assign s_logisimNet24      = RST;
   assign s_logisimNet3       = CLK;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign DATAOUT        = s_logisimBus26[7:0];
   assign OUTSIDECONTROL = s_logisimBus23[5:0];
   assign X              = s_logisimNet1;
   assign Y              = s_logisimNet10;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   AND_GATE #(.BubblesMask(2'b10))
      GATES_1 (.input1(s_logisimNet3),
               .input2(s_logisimNet22),
               .result(s_logisimNet28));

   AND_GATE #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet3),
               .input2(s_logisimNet8),
               .result(s_logisimNet31));

   Multiplexer_bus_4 #(.nrOfBits(8))
      PLEXERS_3 (.enable(1'b1),
                 .muxIn_0(s_logisimBus21[7:0]),
                 .muxIn_1(s_logisimBus20[7:0]),
                 .muxIn_2(s_logisimBus9[7:0]),
                 .muxIn_3(s_logisimBus12[7:0]),
                 .muxOut(s_logisimBus7[7:0]),
                 .sel(s_logisimBus11[1:0]));

   Multiplexer_bus_2 #(.nrOfBits(8))
      PLEXERS_4 (.enable(1'b1),
                 .muxIn_0(s_logisimBus15[7:0]),
                 .muxIn_1(s_logisimBus7[7:0]),
                 .muxOut(s_logisimBus26[7:0]),
                 .sel(s_logisimNet22));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   CNTRL   CNTRL_1 (.CLK(s_logisimNet31),
                    .CONTROL(s_logisimBus23[5:0]),
                    .DELAY(s_logisimNet18),
                    .FLAGS(s_logisimBus0[6:0]),
                    .GPUDONE(s_logisimNet5),
                    .Input_bus_1(s_logisimBus12[7:0]),
                    .LDX(s_logisimNet30),
                    .LDY(s_logisimNet17),
                    .MATH(s_logisimNet6),
                    .MUX(s_logisimBus11[1:0]),
                    .OPERAND(s_logisimBus19[7:0]),
                    .OUTPUT(s_logisimNet22),
                    .POP(s_logisimNet4),
                    .PUSH(s_logisimNet13),
                    .REGADD(s_logisimBus14[3:0]),
                    .RST(s_logisimNet24),
                    .SAVEA(s_logisimNet25),
                    .SAVEREG(s_logisimNet29),
                    .STARTGPU(s_logisimNet16),
                    .SVB(s_logisimNet2));

   REGISTERS   REGISTERS_1 (.ADDRESS(s_logisimBus14[3:0]),
                            .CLK(s_logisimNet3),
                            .DATA(s_logisimBus7[7:0]),
                            .Output_bus_1(s_logisimBus21[7:0]),
                            .Output_bus_2(s_logisimBus27[23:0]),
                            .WRITE(s_logisimNet29));

   MATH   MATH_1 (.ALU(s_logisimNet6),
                  .ALUOUT(s_logisimBus20[7:0]),
                  .CLK(s_logisimNet3),
                  .CNTRL(s_logisimBus19[7:0]),
                  .DATAIN(s_logisimBus21[7:0]),
                  .FLAGS(s_logisimBus0[6:0]),
                  .RST(s_logisimNet24),
                  .SVA(s_logisimNet25),
                  .SVB(s_logisimNet2));

   STCK   STCK_1 (.CLOCK(s_logisimNet3),
                  .DATA(s_logisimBus7[7:0]),
                  .POP(s_logisimNet4),
                  .PUSH(s_logisimNet13),
                  .RESET(s_logisimNet24),
                  .STACKOUT(s_logisimBus9[7:0]));

   DLY   DLY_1 (.ADDRESS(s_logisimBus27[23:0]),
                .CLK(s_logisimNet3),
                .ENCLK(s_logisimNet8),
                .RST(s_logisimNet24),
                .SET(s_logisimNet18));

   GRAPHICSCARD   GRAPHICSCARD_1 (.CLK(s_logisimNet28),
                                  .COORD(s_logisimBus15[7:0]),
                                  .DATA(s_logisimBus21[7:0]),
                                  .DONE(s_logisimNet5),
                                  .LDX(s_logisimNet30),
                                  .LDY(s_logisimNet17),
                                  .RST(s_logisimNet24),
                                  .START(s_logisimNet16),
                                  .X(s_logisimNet1),
                                  .Y(s_logisimNet10));

endmodule


// ============================================================================
// File: AND_GATE.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : AND_GATE                                                     **
 **                                                                          **
 *****************************************************************************/

module AND_GATE( input1,
                 input2,
                 result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [1:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1&
                   s_realInput2;

endmodule


// ============================================================================
// File: AND_GATE_3_INPUTS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : AND_GATE_3_INPUTS                                            **
 **                                                                          **
 *****************************************************************************/

module AND_GATE_3_INPUTS( input1,
                          input2,
                          input3,
                          result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [2:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;
   input input3;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;
   wire s_realInput3;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;
   assign  s_realInput3 = (BubblesMask[2] == 1'b0) ? input3 : ~input3;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1&
                   s_realInput2&
                   s_realInput3;

endmodule


// ============================================================================
// File: AND_GATE_BUS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : AND_GATE_BUS                                                 **
 **                                                                          **
 *****************************************************************************/

module AND_GATE_BUS( input1,
                     input2,
                     result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter NrOfBits = 1;
   parameter [1:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [NrOfBits-1:0] input1;
   input [NrOfBits-1:0] input2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [NrOfBits-1:0] result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [NrOfBits-1:0] s_realInput1;
   wire [NrOfBits-1:0] s_realInput2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1&
                   s_realInput2;

endmodule


// ============================================================================
// File: NOR_GATE_8_INPUTS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : NOR_GATE_8_INPUTS                                            **
 **                                                                          **
 *****************************************************************************/

module NOR_GATE_8_INPUTS( input1,
                          input2,
                          input3,
                          input4,
                          input5,
                          input6,
                          input7,
                          input8,
                          result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [7:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;
   input input3;
   input input4;
   input input5;
   input input6;
   input input7;
   input input8;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;
   wire s_realInput3;
   wire s_realInput4;
   wire s_realInput5;
   wire s_realInput6;
   wire s_realInput7;
   wire s_realInput8;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;
   assign  s_realInput3 = (BubblesMask[2] == 1'b0) ? input3 : ~input3;
   assign  s_realInput4 = (BubblesMask[3] == 1'b0) ? input4 : ~input4;
   assign  s_realInput5 = (BubblesMask[4] == 1'b0) ? input5 : ~input5;
   assign  s_realInput6 = (BubblesMask[5] == 1'b0) ? input6 : ~input6;
   assign  s_realInput7 = (BubblesMask[6] == 1'b0) ? input7 : ~input7;
   assign  s_realInput8 = (BubblesMask[7] == 1'b0) ? input8 : ~input8;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = ~(s_realInput1|
                     s_realInput2|
                     s_realInput3|
                     s_realInput4|
                     s_realInput5|
                     s_realInput6|
                     s_realInput7|
                     s_realInput8);

endmodule


// ============================================================================
// File: OR_GATE.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : OR_GATE                                                      **
 **                                                                          **
 *****************************************************************************/

module OR_GATE( input1,
                input2,
                result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [1:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1|
                   s_realInput2;

endmodule


// ============================================================================
// File: OR_GATE_3_INPUTS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : OR_GATE_3_INPUTS                                             **
 **                                                                          **
 *****************************************************************************/

module OR_GATE_3_INPUTS( input1,
                         input2,
                         input3,
                         result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [2:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;
   input input3;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;
   wire s_realInput3;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;
   assign  s_realInput3 = (BubblesMask[2] == 1'b0) ? input3 : ~input3;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1|
                   s_realInput2|
                   s_realInput3;

endmodule


// ============================================================================
// File: OR_GATE_8_INPUTS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : OR_GATE_8_INPUTS                                             **
 **                                                                          **
 *****************************************************************************/

module OR_GATE_8_INPUTS( input1,
                         input2,
                         input3,
                         input4,
                         input5,
                         input6,
                         input7,
                         input8,
                         result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [7:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;
   input input3;
   input input4;
   input input5;
   input input6;
   input input7;
   input input8;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;
   wire s_realInput3;
   wire s_realInput4;
   wire s_realInput5;
   wire s_realInput6;
   wire s_realInput7;
   wire s_realInput8;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;
   assign  s_realInput3 = (BubblesMask[2] == 1'b0) ? input3 : ~input3;
   assign  s_realInput4 = (BubblesMask[3] == 1'b0) ? input4 : ~input4;
   assign  s_realInput5 = (BubblesMask[4] == 1'b0) ? input5 : ~input5;
   assign  s_realInput6 = (BubblesMask[5] == 1'b0) ? input6 : ~input6;
   assign  s_realInput7 = (BubblesMask[6] == 1'b0) ? input7 : ~input7;
   assign  s_realInput8 = (BubblesMask[7] == 1'b0) ? input8 : ~input8;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1|
                   s_realInput2|
                   s_realInput3|
                   s_realInput4|
                   s_realInput5|
                   s_realInput6|
                   s_realInput7|
                   s_realInput8;

endmodule


// ============================================================================
// File: OR_GATE_BUS.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : OR_GATE_BUS                                                  **
 **                                                                          **
 *****************************************************************************/

module OR_GATE_BUS( input1,
                    input2,
                    result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter NrOfBits = 1;
   parameter [1:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [NrOfBits-1:0] input1;
   input [NrOfBits-1:0] input2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [NrOfBits-1:0] result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [NrOfBits-1:0] s_realInput1;
   wire [NrOfBits-1:0] s_realInput2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = s_realInput1|
                   s_realInput2;

endmodule


// ============================================================================
// File: PLA_PLA_1.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : PLA_PLA_1                                                    **
 **                                                                          **
 *****************************************************************************/

module PLA_PLA_1( index,
                  result );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [8:0] index;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [19:0] result;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   casez (index)
     9'b?????000?: result = 20'b10000000000000010000;
     9'b0000?1000: result = 20'b01000000000000000000;
     9'b000000101: result = 20'b01000000000000000000;
     9'b000010101: result = 20'b00000010000010111000;
     9'b0000?1101: result = 20'b00000010000010111000;
     9'b0000?0011: result = 20'b00000010000010111000;
     9'b1000?100?: result = 20'b01100000000001110000;
     9'b0100?100?: result = 20'b01010000000000000000;
     9'b1100?100?: result = 20'b01001000000000000000;
     9'b0010?100?: result = 20'b00000000000001000000;
     9'b0010?010?: result = 20'b01100100000001010000;
     9'b1010?100?: result = 20'b01100010000000100000;
     9'b0110?100?: result = 20'b01000001000000000000;
     9'b1110?100?: result = 20'b01000000100000000000;
     9'b0001?100?: result = 20'b01000000010000000000;
     9'b1001?100?: result = 20'b01000000001000000000;
     9'b0101?100?: result = 20'b00000000000100000000;
     9'b0101?010?: result = 20'b00000000000100000000;
     9'b0101?110?: result = 20'b01000000000100000000;
     9'b1101?100?: result = 20'b00000000000000000001;
     9'b1101?010?: result = 20'b00000000000010000100;
     9'b0011?100?: result = 20'b00000000000000000001;
     9'b0011?010?: result = 20'b00100000000001100100;
     9'b1011?100?: result = 20'b00000001000001110000;
     9'b1011?010?: result = 20'b00000001000001110000;
     9'b1011?110?: result = 20'b01000001000001110000;
     9'b0111?100?: result = 20'b00000000000001101000;
     9'b0111?010?: result = 20'b00000001000001101000;
     9'b0111?110?: result = 20'b00000001000001101000;
     9'b1111?100?: result = 20'b00000000000000000010;
     9'b1111?010?: result = 20'b01000000000000000000;
     9'b0000?1011: result = 20'b01000000000010111000;
     9'b0111?001?: result = 20'b01000001000001101000;
     9'b0011?110?: result = 20'b01000000000000010000;
     9'b1101?110?: result = 20'b01000000000000010000;
     9'b0000?1001: result = 20'b00000000000000010001;
     default: result = 20'0;
   endcase

endmodule


// ============================================================================
// File: XOR_GATE_BUS_ONEHOT.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : XOR_GATE_BUS_ONEHOT                                          **
 **                                                                          **
 *****************************************************************************/

module XOR_GATE_BUS_ONEHOT( input1,
                            input2,
                            result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter NrOfBits = 1;
   parameter [1:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [NrOfBits-1:0] input1;
   input [NrOfBits-1:0] input2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [NrOfBits-1:0] result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [NrOfBits-1:0] s_realInput1;
   wire [NrOfBits-1:0] s_realInput2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   genvar n;
   generate
      for (n = 0 ; n < NrOfBits ; n = n + 1)
         begin: bit_gen
         assign result[n] = (s_realInput1[n]&~(s_realInput2[n]))|
                            (~(s_realInput1[n])&s_realInput2[n]);
         end
   endgenerate


endmodule


// ============================================================================
// File: XOR_GATE_ONEHOT.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : XOR_GATE_ONEHOT                                              **
 **                                                                          **
 *****************************************************************************/

module XOR_GATE_ONEHOT( input1,
                        input2,
                        result );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [1:0] BubblesMask = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input input1;
   input input2;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output result;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_realInput1;
   wire s_realInput2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the bubbles are processed                                             **
   *******************************************************************************/
   assign  s_realInput1 = (BubblesMask[0] == 1'b0) ? input1 : ~input1;
   assign  s_realInput2 = (BubblesMask[1] == 1'b0) ? input2 : ~input2;

   /*******************************************************************************
   ** Here the functionality is defined                                          **
   *******************************************************************************/
   assign result = (s_realInput1&~(s_realInput2))|
                   (~(s_realInput1)&s_realInput2);


endmodule


// ============================================================================
// File: LogisimCounter.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : LogisimCounter                                               **
 **                                                                          **
 *****************************************************************************/

module LogisimCounter( clear,
                       clock,
                       compareOut,
                       countValue,
                       enable,
                       load,
                       loadData,
                       tick,
                       upNotDown );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [2:0] maxVal = 1;
   parameter invertClock = 1;
   parameter mode = 1;
   parameter width = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input             clear;
   input             clock;
   input             enable;
   input             load;
   input [width-1:0] loadData;
   input             tick;
   input             upNotDown;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output             compareOut;
   output [width-1:0] countValue;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_clock;
   wire s_realEnable;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg             s_carry;
   reg [width-1:0] s_counterValue;
   reg [width-1:0] s_nextCounterValue;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Functionality of the counter:                                              **
   **   Load Count | mode                                                        **
   **                                                                            **
   ** -----------+-------------------                                            **
   **     0    0   | halt                                                        **
   **     0    1   | count                                                       **
   ** up (default)                                                               **
   **     1    0   | load                                                        **
   **     1    1   | count down                                                  **
   *******************************************************************************/

   assign compareOut = s_carry;
   assign countValue = s_counterValue;
   assign s_clock = (invertClock == 0) ? clock : ~clock;

   always@(*)
   begin
   if (upNotDown)
      s_carry = (s_counterValue == maxVal) ? 1'b1 : 1'b0;
   else
      s_carry = (s_counterValue == 0) ? 1'b1 : 1'b0;
   end

   assign s_realEnable = ((~(load)&~(enable))|
                           ((mode==1)&s_carry&~(load))) ? 1'b0 : tick;

   always @(*)
   begin
      if ((load)|((mode==3)&s_carry))
         s_nextCounterValue = loadData;
      else if ((mode==0)&s_carry&upNotDown)
         s_nextCounterValue = 0;
      else if ((mode==0)&s_carry)
         s_nextCounterValue = maxVal;
      else if (upNotDown)
         s_nextCounterValue = s_counterValue + 1;
      else
         s_nextCounterValue = s_counterValue - 1;
   end

   always @(posedge s_clock or posedge clear)
   begin
      if (clear) s_counterValue <= 0;
      else if (s_realEnable) s_counterValue <= s_nextCounterValue;
   end

endmodule


// ============================================================================
// File: LogisimRNG.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : LogisimRNG                                                   **
 **                                                                          **
 *****************************************************************************/

module LogisimRNG( clear,
                   clock,
                   enable,
                   q,
                   tick );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter [63:0] initialState0 = 1;
   parameter [63:0] initialState1 = 1;
   parameter [63:0] initialState2 = 1;
   parameter [63:0] initialState3 = 1;
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input clear;
   input clock;
   input enable;
   input tick;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] q;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [63:0] s_nextState0;
   wire [63:0] s_nextState1;
   wire [63:0] s_nextState2;
   wire [63:0] s_nextState3;
   wire [63:0] s_result;
   wire [63:0] s_rotatedSum;
   wire [63:0] s_shiftedState1;
   wire [63:0] s_state3XorState1;
   wire [63:0] s_sum;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg [2:0]  s_resetReg;
   reg [63:0] s_state0;
   reg [63:0] s_state1;
   reg [63:0] s_state2;
   reg [63:0] s_state3;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   /*******************************************************************************
   ** This is an implementation of the xoshiro256++ algorithm                    **
   *******************************************************************************/

   assign q                 = s_result;
   assign s_sum             = s_state0 + s_state3;
   assign s_rotatedSum      = {s_sum[40:0], s_sum[63:41]};
   assign s_result          = s_rotatedSum + s_state0;
   assign s_shiftedState1   = {s_state1[46:0], 17'b0};
   assign s_state3XorState1 = s_state3 ^ s_state1;
   assign s_nextState0      = s_state0 ^ s_state3XorState1;
   assign s_nextState1      = s_state1 ^ s_state2 ^ s_state0;
   assign s_nextState2      = s_state2 ^ s_state0 ^ s_shiftedState1;
   assign s_nextState3      = {s_state3XorState1[18:0], s_state3XorState1[63:19]};

   always @(posedge clock)
   begin
      case (s_resetReg)
         3'b010:
            if (clear)
            begin
               s_state0   <= initialState0;
               s_state1   <= initialState1;
               s_state2   <= initialState2;
               s_state3   <= initialState3;
               s_resetReg <= 3'b001;
            end
            else if (tick && enable)
            begin
               s_state0 <= s_nextState0;
               s_state1 <= s_nextState1;
               s_state2 <= s_nextState2;
               s_state3 <= s_nextState3;
            end
         3'b001:
            begin
               s_state0   <= initialState0;
               s_state1   <= initialState1;
               s_state2   <= initialState2;
               s_state3   <= initialState3;
               s_resetReg <= 3'b101;
            end
         3'b101:
            begin
               s_state0   <= initialState0;
               s_state1   <= initialState1;
               s_state2   <= initialState2;
               s_state3   <= initialState3;
               s_resetReg <= clear ? 3'b001 : 3'b010;
            end
         default:
            begin
               s_state0   <= initialState0;
               s_state1   <= initialState1;
               s_state2   <= initialState2;
               s_state3   <= initialState3;
               s_resetReg <= 3'b001;
            end
      endcase
   end

endmodule


// ============================================================================
// File: RAMCONTENTS_RAM_1.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : RAMCONTENTS_RAM_1                                            **
 **                                                                          **
 *****************************************************************************/

module RAMCONTENTS_RAM_1( address,
                          clock,
                          data0In,
                          data0Out,
                          data1In,
                          data1Out,
                          data2In,
                          data2Out,
                          data3In,
                          data3Out,
                          lineEnable0In,
                          lineEnable1In,
                          lineEnable2In,
                          lineEnable3In,
                          tick,
                          we );

   /*******************************************************************************
   ** Here all private types are defined                                         **
   *******************************************************************************/
      reg [7:0] s_memContents [16:0];

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [3:0] address;
   input       clock;
   input [7:0] data0In;
   input [7:0] data1In;
   input [7:0] data2In;
   input [7:0] data3In;
   input       lineEnable0In;
   input       lineEnable1In;
   input       lineEnable2In;
   input       lineEnable3In;
   input       tick;
   input       we;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] data0Out;
   output [7:0] data1Out;
   output [7:0] data2Out;
   output [7:0] data3Out;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [3:0] s_ramReadAddress;
   wire       s_ramWe;
   wire [3:0] s_ramWriteAddress;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg [4:0] s_addressOffsetReg;
   reg [7:0] s_dataIn0Reg;
   reg [7:0] s_dataIn1Reg;
   reg [7:0] s_dataIn2Reg;
   reg [7:0] s_dataIn3Reg;
   reg [7:0] s_dataOut0Reg;
   reg [7:0] s_dataOut1Reg;
   reg [7:0] s_dataOut2Reg;
   reg [7:0] s_dataOut3Reg;
   reg       s_lineEnable0Reg;
   reg       s_lineEnable1Reg;
   reg       s_lineEnable2Reg;
   reg       s_lineEnable3Reg;
   reg [7:0] s_ramDataIn;
   reg [7:0] s_ramDataOut;
   reg [3:0] s_readAddressReg;
   reg [4:0] s_tickDelayReg;
   reg       s_weReg;
   reg [3:0] s_writeAddressReg;

   /*******************************************************************************
   ** The type defined signals are defined here                                  **
   *******************************************************************************/
   

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** The synchronous semi-dual-ported memory is defined here                    **
   *******************************************************************************/
   assign s_ramWriteAddress = s_writeAddressReg + s_addressOffsetReg[3:0];
   assign s_ramReadAddress = s_readAddressReg + s_addressOffsetReg[3:0];

   always @(posedge clock)
     if (s_ramWe == 1'b1) s_memContents[s_ramWriteAddress] <= s_ramDataIn;

   always @(negedge clock)
     s_ramDataOut <= s_memContents[s_ramReadAddress];

   /*******************************************************************************
   ** The input registers are defined here                                       **
   *******************************************************************************/
   always @(posedge clock)
     begin
       if (s_tickDelayReg[0] == 1'b1)
         s_readAddressReg <= address;
       if (tick == 1'b1)
         begin
           s_writeAddressReg     <= address;
           s_weReg               <= we;
           s_dataIn0Reg     <= data0In;
           s_lineEnable0Reg <= lineEnable0In;
           s_dataIn1Reg     <= data1In;
           s_lineEnable1Reg <= lineEnable1In;
           s_dataIn2Reg     <= data2In;
           s_lineEnable2Reg <= lineEnable2In;
           s_dataIn3Reg     <= data3In;
           s_lineEnable3Reg <= lineEnable3In;
         end
       end

   /*******************************************************************************
   ** The FSM's are defined here                                                 **
   *******************************************************************************/
   always @(posedge clock)
     begin
       s_tickDelayReg[0] <= tick;
       s_tickDelayReg[4:1] <= s_tickDelayReg[3:0];
       s_addressOffsetReg <= (s_tickDelayReg[0] == 1'b1) ? 5'd0 :
                             s_addressOffsetReg != 5'd4 ? s_addressOffsetReg + 5'd1 :
                             s_addressOffsetReg;
     end

   /*******************************************************************************
   ** Here the RamDatIn is defined                                               **
   *******************************************************************************/
   always @*
     case (s_addressOffsetReg)
       5'd3    : s_ramDataIn <= s_dataIn3Reg;
       5'd2    : s_ramDataIn <= s_dataIn2Reg;
       5'd1    : s_ramDataIn <= s_dataIn1Reg;
       default : s_ramDataIn <= s_dataIn0Reg;
     endcase;

   /*******************************************************************************
   ** Here the RamDatout is defined                                              **
   *******************************************************************************/
   assign data0Out = s_dataOut0Reg;
   assign data1Out = s_dataOut1Reg;
   assign data2Out = s_dataOut2Reg;
   assign data3Out = s_dataOut3Reg;

   always @(posedge clock)
     begin
       s_dataOut0Reg <= (s_tickDelayReg[1] == 1'b1) ? s_ramDataOut : s_dataOut0Reg;
       s_dataOut1Reg <= (s_tickDelayReg[2] == 1'b1) ? s_ramDataOut : s_dataOut1Reg;
       s_dataOut2Reg <= (s_tickDelayReg[3] == 1'b1) ? s_ramDataOut : s_dataOut2Reg;
       s_dataOut3Reg <= (s_tickDelayReg[4] == 1'b1) ? s_ramDataOut : s_dataOut3Reg;
     end

   /*******************************************************************************
   ** Here the Ram write enable is defined                                       **
   *******************************************************************************/
   assign s_ramWe = s_weReg & (
                    (s_lineEnable0Reg & s_tickDelayReg[1])|
                    (s_lineEnable1Reg & s_tickDelayReg[2])|
                    (s_lineEnable2Reg & s_tickDelayReg[3])|
                    (s_lineEnable3Reg & s_tickDelayReg[4]));

endmodule


// ============================================================================
// File: REGISTER_FLIP_FLOP.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : REGISTER_FLIP_FLOP                                           **
 **                                                                          **
 *****************************************************************************/

module REGISTER_FLIP_FLOP( clock,
                           clockEnable,
                           d,
                           q,
                           reset,
                           tick );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter invertClock = 1;
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input                clock;
   input                clockEnable;
   input [nrOfBits-1:0] d;
   input                reset;
   input                tick;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] q;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_clock;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg [nrOfBits-1:0] s_currentState;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   assign q = s_currentState;
   assign s_clock = invertClock == 0 ? clock : ~clock;

   always @(posedge s_clock or posedge reset)
   begin
      if (reset) s_currentState <= 0;
      else if (clockEnable&tick) s_currentState <= d;
   end

endmodule


// ============================================================================
// File: SHIFTREG_18_Classic.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : SHIFTREG_18_Classic                                          **
 **                                                                          **
 *****************************************************************************/

module SHIFTREG_18_Classic( D0,
                            D1,
                            D10,
                            D11,
                            D12,
                            D13,
                            D14,
                            D15,
                            D16,
                            D17,
                            D2,
                            D3,
                            D4,
                            D5,
                            D6,
                            D7,
                            D8,
                            D9,
                            Q0,
                            Q1,
                            Q10,
                            Q11,
                            Q12,
                            Q13,
                            Q14,
                            Q15,
                            Q16,
                            Q17,
                            Q2,
                            Q3,
                            Q4,
                            Q5,
                            Q6,
                            Q7,
                            Q8,
                            Q9,
                            clock,
                            parLoad,
                            reset,
                            shiftEnable,
                            shiftIn,
                            shiftOut,
                            tick );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter negateClock = 1;
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [nrOfBits-1:0] D0;
   input [nrOfBits-1:0] D1;
   input [nrOfBits-1:0] D10;
   input [nrOfBits-1:0] D11;
   input [nrOfBits-1:0] D12;
   input [nrOfBits-1:0] D13;
   input [nrOfBits-1:0] D14;
   input [nrOfBits-1:0] D15;
   input [nrOfBits-1:0] D16;
   input [nrOfBits-1:0] D17;
   input [nrOfBits-1:0] D2;
   input [nrOfBits-1:0] D3;
   input [nrOfBits-1:0] D4;
   input [nrOfBits-1:0] D5;
   input [nrOfBits-1:0] D6;
   input [nrOfBits-1:0] D7;
   input [nrOfBits-1:0] D8;
   input [nrOfBits-1:0] D9;
   input                clock;
   input                parLoad;
   input                reset;
   input                shiftEnable;
   input [nrOfBits-1:0] shiftIn;
   input                tick;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] Q0;
   output [nrOfBits-1:0] Q1;
   output [nrOfBits-1:0] Q10;
   output [nrOfBits-1:0] Q11;
   output [nrOfBits-1:0] Q12;
   output [nrOfBits-1:0] Q13;
   output [nrOfBits-1:0] Q14;
   output [nrOfBits-1:0] Q15;
   output [nrOfBits-1:0] Q16;
   output [nrOfBits-1:0] Q17;
   output [nrOfBits-1:0] Q2;
   output [nrOfBits-1:0] Q3;
   output [nrOfBits-1:0] Q4;
   output [nrOfBits-1:0] Q5;
   output [nrOfBits-1:0] Q6;
   output [nrOfBits-1:0] Q7;
   output [nrOfBits-1:0] Q8;
   output [nrOfBits-1:0] Q9;
   output [nrOfBits-1:0] shiftOut;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire                s_clock;
   wire [nrOfBits-1:0] s_stageNext0;
   wire [nrOfBits-1:0] s_stageNext1;
   wire [nrOfBits-1:0] s_stageNext10;
   wire [nrOfBits-1:0] s_stageNext11;
   wire [nrOfBits-1:0] s_stageNext12;
   wire [nrOfBits-1:0] s_stageNext13;
   wire [nrOfBits-1:0] s_stageNext14;
   wire [nrOfBits-1:0] s_stageNext15;
   wire [nrOfBits-1:0] s_stageNext16;
   wire [nrOfBits-1:0] s_stageNext17;
   wire [nrOfBits-1:0] s_stageNext2;
   wire [nrOfBits-1:0] s_stageNext3;
   wire [nrOfBits-1:0] s_stageNext4;
   wire [nrOfBits-1:0] s_stageNext5;
   wire [nrOfBits-1:0] s_stageNext6;
   wire [nrOfBits-1:0] s_stageNext7;
   wire [nrOfBits-1:0] s_stageNext8;
   wire [nrOfBits-1:0] s_stageNext9;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg [nrOfBits-1:0] s_stageReg0;
   reg [nrOfBits-1:0] s_stageReg1;
   reg [nrOfBits-1:0] s_stageReg10;
   reg [nrOfBits-1:0] s_stageReg11;
   reg [nrOfBits-1:0] s_stageReg12;
   reg [nrOfBits-1:0] s_stageReg13;
   reg [nrOfBits-1:0] s_stageReg14;
   reg [nrOfBits-1:0] s_stageReg15;
   reg [nrOfBits-1:0] s_stageReg16;
   reg [nrOfBits-1:0] s_stageReg17;
   reg [nrOfBits-1:0] s_stageReg2;
   reg [nrOfBits-1:0] s_stageReg3;
   reg [nrOfBits-1:0] s_stageReg4;
   reg [nrOfBits-1:0] s_stageReg5;
   reg [nrOfBits-1:0] s_stageReg6;
   reg [nrOfBits-1:0] s_stageReg7;
   reg [nrOfBits-1:0] s_stageReg8;
   reg [nrOfBits-1:0] s_stageReg9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the outputs are mapped                                                **
   *******************************************************************************/
   assign shiftOut = s_stageReg17;
   assign Q0 = s_stageReg0;
   assign Q1 = s_stageReg1;
   assign Q2 = s_stageReg2;
   assign Q3 = s_stageReg3;
   assign Q4 = s_stageReg4;
   assign Q5 = s_stageReg5;
   assign Q6 = s_stageReg6;
   assign Q7 = s_stageReg7;
   assign Q8 = s_stageReg8;
   assign Q9 = s_stageReg9;
   assign Q10 = s_stageReg10;
   assign Q11 = s_stageReg11;
   assign Q12 = s_stageReg12;
   assign Q13 = s_stageReg13;
   assign Q14 = s_stageReg14;
   assign Q15 = s_stageReg15;
   assign Q16 = s_stageReg16;
   assign Q17 = s_stageReg17;

   /*******************************************************************************
   ** Here the next state is defined                                             **
   *******************************************************************************/
   assign s_stageNext0 = (parLoad == 1'b1) ? D0 : (shiftEnable == 1'b1) ? shiftIn : s_stageReg0;
   assign s_stageNext1 = (parLoad == 1'b1) ? D1 : (shiftEnable == 1'b1) ? s_stageReg0 : s_stageReg1;
   assign s_stageNext2 = (parLoad == 1'b1) ? D2 : (shiftEnable == 1'b1) ? s_stageReg1 : s_stageReg2;
   assign s_stageNext3 = (parLoad == 1'b1) ? D3 : (shiftEnable == 1'b1) ? s_stageReg2 : s_stageReg3;
   assign s_stageNext4 = (parLoad == 1'b1) ? D4 : (shiftEnable == 1'b1) ? s_stageReg3 : s_stageReg4;
   assign s_stageNext5 = (parLoad == 1'b1) ? D5 : (shiftEnable == 1'b1) ? s_stageReg4 : s_stageReg5;
   assign s_stageNext6 = (parLoad == 1'b1) ? D6 : (shiftEnable == 1'b1) ? s_stageReg5 : s_stageReg6;
   assign s_stageNext7 = (parLoad == 1'b1) ? D7 : (shiftEnable == 1'b1) ? s_stageReg6 : s_stageReg7;
   assign s_stageNext8 = (parLoad == 1'b1) ? D8 : (shiftEnable == 1'b1) ? s_stageReg7 : s_stageReg8;
   assign s_stageNext9 = (parLoad == 1'b1) ? D9 : (shiftEnable == 1'b1) ? s_stageReg8 : s_stageReg9;
   assign s_stageNext10 = (parLoad == 1'b1) ? D10 : (shiftEnable == 1'b1) ? s_stageReg9 : s_stageReg10;
   assign s_stageNext11 = (parLoad == 1'b1) ? D11 : (shiftEnable == 1'b1) ? s_stageReg10 : s_stageReg11;
   assign s_stageNext12 = (parLoad == 1'b1) ? D12 : (shiftEnable == 1'b1) ? s_stageReg11 : s_stageReg12;
   assign s_stageNext13 = (parLoad == 1'b1) ? D13 : (shiftEnable == 1'b1) ? s_stageReg12 : s_stageReg13;
   assign s_stageNext14 = (parLoad == 1'b1) ? D14 : (shiftEnable == 1'b1) ? s_stageReg13 : s_stageReg14;
   assign s_stageNext15 = (parLoad == 1'b1) ? D15 : (shiftEnable == 1'b1) ? s_stageReg14 : s_stageReg15;
   assign s_stageNext16 = (parLoad == 1'b1) ? D16 : (shiftEnable == 1'b1) ? s_stageReg15 : s_stageReg16;
   assign s_stageNext17 = (parLoad == 1'b1) ? D17 : (shiftEnable == 1'b1) ? s_stageReg16 : s_stageReg17;

   /*******************************************************************************
   ** Here the state registers are defined                                       **
   *******************************************************************************/
   assign s_clock = (negateClock == 0) ? clock : ~clock;

   always @(posedge s_clock or posedge reset)
     begin
         s_stageReg0 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext0 : s_stageReg0;
         s_stageReg1 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext1 : s_stageReg1;
         s_stageReg2 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext2 : s_stageReg2;
         s_stageReg3 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext3 : s_stageReg3;
         s_stageReg4 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext4 : s_stageReg4;
         s_stageReg5 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext5 : s_stageReg5;
         s_stageReg6 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext6 : s_stageReg6;
         s_stageReg7 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext7 : s_stageReg7;
         s_stageReg8 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext8 : s_stageReg8;
         s_stageReg9 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext9 : s_stageReg9;
         s_stageReg10 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext10 : s_stageReg10;
         s_stageReg11 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext11 : s_stageReg11;
         s_stageReg12 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext12 : s_stageReg12;
         s_stageReg13 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext13 : s_stageReg13;
         s_stageReg14 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext14 : s_stageReg14;
         s_stageReg15 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext15 : s_stageReg15;
         s_stageReg16 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext16 : s_stageReg16;
         s_stageReg17 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext17 : s_stageReg17;
     end

endmodule


// ============================================================================
// File: SHIFTREG_3_Classic.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : SHIFTREG_3_Classic                                           **
 **                                                                          **
 *****************************************************************************/

module SHIFTREG_3_Classic( D0,
                           D1,
                           D2,
                           Q0,
                           Q1,
                           Q2,
                           clock,
                           parLoad,
                           reset,
                           shiftEnable,
                           shiftIn,
                           shiftOut,
                           tick );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter negateClock = 1;
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [nrOfBits-1:0] D0;
   input [nrOfBits-1:0] D1;
   input [nrOfBits-1:0] D2;
   input                clock;
   input                parLoad;
   input                reset;
   input                shiftEnable;
   input [nrOfBits-1:0] shiftIn;
   input                tick;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] Q0;
   output [nrOfBits-1:0] Q1;
   output [nrOfBits-1:0] Q2;
   output [nrOfBits-1:0] shiftOut;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire                s_clock;
   wire [nrOfBits-1:0] s_stageNext0;
   wire [nrOfBits-1:0] s_stageNext1;
   wire [nrOfBits-1:0] s_stageNext2;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg [nrOfBits-1:0] s_stageReg0;
   reg [nrOfBits-1:0] s_stageReg1;
   reg [nrOfBits-1:0] s_stageReg2;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the outputs are mapped                                                **
   *******************************************************************************/
   assign shiftOut = s_stageReg2;
   assign Q0 = s_stageReg0;
   assign Q1 = s_stageReg1;
   assign Q2 = s_stageReg2;

   /*******************************************************************************
   ** Here the next state is defined                                             **
   *******************************************************************************/
   assign s_stageNext0 = (parLoad == 1'b1) ? D0 : (shiftEnable == 1'b1) ? shiftIn : s_stageReg0;
   assign s_stageNext1 = (parLoad == 1'b1) ? D1 : (shiftEnable == 1'b1) ? s_stageReg0 : s_stageReg1;
   assign s_stageNext2 = (parLoad == 1'b1) ? D2 : (shiftEnable == 1'b1) ? s_stageReg1 : s_stageReg2;

   /*******************************************************************************
   ** Here the state registers are defined                                       **
   *******************************************************************************/
   assign s_clock = (negateClock == 0) ? clock : ~clock;

   always @(posedge s_clock or posedge reset)
     begin
         s_stageReg0 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext0 : s_stageReg0;
         s_stageReg1 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext1 : s_stageReg1;
         s_stageReg2 <= (reset == 1'b1) ? 0 : (tick == 1'b1) ? s_stageNext2 : s_stageReg2;
     end

endmodule


// ============================================================================
// File: S_R_FLIPFLOP.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : S_R_FLIPFLOP                                                 **
 **                                                                          **
 *****************************************************************************/

module S_R_FLIPFLOP( clock,
                     preset,
                     q,
                     qBar,
                     r,
                     reset,
                     s,
                     tick );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter invertClockEnable = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input clock;
   input preset;
   input r;
   input reset;
   input s;
   input tick;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output q;
   output qBar;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_clock;
   wire s_nextState;

   /*******************************************************************************
   ** The registers are defined here                                             **
   *******************************************************************************/
   reg s_currentState;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here the output signals are defined                                        **
   *******************************************************************************/
   assign q        = s_currentState;
   assign qBar     = ~(s_currentState);
   assign s_clock  = (invertClockEnable == 0) ? clock : ~clock;

   /*******************************************************************************
   ** Here the initial register value is defined; for simulation only            **
   *******************************************************************************/
   initial
   begin
      s_currentState = 0;
   end

   /*******************************************************************************
   ** Here the update logic is defined                                           **
   *******************************************************************************/
   assign  s_nextState = (s_currentState&s)|(~(r)&s)|(s_currentState&~(r));

   /*******************************************************************************
   ** Here the actual state register is defined                                  **
   *******************************************************************************/
   always @(posedge s_clock)
   begin
      if (reset) s_currentState <= 1'b0;
      else if (preset) s_currentState <= 1'b1;
      else if (tick) s_currentState <= s_nextState;
   end

endmodule


// ============================================================================
// File: Decoder_4.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Decoder_4                                                    **
 **                                                                          **
 *****************************************************************************/

module Decoder_4( decoderOut_0,
                  decoderOut_1,
                  decoderOut_2,
                  decoderOut_3,
                  enable,
                  sel );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       enable;
   input [1:0] sel;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output decoderOut_0;
   output decoderOut_1;
   output decoderOut_2;
   output decoderOut_3;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   assign decoderOut_0  = (enable&(sel == 2'b00)) ? 1'b1 : 1'b0;
   assign decoderOut_1  = (enable&(sel == 2'b01)) ? 1'b1 : 1'b0;
   assign decoderOut_2  = (enable&(sel == 2'b10)) ? 1'b1 : 1'b0;
   assign decoderOut_3  = (enable&(sel == 2'b11)) ? 1'b1 : 1'b0;
endmodule


// ============================================================================
// File: Decoder_8.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Decoder_8                                                    **
 **                                                                          **
 *****************************************************************************/

module Decoder_8( decoderOut_0,
                  decoderOut_1,
                  decoderOut_2,
                  decoderOut_3,
                  decoderOut_4,
                  decoderOut_5,
                  decoderOut_6,
                  decoderOut_7,
                  enable,
                  sel );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input       enable;
   input [2:0] sel;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output decoderOut_0;
   output decoderOut_1;
   output decoderOut_2;
   output decoderOut_3;
   output decoderOut_4;
   output decoderOut_5;
   output decoderOut_6;
   output decoderOut_7;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   assign decoderOut_0  = (enable&(sel == 3'b000)) ? 1'b1 : 1'b0;
   assign decoderOut_1  = (enable&(sel == 3'b001)) ? 1'b1 : 1'b0;
   assign decoderOut_2  = (enable&(sel == 3'b010)) ? 1'b1 : 1'b0;
   assign decoderOut_3  = (enable&(sel == 3'b011)) ? 1'b1 : 1'b0;
   assign decoderOut_4  = (enable&(sel == 3'b100)) ? 1'b1 : 1'b0;
   assign decoderOut_5  = (enable&(sel == 3'b101)) ? 1'b1 : 1'b0;
   assign decoderOut_6  = (enable&(sel == 3'b110)) ? 1'b1 : 1'b0;
   assign decoderOut_7  = (enable&(sel == 3'b111)) ? 1'b1 : 1'b0;
endmodule


// ============================================================================
// File: Multiplexer_bus_16.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Multiplexer_bus_16                                           **
 **                                                                          **
 *****************************************************************************/

module Multiplexer_bus_16( enable,
                           muxIn_0,
                           muxIn_1,
                           muxIn_10,
                           muxIn_11,
                           muxIn_12,
                           muxIn_13,
                           muxIn_14,
                           muxIn_15,
                           muxIn_2,
                           muxIn_3,
                           muxIn_4,
                           muxIn_5,
                           muxIn_6,
                           muxIn_7,
                           muxIn_8,
                           muxIn_9,
                           muxOut,
                           sel );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input                enable;
   input [nrOfBits-1:0] muxIn_0;
   input [nrOfBits-1:0] muxIn_1;
   input [nrOfBits-1:0] muxIn_10;
   input [nrOfBits-1:0] muxIn_11;
   input [nrOfBits-1:0] muxIn_12;
   input [nrOfBits-1:0] muxIn_13;
   input [nrOfBits-1:0] muxIn_14;
   input [nrOfBits-1:0] muxIn_15;
   input [nrOfBits-1:0] muxIn_2;
   input [nrOfBits-1:0] muxIn_3;
   input [nrOfBits-1:0] muxIn_4;
   input [nrOfBits-1:0] muxIn_5;
   input [nrOfBits-1:0] muxIn_6;
   input [nrOfBits-1:0] muxIn_7;
   input [nrOfBits-1:0] muxIn_8;
   input [nrOfBits-1:0] muxIn_9;
   input [3:0]          sel;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] muxOut;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   reg [nrOfBits:0] s_selected_vector;
   assign muxOut = s_selected_vector;

   always @(*)
   begin
      if (~enable) s_selected_vector <= 0;
      else case (sel)
         4'h0:
            s_selected_vector <= muxIn_0;
         4'h1:
            s_selected_vector <= muxIn_1;
         4'h2:
            s_selected_vector <= muxIn_2;
         4'h3:
            s_selected_vector <= muxIn_3;
         4'h4:
            s_selected_vector <= muxIn_4;
         4'h5:
            s_selected_vector <= muxIn_5;
         4'h6:
            s_selected_vector <= muxIn_6;
         4'h7:
            s_selected_vector <= muxIn_7;
         4'h8:
            s_selected_vector <= muxIn_8;
         4'h9:
            s_selected_vector <= muxIn_9;
         4'hA:
            s_selected_vector <= muxIn_10;
         4'hB:
            s_selected_vector <= muxIn_11;
         4'hC:
            s_selected_vector <= muxIn_12;
         4'hD:
            s_selected_vector <= muxIn_13;
         4'hE:
            s_selected_vector <= muxIn_14;
        default:
           s_selected_vector <= muxIn_15;
      endcase
   end

endmodule


// ============================================================================
// File: Multiplexer_bus_2.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Multiplexer_bus_2                                            **
 **                                                                          **
 *****************************************************************************/

module Multiplexer_bus_2( enable,
                          muxIn_0,
                          muxIn_1,
                          muxOut,
                          sel );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input                enable;
   input [nrOfBits-1:0] muxIn_0;
   input [nrOfBits-1:0] muxIn_1;
   input                sel;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] muxOut;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   reg [nrOfBits:0] s_selected_vector;
   assign muxOut = s_selected_vector;

   always @(*)
   begin
      if (~enable) s_selected_vector <= 0;
      else case (sel)
         1'b0:
            s_selected_vector <= muxIn_0;
        default:
           s_selected_vector <= muxIn_1;
      endcase
   end

endmodule


// ============================================================================
// File: Multiplexer_bus_4.v
// ============================================================================
/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Multiplexer_bus_4                                            **
 **                                                                          **
 *****************************************************************************/

module Multiplexer_bus_4( enable,
                          muxIn_0,
                          muxIn_1,
                          muxIn_2,
                          muxIn_3,
                          muxOut,
                          sel );

   /*******************************************************************************
   ** Here all module parameters are defined with a dummy value                  **
   *******************************************************************************/
   parameter nrOfBits = 1;

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input                enable;
   input [nrOfBits-1:0] muxIn_0;
   input [nrOfBits-1:0] muxIn_1;
   input [nrOfBits-1:0] muxIn_2;
   input [nrOfBits-1:0] muxIn_3;
   input [1:0]          sel;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [nrOfBits-1:0] muxOut;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   reg [nrOfBits:0] s_selected_vector;
   assign muxOut = s_selected_vector;

   always @(*)
   begin
      if (~enable) s_selected_vector <= 0;
      else case (sel)
         2'b00:
            s_selected_vector <= muxIn_0;
         2'b01:
            s_selected_vector <= muxIn_1;
         2'b10:
            s_selected_vector <= muxIn_2;
        default:
           s_selected_vector <= muxIn_3;
      endcase
   end

endmodule


