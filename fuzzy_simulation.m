function state_history=fuzzy_simulation(NUMBER_OF_ITERATIONS,discretization_time,NUMBER_OF_INPUTS,system,state,...
    horizon,fuzzy_combaining_membership_method,fuzzy_membership_type,fuzzy_parameter,trajectory,simulink_model,drawing_flag)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
input=[0,1;0,0];
state_history=zeros(NUMBER_OF_ITERATIONS,length(state));

% simulation

for i=1:NUMBER_OF_ITERATIONS
    ref=trajectory(:,i:(i+horizon));
    val=fuzzy_MPC(discretization_time,system,NUMBER_OF_INPUTS,...
        horizon,transpose(ref),state,fuzzy_combaining_membership_method,fuzzy_membership_type,fuzzy_parameter);
    input(:,2)=[val,val];
    output=sim(simulink_model);
    state=output.simout.Data(end,:);
    state_history(i,:)=state;    
end

%Drawing
if drawing_flag
    draw_state_wtih_ref(state_history,transpose(trajectory))
end
end