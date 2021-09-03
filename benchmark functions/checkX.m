function x=checkX(x,option,data)
    x(x<option.lb)=option.lb(x<option.lb);
    x(x>option.ub)=option.ub(x>option.ub);
end