
module multiplier_fsm(
	input logic reset,
	input logic clk,
	input logic run,
	
	input logic [1:0] M_signal,
	
	output logic shift,
	output logic add,
	output logic sub
	
	
);

enum logic [18:0] {SS1, SS2, SS3, SS4, SS5, 
						SS6, SS7, SS8, AS1, AS2, 
						AS3, AS4, AS5, AS6, AS7, 
						SubtractState, HoldState} state, next_state;

// Transition to the next state
always_comb begin

	// Default case: do nothing and stay in same state
	next_state = state;
	unique case (state)
	
		AS1:
			next_state = SS1;
		AS2:
			next_state = SS2;
		AS3:
			next_state = SS3;
		AS4:
			next_state = SS4;
		AS5:
			next_state = SS5;
		AS6:
			next_state = SS6;
		AS7:
			next_state = SS7;
			
		SubtractState:
			next_state = SS8;
			
		SS1:
			if (M_signal[1])
				next_state = AS2;
			else
				next_state = SS2;
		SS2:
			if (M_signal[1])
				next_state = AS3;
			else
				next_state = SS3;
		SS3:
			if (M_signal[1])
				next_state = AS4;
			else
				next_state = SS4;
		SS4:
			if (M_signal[1])
				next_state = AS5;
			else
				next_state = SS5;
		SS5:
			if (M_signal[1])
				next_state = AS6;
			else
				next_state = SS6;
		SS6:
			if (M_signal[1])
				next_state = AS7;
			else
				next_state = SS7;
		SS7:
			if (M_signal[1])
				next_state = SubtractState;
			else
				next_state = SS8;
		SS8:
			next_state = HoldState;
			
		HoldState:
			if (run & M_signal[0])
				next_state = AS1;
			else if (run & (!M_signal[0]))
				next_state = SS1;

	endcase
	
	
	// Assign outputs by state
	shift = 0;
	add = 0;
	sub = 0;
	unique case (state)
		SS1:
			shift = 1;
		SS2:
			shift = 1;
		SS3:
			shift = 1;
		SS4:
			shift = 1;
		SS5:
			shift = 1;
		SS6:
			shift = 1;
		SS7:
			shift = 1;
		SS8:
			shift = 1;
		
		AS1:
			add = 1;
		AS2:
			add = 1;
		AS3:
			add = 1;
		AS4:
			add = 1;
		AS5:
			add = 1;
		AS6:
			add = 1;
		AS7:
			add = 1;
			
		SubtractState:
			sub = 1;
			
		HoldState:
			shift = 0;
		
	endcase
	
end

// FF Updating - update our new state
always_ff @ (posedge clk)
begin
	
	if (reset)
		state <= HoldState;
	else
		state <= next_state;
end


endmodule
