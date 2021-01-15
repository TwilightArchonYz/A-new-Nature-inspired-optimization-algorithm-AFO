function y=fitFCN_BX(x,option,data)
    global option
    y=option.fobj0(x+option.XB);
end