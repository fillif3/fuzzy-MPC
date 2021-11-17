function out = fuzzy_MPC(time_step,model,number_of_inputs,horizon,ref,current_state,type_of_merging_membership,...
    type_of_membership_function,fuzzy_parameter,fuzzy_weights,not_tracked_states,A,b,Aeq,beq,lu,ub)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


cost_function = @(x)fuzzy_cost(x,current_state,horizon,ref,time_step,type_of_merging_membership,type_of_membership_function,...
    fuzzy_parameter,model,fuzzy_weights,not_tracked_states);

options = optimoptions('fmincon','Display','off');

result = fmincon(cost_function,zeros(number_of_inputs*horizon,1),A,b,Aeq,beq,lu,ub,[],options);
out=result(1:number_of_inputs);
end