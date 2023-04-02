module datapath_me #
(
    parameter MACRO_DIM  = 16,
    parameter SEARCH_DIM = 48
) 
(
    input  logic        rst_n,
    input  logic        clk,
    input  logic        en_spr,
    input  logic        en_cpr,
    input  logic        valid,
    input  logic [1:0]  sel,
    input  logic [7:0]  pixel_spr_in       [0:MACRO_DIM-1],
    input  logic [7:0]  pixel_cpr_in       [0:MACRO_DIM-1],
    input  logic [7:0]  pixel_spr_right_in [0:MACRO_DIM-1],
    output logic [15:0] min_sad
);

    logic [8*(MACRO_DIM**2)-1:0] wire_ad;
    logic [15:0]                 wire_sad;

    pe_matrix ins_pe_matrix 
    (
        .rst_n              ( rst_n              ),
        .clk                ( clk                ),
        .sel                ( sel                ),
        .en_spr             ( en_spr             ),
        .en_cpr             ( en_cpr             ),
        .pixel_spr_in       ( pixel_spr_in       ),
        .pixel_cpr_in       ( pixel_cpr_in       ),
        .pixel_spr_right_in ( pixel_spr_right_in ),
        .ad                 ( wire_ad            )
    );

    sum ins_sum
    (
        .rst_n ( rst_n    ),
        .clk   ( clk      ),
        .ad    ( wire_ad  ),
        .sum   ( wire_sad )
    );
    
    comparator ins_comparator
    (
        .clk     ( clk      ),
        .rst_n   ( rst_n    ),
        .valid   ( valid    ),
        .sad     ( wire_sad ),
        .min_sad ( min_sad  )
    );

endmodule