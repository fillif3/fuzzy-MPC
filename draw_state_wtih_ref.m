function draw_state_wtih_ref(state,ref,not_tracked_states,names,type,fuzzy_parameter,fuzzy_combaining_membership_method)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i=wrev(sort(not_tracked_states))
    state(:,i)=[];
    ref(:,i)=[];
end
size_states=size(state);
figure
for i=1:size_states(2)
    subplot(size_states(2),1,i)
    hold on
    plot(state(:,i))
    plot(ref(:,i))
    legend('State of model','reference')
    ylabel(names{i})
end
xlabel('Iteration')
figure
hold on
membership=zeros(size_states);
for i=1:size_states(2)
    errors = state(:,i)-ref(1:size_states(1),i);
    for j=1:size_states(1)
        if strcmpi(type{i},'tringular')
            membership(j,i) = fuzzy_tringular([-fuzzy_parameter(i),0,fuzzy_parameter(i)],errors(j));
        elseif strcmpi(type{i},'gauss')
            membership(j,i) = fuzzy_gauss(fuzzy_parameter(i),errors(j));
        end
    end
end
plot(membership)
legend(names)
xlabel('Iteration')
ylabel('membership')
if size_states(2)>1
    figure
    if strcmpi(fuzzy_combaining_membership_method,'min')
        membership=min(transpose(membership));
    elseif strcmpi(fuzzy_combaining_membership_method,'prod')
        membership=prod(membership,2);
    elseif strcmpi(fuzzy_combaining_membership_method,'sum')
        membership=sum(transpose(membership));
    end
    plot(membership)
    xlabel('Iteration')
    ylabel('membership')
    legend('final membership')
end
