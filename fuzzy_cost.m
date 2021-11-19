function cost= fuzzy_cost(inputs,current_state,horizon,ref,time_step,method,type,fuzzy_parameter,system,fuzzy_weights,not_tracked_states)
number_of_states=length(current_state);
NUMBER_OF_INPUTS=floor(length(inputs)/horizon);
errors = zeros(1,number_of_states);
for i=1:horizon
    current_state=system(inputs(((i-1)*NUMBER_OF_INPUTS+1):(i*NUMBER_OF_INPUTS),:),current_state,time_step);
    errors=errors+abs(current_state-ref(i,:));
end
errors=errors/horizon;
for i=wrev(sort(not_tracked_states))
    errors(:,i)=[];
end
number_of_states=number_of_states-length(not_tracked_states);
membership=zeros(1,number_of_states);

for i=1:number_of_states
    if strcmpi(type{i},'tringular')
        membership(i) = fuzzy_tringular([-fuzzy_parameter(i),0,fuzzy_parameter(i)],errors(i));
    elseif strcmpi(type{i},'gauss')
        membership(i) = fuzzy_gauss(fuzzy_parameter(i),errors(i));
    end
    membership(i)=membership(i)^fuzzy_weights(i);
end

if strcmpi(method,'prod')
    %cost=-min(membership);
    cost=-prod(membership);
elseif strcmpi(method,'min')
    cost=-min(membership);
elseif strcmpi(method,'sum')
    cost=-sum(membership);
end