function state = Model_1D(input,current_state,time_step)
state=current_state+[0.5*time_step^2*input+current_state(2)*time_step,time_step*input];


