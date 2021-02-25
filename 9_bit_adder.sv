
// Implement a 9-bit adder
module adder_9_bit(
	input logic [8:0] x, 
	input logic [8:0] y, 
	input logic c_in,
	output logic c_out,
	output logic [8:0] s
);

	logic c1, c2, c3, c4, c5, c6, c7, c8;
	
	full_adder fa0(.x(x[0]), .y(y[0]), .c_in(c_in),
						.c_out(c1), .s(s[0]));
						
	full_adder fa1(.x(x[1]), .y(y[1]), .c_in(c1),
						.c_out(c2), .s(s[1]));
						
	full_adder fa2(.x(x[2]), .y(y[2]), .c_in(c2),
						.c_out(c3), .s(s[2]));
						
	full_adder fa3(.x(x[3]), .y(y[3]), .c_in(c3),
						.c_out(c4), .s(s[3]));
						
	full_adder fa4(.x(x[4]), .y(y[4]), .c_in(c4),
						.c_out(c5), .s(s[4]));
						
	full_adder fa5(.x(x[5]), .y(y[5]), .c_in(c5),
						.c_out(c6), .s(s[5]));
						
	full_adder fa6(.x(x[6]), .y(y[6]), .c_in(c6),
						.c_out(c7), .s(s[6]));
						
	full_adder fa7(.x(x[7]), .y(y[7]), .c_in(c7),
						.c_out(c8), .s(s[7]));
						
	full_adder fa8(.x(x[8]), .y(y[8]), .c_in(c8),
						.c_out(c_out), .s(s[8]));

endmodule