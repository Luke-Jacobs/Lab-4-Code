
module counter(
	input logic increment, 
	input logic reset,
	input logic clk,
	output logic [3:0]
);

logic input [3:0] state, next_state;
four_bit_ra add_count(.x(state), .y(1), .c_in(0), .s(next_state));

always_ff @(posedge clk or posedge reset)
	if (reset)
		state = 3b'000;
	else if (increment)
		state = next_state;
end

endmodule
