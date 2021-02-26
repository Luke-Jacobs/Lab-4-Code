
module multiplier(
	input logic Clk,
	input logic [7:0] SW,
	input logic Reset_Clear,
	input logic Run_Accumulate,
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [6:0] HEX2,
	output logic [6:0] HEX3,
	output logic [6:0] HEX4,
	output logic [6:0] HEX5,
	output logic [15:0] product
);

logic shift_signal, add_signal, subtract_signal, Reset_Clear_H, Run_Accumulate_H;
logic [7:0] A, B, SW_H;
logic [1:0] M;
logic run_temp;


always_ff @ (posedge Clk)
begin
	if(Reset_Clear)
		run_temp = 1'b0;
	else if(Run_Accumulate_H && !run_temp)
		run_temp = Run_Accumulate_H;
	else if(run_temp && Run_Accumulate_H)
		run_temp = 1'b0;

end

always_comb
begin
	
	product = {A, B};
	M = B[1:0];
	//Reset_Clear_H = ~Reset_Clear; //inverts t
	Run_Accumulate_H = ~Run_Accumulate;

end

// Datapath
datapath data(.clk(Clk), .shift_sig(shift_signal), .add_sig(add_signal), .sub_sig(subtract_signal), 
				  .A(A), .B(B), .clear_A_load_B_sig(Reset_Clear_H), .S(SW_H));//, .XA_clr(Run_Accumulate));

// FSM
multiplier_fsm fsm(.reset(Reset_Clear_H), .clk(Clk), .run(run_temp), .M_signal(M), 
						 .shift(shift_signal), .add(add_signal), .sub(subtract_signal));

// Output
HexDriver        Hex2 (.In0(A[3:0]), .Out0(HEX2));
HexDriver        Hex3 (.In0(B[3:0]), .Out0(HEX0));
						
HexDriver        HexAU (.In0(A[7:4]), .Out0(HEX3));
HexDriver        HexBU (.In0(B[7:4]), .Out0(HEX1));

HexDriver        Hex0 (.In0(SW_H[7:4]), .Out0(HEX5));
HexDriver        Hex1 (.In0(SW_H[3:0]), .Out0(HEX4));
					 

sync button_sync(Clk, ~Reset_Clear, Reset_Clear_H);
//sync button1_sync(Clk,~Run_Accumulate, Run_Accumulate_H);
sync SW_sync[7:0](Clk,SW, SW_H);

endmodule

