
module testbench_lab4();


timeunit 10ns;	// Half clock cycle at 50 MHz
timeprecision 1ns; // This is the amount of time represented by #1 


logic [7:0] S;
logic [15:0] product;
logic clk, clear_A_load_B, run;

multiplier test_target(.Run_Accumulate(run), .Reset_Clear(clear_A_load_B), .Clk(clk), .SW(S), .product(product));


//datapath test_target(.clk(clk),.shift_sig(shift),.add_sig(add),.sub_sig(sub), 
	//.clear_A_load_B_sig(clear_A_load_B), .S(S), .X(X), .A(A), .B(B));
 
 
 
//adder_9_bit test_target(.x({X,A}), .y(S), .

 
always begin : CLOCK
	#1 clk = ~clk;
end


integer errorCount = 0;

initial begin

	// Init
	clk = 0;
	run = 0;
	clear_A_load_B = 1;
	

	// Load B from S
	#4
	S = 8'hc5;
	clear_A_load_B = 0;
	
	
	// Run computation
	#4
	clear_A_load_B = 1;
	S = 8'h07;
	run = 1;
	
	//#1 run = 0;
	
	
	//#50
	//run = 1;
	
	//#1 run = 0;
	
	
end

endmodule
