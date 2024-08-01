module h264intra4x4_controller
(
    input logic CLK,
    input logic READYO,
    input logic readyod,
    input logic FBSTROBE,
    input logic fbpending,
    input logic chreadyi,
    input logic chreadyii,
    input logic STROBEI,
    input logic NEWLINE,
    input logic NEWSLICE,
    input logic outf1,
    input logic outf,
    input logic lvalid,
    input logic tvalid,
    input logic dconly,
    input logic ,
    input logic [5:0] statei,
    input logic [3:0] submb, //xx,yy these also create here with submb
    input logic [3:0] modeoi,
    input logic [3:0] prevmode,
    output logic , 
    output logic , 
    output logic , 
    output logic , 
    output logic , 
    output logic , 
    output logic [:0] , 
    output logic [:0] , 
);

logic [1:0] xx,yy;
logic [1:0] l_xx,t_yy;
logic [4:0] c_state;
logic [4:0] n_state;
parameter S0    =   5'd0;
parameter S1    =   5'd1;
parameter S2    =   5'd2;
parameter S3    =   5'd3;
parameter S4    =   5'd4;
parameter S5    =   5'd5;
parameter S6    =   5'd6;
parameter S7    =   5'd7;
parameter S8    =   5'd8;
parameter S9    =   5'd9;
parameter S10   =   5'd10;
parameter S11   =   5'd11;
parameter S12   =   5'd12;
parameter S13   =   5'd13;
parameter S14   =   5'd14;
parameter S15   =   5'd15;
parameter S16   =   5'd16;
parameter S17   =   5'd17;
parameter S18   =   5'd18;
parameter S19   =   5'd19;
parameter S20   =   5'd20;


//state register
always_ff @ (posedge clk)
begin
    //reset is active high or posedge reset
    if (!STROBEI & NEWLINE) c_state <= S0;
    else                    c_state <= n_state;
end

//next_state always block
always_comb
begin
    case (c_state)
        S0:
        begin 
            if (statei == 0) n_state = S0;
            else             n_state = S1 ; 
        end

        S1:
        begin 
            n_state = S2;
        end

        S2:
        begin 
            n_state = S3;
        end

        S3:
        begin 
            if (statei[5:4] == yy ) n_state = S3; 
            else                    n_state = S4 ;
        end

        S4:
        begin 
            n_state = S5;
        end

        S5:
        begin 
            n_state = S6 ; 
        end

        S6:
        begin 
            n_state = S7;
        end

        S7:
        begin 
            n_state = S8;            
        end
        S8:
        begin 
            n_state = S9;
        end
        S9:
        begin 
            n_state = S10;    
        end
        S10:
        begin 
            n_state = S11;
        end
        S11:
        begin 
            if((!READYO || FBSTROBE || fbpending)) 
                n_state = S11;
            else
                n_state = S12;
        end
        S12:
        begin 
            n_state = S13;    
        end
        S13:
        begin 
            n_state = S14;    
        end
        S14:
        begin 
            n_state = S15;    
        end
        S15:
        begin
            if(xx[0] && submb != 15) 
                n_state = S2;
            else
                n_state = S16;
        end
        S16:
        begin 
            n_state = S17;
        end
        S17:
        begin 
            n_state = S18;
        end
        S18:
        begin 
            n_state = S19;
        end
        S19:
        begin 
            if((FBSTROBE || fbpending || chreadyi || chreadyii))
                n_state = S19;
            else if(submb != 0)
                n_state = S3;
            else
                n_state = S20;
        end
        S20:
        begin 
            n_state = S20;
        end
    endcase
end


//Output logic 
always_comb 
begin
    xx = {submb[2], submb[0]};
    yy = {submb[3], submb[1]};
    t_yy = (tvalid || yy != 0);
    l_xx = (lvalid || xx != 0);
    dconly_sel2 = l_xx && t_yy;

    case (c_state)
        S0:
        begin 
            if(!STROBEI & NEWLINE) rst_0 = 1'b1;
            else                   rst_0 = 1'b0;
        end

        S1:
        begin
            rst_0 = 1'b0;
            oldxx_en = 1'b1;
        end

        S2:
        begin 
            oldxx_en = 1'b0;
            xxo_sel  = 1'b1;
            topih_en = 1'b1;
        end

        S3:
        begin 
            xxo_sel  = 1'b0;
            topih_en = 1'b0;
            topii_en = 1'b1;
        end

        S4:
        begin 
            topii_en = 1'b0;     
        end

        S5:
        begin  
        end

        S6:
        begin 
            totdif_rst = 1'b1;
            dconly_sel1 = 1'b1;
        end

        S7:
        begin 
            totdif_rst = 1'b0;
            dconly_sel1 = 1'b0;
            totdif_en  = 1'b1;
        end

        S8:
        begin 
            totdif_en = 1'b1;
        end

        S9:
        begin 
            totdif_en = 1'b1;
        end

        S10:
        begin 
            totdif_en = 1'b1;
        end

        S11:
        begin
            totdif_en = 1'b0;
            modeoi_en = 1'b1;
            if (vtotdif <= htotdif && vtotdif <= dtotdif && !dconly) 
                modeoi <= 8'h0;		
            else if (htotdif <= dtotdif && !dconly) 
                modeoi <= 8'h1;		
            else
                modeoi <= 8'h2;		
        end

        S12:
        begin 
 
        end

        S13:
        begin 
        end
        S14:
        begin 

        end

        S15:
        begin
        end
        S16:
        begin 

        end
        S17:
        begin 

        end
        S18:
        begin 

        end
        S19:
        begin 

        end
        S20:
        begin 

        end

        default: 
        begin
            out = 1'bx;
        end

    endcase
end


endmodule
