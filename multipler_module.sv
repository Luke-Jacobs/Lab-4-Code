
module multiplier(
	input logic clk,
	input logic [7:0] S,
	input logic clear_A_load_B,
	input logic run,
	output logic [15:0] product
);

logic shift_signal, add_signal, subtract_signal;
logic [7:0] A, B;
logic [1:0] M;

// Datapath
datapath data(.clk(clk), .shift_sig(shift_signal), .add_sig(add_signal), .sub_sig(subtract_signal), 
				  .A(A), .B(B), .clear_A_load_B_sig(clear_A_load_B), .S(S), .XA_clr(run));

// FSM
multiplier_fsm fsm(.reset(clear_A_load_B), .clk(clk), .run(run), .M_signal(M), 
						 .shift(shift_signal), .add(add_signal), .sub(subtract_signal));

always_comb
begin

	product = {A, B};
	M = B[1:0];

end



endmodule

