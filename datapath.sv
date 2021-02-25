module datapath(
	input logic clk,
	// Only one of these signals should be high
	input logic shift_sig,
	input logic add_sig,
	input logic sub_sig,
	input logic clear_A_load_B_sig,
	// Switch input
	input logic [7:0] S,
	// Output registers
	output logic X,
	output logic [7:0] A,
	output logic [7:0] B
);

// This might be needed if outputs can't be used as inputs to internal modules
//	logic [7:0] A, B;
//	logic X;

	logic [16:0] XAB_new;
	logic [8:0]  adder_result;
	logic load;
	
	// Shift register wiring
	shift_register shift_register0(.clk(clk), .shift_in(X), .shift_toggle(shift_sig), .data_new(XAB_new), .load(load),
												.data_out({X, A, B}));

	// 9 bit adder wiring for addition
	logic s_adder_input;
	adder_9_bit adder_0(.x(A), .y(s_adder_input), .c_in(subtract_signal), .s(adder_result));

	always_comb
		s_adder_input = S;
		
		// Implement reset_load_clear here
		if (clear_A_load_B_sig) begin
			load = 1;
			XAB_new = {1b'0 + 8b'00000000 + S}; // On the next clock, this will be input into the register (B will receive S)
		
		// Shift
		end else if (shift_sig) begin
			load = 0;
			XAB_new = 17'bX; // We don't care what XAB is when the shift signal is high because it won't get placed in the FF

		// Addition
		end else if (add_sig) begin
			load = 1;
			XAB_new = {adder_result, B}; // The new XAB will be the result of the addition concat with B
		
		// Subtraction
		end else if (sub_sig) begin
			load = 1;
			s_adder_input = ~S; // NOT S so that with the carry in S can be negated
			XAB_new = {adder_result, B}; // The new XAB will be the result of the subtraction concat with B
		end
	
	end

endmodule


module shift_register(
	input logic clk,
	input logic load, // Load XAB signal
	input logic [16:0] data_new, // Parallel load D
	input logic shift_in,  // This will always be X
	input logic shift_toggle,  // This is the S signal from the state machine
	output logic [16:0] data_out  // This is the new value of XAB
);

	always_ff @ (posedge clk)
		begin
			// Reset Load Clear implementation
			if (load)
				data_out <= data_new;
			
			// Shift implementation
			else if (shift_toggle) begin
				data_out <= {data_out[16], shift_in, data_out[15:1]};
			end
			
			// Do nothing if shift_toggle and load are both low
	end	

endmodule
