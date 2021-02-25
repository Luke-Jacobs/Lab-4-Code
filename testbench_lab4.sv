
module testbench_lab4();


timeunit 10ns;	// Half clock cycle at 50 MHz
timeprecision 1ns; // This is the amount of time represented by #1 


logic [7:0] S;
logic [15:0] product;
logic clk, clear_A_load_B, run;

multipler test_target(.run(run), .clear_A_load_B(clear_A_load_B), .clk(clk), .S(S), .product(product));

always_comb begin : CLOCK
	#1 clk = ~clk;
end

integer errorCount = 0;

initial begin

	// Init
	clk = 0;
	run = 0;
	clear_A_load_B = 0;
	S = 0;

	// Load B from S
	#4
	clear_A_load_B = 1;
	S = 8'hc5;
	
	// Run computation
	#4
	clear_A_load_B = 0;
	S = 8'h07;
	run = 1;
	
	#26
	if (product != -413)
		errorCount++;
	
	
end

endmodule
