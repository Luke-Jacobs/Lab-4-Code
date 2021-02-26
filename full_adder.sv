
// Implements a single-bit adder
module full_adder (
	input logic x, 
	input logic y, 
	input logic c_in, 
	output logic c_out, 
	output logic s
);

	always_comb begin
	
		s = c_in^(x^y);
		c_out = (x&y)|(x&c_in)|(y&c_in);
		
	end
	
endmodule
