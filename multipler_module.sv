
module multiplier(
	input logic clk,
	input logic [7:0] S,
	input logic [7:0] B,
	input logic [7:0] A,
	input logic X,
	
	input logic clear_A_load_B,
	input logic run
);

// M determines when the adder 
logic M;
assign M = B[0];

// Shifter register wiring
logic [16:0] full_register = {X, A, B};
shift_register(.clk(clk), .data_in(full_register), .shift_in(X), .shift_toggle(shift_signal),
					.data_out(full_register));

// FSM
logic shift_signal, add_signal, subtract_signal;
multiplier_fsm fsm(.reset(clear_A_load_B), .clk(clk), .run(run), .M_signal(M), 
						 .shift(shift_signal), .add(add_signal), .sub(subtract_signal));

// 9 bit adder wiring for addition
logic s_adder_input;
adder_9_bit(.x(A), .y(s_adder_input), .c_in(subtract_signal), .s({X, A}));

always_comb begin

	// Addition vs. Subtraction switching
	if (subtract_signal)
		s_adder_input = !S;
	else
		s_adder_input = S;

end

endmodule



module shift_register(
	input logic clk,
	input logic reset_load_clear, // This 0's X and A and loads b_data_in into B
	input logic [7:0] b_data_in,  // Only used for parallel load of B
	input logic [16:0] data_in,  // This will be XAB
	input logic shift_in,  // This will always be X
	input logic shift_toggle,  // This is the S signal from the state machine
	
	output logic [16:0] data_out  // This is the new value of XAB
);

	always_ff @ (posedge clk)
		begin
			// Reset Load Clear implementation
			if (reset_load_clear) //notice, this is a synchronous reset, which is recommended on the FPGA
				data_out <= {9'b000000000, b_data_in};
			
			// Shift implementation
			else if (shift_toggle) begin
				data_out <= {data_in[16], shift_in, data_in[15:1]};
			end

			// Do nothing
			else
				data_out <= data_in;
	end	

endmodule

