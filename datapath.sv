module datapath(
	input logic clk,
	// Only one of these signals should be high
	input logic shift_sig,
	input logic add_sig,
	input logic sub_sig,
	input logic clear_A_load_B_sig,
	//input logic XA_clr,
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
												.data_out({X, A, B}));//, .XA_clr(XA_clr));

	// 9 bit adder wiring for addition
	logic [8:0] s_adder_input;
	
	adder_9_bit adder_0(.x({X,A}), .y(s_adder_input), .c_in(sub_sig), .s(adder_result));

	always_comb
	begin
		s_adder_input = {1'b0,S}; //default values 
		XAB_new =  17'hxxxxx;
		load = 0;
		// Implement reset_load_clear here
		if (clear_A_load_B_sig) begin
			load = 1;
			XAB_new = {9'b00000000, S}; // On the next clock, this will be input into the register (B will receive S)
		end
		// Shift
//		else if (shift_sig) begin
//			load = 0;
//			XAB_new = 17'hxxxxx; // We don't care what XAB is when the shift signal is high because it won't get placed in the FF
//		end 
		// Addition
		else if (add_sig) begin
			load = 1;
			XAB_new = {adder_result[7],adder_result[7:0], B}; // The new XAB will be the result of the addition concat with B
		end
		// Subtraction
		else if (sub_sig) begin
			load = 1;
			s_adder_input = ~S; // NOT S so that with the carry in S can be negated
			XAB_new = {adder_result[7], adder_result[7:0], B}; // The new XAB will be the result of the subtraction concat with B
		end
	
	end

endmodule


module shift_register(
	input logic clk,
	//input logic XA_clr,
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
			//clear XA register
			//else if(XA_clr)
				//data_out <= {9'b00000000, data_out[7:0]};
			// Shift implementation
			else if (shift_toggle)
				data_out <= {shift_in, shift_in, data_out[15:1]};
		end

endmodule
