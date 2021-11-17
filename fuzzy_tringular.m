function y = fuzzy_tringular(parameters,x)
    if x<=parameters(1)
        y=0;
    elseif x<=parameters(2)
        y=(x-parameters(1))/(parameters(2)-parameters(1));
    elseif x<=parameters(3)
        y=(x-parameters(3))/(parameters(2)-parameters(3));
    else
        y=0;
    end
end