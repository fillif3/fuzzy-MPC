%% preperation

% 1-> 1_D linear
% 2-> mobile robot with direction
the_case=2;

% Main parameters

NUMBER_OF_ITERATIONS=50;
discretization_time=0.1;
drawing_flag=true;


if the_case==1
    % System parameters
    NUMBER_OF_INPUTS=1;
    system_model =@Model_1D;
    system_simulink_name='model_1D.slx';
    state=[1,0];
    state_names={'position','velocity'};
    not_controlled_states=[];
    % Trajectory
    
    x=linspace(0,2,NUMBER_OF_ITERATIONS+1);
    ref_full=[sin(x);cos(x)];
    % MPC parameters

    horizon=30;
    fuzzy_combaining_membership_method='min';
    fuzzy_membership_type={'tringular','tringular'};
    fuzzy_parameter=[1,1];
    fuzzy_weights = [0.2,1];

elseif the_case==2
        % System parameters
    NUMBER_OF_INPUTS=2;
    system_model =@Model_2D;
    system_simulink_name='model_2D.slx';
    state=[0,0,pi/4,0,0];
    state_names={'position x','position y', 'rotation', 'velocity of left wheel', 'velocity of right wheel'};
    not_controlled_states=[3,4,5];
    % Trajectory
    
    x=linspace(0,2,NUMBER_OF_ITERATIONS+1);
    ref_full=[linspace(1,10,NUMBER_OF_ITERATIONS+1)*0.5;linspace(1,10,NUMBER_OF_ITERATIONS+1)*0.5;ones(1,NUMBER_OF_ITERATIONS+1);zeros(2,NUMBER_OF_ITERATIONS+1)];

    % MPC parameters

    horizon=30;
    fuzzy_combaining_membership_method='min';
    fuzzy_membership_type={'gauss','gauss','gauss','gauss','gauss'};
    fuzzy_parameter=[1,1,1,1,1];
    fuzzy_weights = [1,1,5,1,0.2];

end






%   Detailed explanation goes here
input=[0,1;0,0];
state_history=zeros(NUMBER_OF_ITERATIONS,length(state));

% simulation
for i=1:NUMBER_OF_ITERATIONS
    horizon=min(horizon,NUMBER_OF_ITERATIONS-i+1);
    ref=ref_full(:,i:(i+horizon));
    
    val=fuzzy_MPC(discretization_time,system_model,NUMBER_OF_INPUTS,...
        horizon,transpose(ref),state,fuzzy_combaining_membership_method,fuzzy_membership_type,fuzzy_parameter,...
        fuzzy_weights,not_controlled_states,[],[],[],[],-ones(NUMBER_OF_INPUTS*horizon,1),ones(NUMBER_OF_INPUTS*horizon,1));
    input(:,2:(NUMBER_OF_INPUTS+1))=[val';val'];
    output=sim(system_simulink_name);
    dummy_state=state;
    state=output.simout.Data(end,:);
    
    state_history(i,:)=state;    
end

%Drawing
if drawing_flag
    draw_state_wtih_ref(state_history,transpose(ref_full),not_controlled_states,state_names,fuzzy_membership_type,fuzzy_parameter,fuzzy_combaining_membership_method)
end


