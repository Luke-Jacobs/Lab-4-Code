
module multiplier(
	input logic clk,
	input logic [7:0] S,
	input logic clear_A_load_B,
	input logic run,
	output logic [15:0] product
);

logic shift_signal, add_signal, subtract_signal, clear_A_loadB, M;
logic [7:0] A, B;

// Datapath
datapath data(.clk(clk), .shift_sig(shift_signal), .add_sig(add_signal), .sub_sig(subtract_signal), 
				  .A(A), .B(B), .clear_A_load_B_sig(clear_A_loadB), .S(S));

// FSM
multiplier_fsm fsm(.reset(clear_A_loadB), .clk(clk), .run(run), .M_signal(M), 
						 .shift(shift_signal), .add(add_signal), .sub(subtract_signal));

always_comb
begin

	product = {A, B};
	M = B[0];

end



endmodule

