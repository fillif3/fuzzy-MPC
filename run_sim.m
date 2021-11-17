%% preperation

% 1-> 1_D linear
% 2-> mobile robot with direction
the_case=1 ;

% Main parameters

NUMBER_OF_ITERATIONS=50;
discretization_time=0.1;
drawing_flag=true;


if the_case==1
    % System parameters
    NUMBER_OF_INPUTS=1;
    system =@Model_1D;
    state=[1,0];
    state_names={'position','velocity'};
    not_controlled_states=[];
    % Trajectory
    
    x=linspace(0,2,NUMBER_OF_ITERATIONS+1);
    ref_full=[sin(x);cos(x)];
    % MPC parameters

    horizon=15;
    fuzzy_combaining_membership_method='min';
    fuzzy_membership_type={'tringular','tringular'};
    fuzzy_parameter=[1,1];
    fuzzy_weights = [0.2,1];

elseif the_case==2
        % System parameters
    NUMBER_OF_INPUTS=2;
    system =@Model_2D;
    state=[0,0,0,0,0];
    state_names={'position x','position y', 'rotation', ''};
    not_controlled_states=[];
    % Trajectory
    
    x=linspace(0,2,NUMBER_OF_ITERATIONS+1);
    ref_full=[sin(x);cos(x)];

    % MPC parameters

    horizon=15;
    fuzzy_combaining_membership_method='min';
    fuzzy_membership_type={'tringular','tringular','tringular','tringular','tringular'};
    fuzzy_parameter=[1,1,1,1,1];
    fuzzy_weights = [0.2,1,0.2,1,0.2];

end






%   Detailed explanation goes here
input=[0,1;0,0];
state_history=zeros(NUMBER_OF_ITERATIONS,length(state));

% simulation

for i=1:NUMBER_OF_ITERATIONS
    horizon=min(horizon,NUMBER_OF_ITERATIONS-i+1);
    ref=ref_full(:,i:(i+horizon));
    
    val=fuzzy_MPC(discretization_time,system,NUMBER_OF_INPUTS,...
        horizon,transpose(ref),state,fuzzy_combaining_membership_method,fuzzy_membership_type,fuzzy_parameter,...
        fuzzy_weights,not_controlled_states,[],[],[],[],-ones(NUMBER_OF_INPUTS*horizon,1),ones(NUMBER_OF_INPUTS*horizon,1));
    input(:,2:(NUMBER_OF_INPUTS+1))=[val,val];
    output=sim('model_1D.slx');
    state=output.simout.Data(end,:);
    state_history(i,:)=state;    
end

%Drawing
if drawing_flag
    draw_state_wtih_ref(state_history,transpose(ref_full),not_controlled_states,state_names,fuzzy_membership_type,fuzzy_parameter,fuzzy_combaining_membership_method)
end


