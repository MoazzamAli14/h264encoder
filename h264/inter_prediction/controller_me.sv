module controller_me
#
(
    parameter MACRO_DIM  = 16,
    parameter SEARCH_DIM = 48
) 
(
    input logic rst_n, clk, start,
    output logic sel, en_cpr, en_spr, valid
);

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    logic       en_count;
    logic [4:0] count;

    logic [1:0] state;
    logic [1:0] next_state;

    assign sel = 0;

    //State Machine

    always_ff@(posedge clk or negedge rst_n) 
    begin
        if(~rst_n)
        begin
            state <= S0;
        end
        else
        begin
            state <= next_state;
        end
    end

    always_comb 
    begin
        next_state = S0;
        case(state)
            S0: 
            begin
                if(start)
                begin
                    next_state = S1;
                end
                else
                begin
                    next_state = S0;
                end
            end
            S1: 
            begin
                if(count == MACRO_DIM + 4)     // 16 cycles for shifts and 4 cycles for adder tree pipeline i.e., 20 cycles = 16 cycles + 4 cycles
                begin
                    next_state = S2;
                end
                else
                begin
                    next_state = S1;
                end
            end
            S2:
            begin
                next_state = S0;
            end
        endcase
    end

    always_comb 
    begin
        case(state)
            S0:
            begin
                en_count = 0;
                en_cpr   = 0;
                en_spr   = 0;
                valid    = 0;
            end
            S1:
            begin
                en_count = 1;
                en_cpr   = 1;
                en_spr   = 1;
                valid    = 0;
            end
            S2: 
            begin 
                en_count = 0;
                en_cpr   = 0;
                en_spr   = 0;
                valid    = 1;
            end
        endcase
    end

    // Counter

    always_ff@(posedge clk or negedge rst_n)
    begin
        if(~rst_n | ~en_count)
        begin
            count <= 0;
        end
        else if(en_count)
        begin
            count <= count + 1;
        end
    end

endmodule