// -----------------------------------------------------------------------------
// Name : baseerat_mux.v
// Purpose : General Purpose Mux
//
// -----------------------------------------------------------------------------
// Note    : This file uses Verilog-2001.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Module declaration
// -----------------------------------------------------------------------------
module baseerat_mux
(
  //----------------------------------------------------------------------------
  // Clock, Clock Enables and Reset.
  //----------------------------------------------------------------------------
  clk,
  resetn,

  //----------------------------------------------------------------------------
  // Mux Interface
  //----------------------------------------------------------------------------
  din0,
  din1,
  sel,

  dout

); // baseerat_mux


//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------
parameter DATA_WIDTH = 160; //Works with multiple of 16
parameter REG_OUT = 1;

localparam  SECTION_WIDTH = 16;
localparam  SECTIONS = DATA_WIDTH/SECTION_WIDTH;

// -----------------------------------------------------------------------------
// Signal definitions
// -----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Clock, Clock Enable and Reset
  //----------------------------------------------------------------------------
  input   wire                          clk;
  input   wire                          resetn;

  //----------------------------------------------------------------------------
  // Mux Interface
  //----------------------------------------------------------------------------
  //Inputs
  input                [DATA_WIDTH-1:0] din0;
  input                [DATA_WIDTH-1:0] din1;
  input                                 sel;
  //Outputs
  output               [DATA_WIDTH-1:0] dout;

  //----------------------------------------------------------------------------
  // Internal Signals
  //----------------------------------------------------------------------------
  
  // ---------------------------------------------------------------------------
  // Main code
  // ---------------------------------------------------------------------------
    generate
      genvar  g;

      for (g = 0; g < SECTIONS; g = g + 1)
      begin : g_mux
          wire [SECTION_WIDTH-1:0] d_nxt;

          assign d_nxt = sel   ? din0[(g*SECTION_WIDTH) +: SECTION_WIDTH]
                               : din1[(g*SECTION_WIDTH) +: SECTION_WIDTH];

         if(REG_OUT == 1)
         begin : g_reg_out
         
           reg  [SECTION_WIDTH-1:0] d_reg;
           always @(posedge clk)
           begin : p_dout_reg
               d_reg <= d_nxt;
           end
           assign dout[(g*SECTION_WIDTH) +: SECTION_WIDTH] = d_reg;
           
         end
         else
         begin: g_comb_out
           assign dout[(g*SECTION_WIDTH) +: SECTION_WIDTH] = d_nxt;
         end

      end
    endgenerate

endmodule // baseerat_mux

// -----------------------------------------------------------------------------
// End of File
// -----------------------------------------------------------------------------
