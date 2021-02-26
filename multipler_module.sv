
module multiplier(
	input logic Clk,
	input logic [7:0] SW,
	input logic Reset_Load_Clear,
	input logic Run,
);

logic shift_signal, add_signal, subtract_signal;
logic [7:0] A, B;
logic [1:0] M;

// Datapath
datapath data(.clk(Clk), .shift_sig(shift_signal), .add_sig(add_signal), .sub_sig(subtract_signal), 
				  .A(A), .B(B), .clear_A_load_B_sig(Reset_Load_Clear), .S(SW), .XA_clr(Run));

// FSM
multiplier_fsm fsm(.reset(Reset_Load_Clear), .clk(Clk), .run(Run), .M_signal(M), 
						 .shift(shift_signal), .add(add_signal), .sub(subtract_signal));

// Output
HexDriver        HexAL (.In0(A[3:0]));
HexDriver        HexBL (.In0(B[3:0]));
						
//When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
HexDriver        HexAU (.In0(A[7:4]));
HexDriver        HexBU (.In0(B[7:4]));
					 
always_comb
begin

	product = {A, B};
	M = B[1:0];

end



endmodule

