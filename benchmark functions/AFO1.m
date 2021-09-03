function [bestY,bestX,recording]=AFO(x,y,option,data)
%% Authority
% Author: Zhe Yang
% E-mail: 454170989@qq.com
% School:University of Manchester
%% Input
% x----positions of initialized populaiton
% y----fitnesses of initialized populaiton
% option-----parameters set of the algorithm
% data------Pre-defined parameters
% This parameter is used for solving complex problems is passing case data
%% outPut
% bestY ----fitness of best individual
% bestX ----position of best individual
% recording ---- somme data was recorded in this variable
%% initialization
pe=option.pe;
L=option.L;
gap0=option.gap0;
gap=gap0;
dim=option.dim;
recording.bestFit=zeros(option.maxIteration+1,1);
recording.meanFit=zeros(option.maxIteration+1,1);
At=randn(option.numAgent,option.dim);
count=1;
%% center of population
[y_c,position]=min(y);
x_c=x(position(1),:);
At_c=At(position(1),:);
%% memory of population
y_m=y;
x_m=x;
%% update recording
recording.bestFit=y_c;
recording.meanFit=mean(y_m);
%% main loop
for iter=1:option.maxIteration
    %Dmp(['AFO,iter:',num2str(iter),',minFit:',num2str(y_c)])
    %% Moving Strategy I for center of population
    if rem(iter, gap)==0
        c0=exp(-30*(iter-gap0)/option.maxIteration); % EQ.2-11
        Dx=ones(1,dim);
        Dx=c0*Dx/norm(Dx)*norm(option.v_ub-option.v_lb)/2; %EQ.2-12
        % +¡÷x
        for j=1:dim
            tempX(j,:)=x_c; 
            tempX(j,j)=x_c(1,j)+Dx(j);
            if tempX(j,j)>option.ub(j)
                tempX(j,j)=option.ub(j);
                Dx(1,j)=tempX(j,j)-x_c(1,j);
            end
            if tempX(j,j)<option.lb(j)
                tempX(j,j)=option.lb(j);
                Dx(1,j)=tempX(j,j)-x_c(1,j);
            end
            tempY(j,:)=option.fobj(tempX(j,:));
            if tempY(j)*y_c<0
                g0(1,j)=(log(tempY(j))-log(y_c))./Dx(j); %EQ.2-18
            else
                temp=[tempY(j),y_c];
                temp=temp+min(temp)+eps;
                g0(1,j)=(log(temp(1))-log(temp(2)))./Dx(j);
            end     
            g0(isnan(g0))=0;
        end
        G0=-g0(1,:)*norm(option.v_ub-option.v_lb)/2/norm(g0(1,:)); % part of Eq 2-18 
        G0(1,G0(1,:)>option.v_ub)=G0(1,G0(1,:)>option.v_ub)/max(G0(1,G0(1,:)>option.v_ub))*max(option.v_ub(G0(1,:)>option.v_ub));
        G0(1,G0(1,:)<option.v_lb)=G0(1,G0(1,:)<option.v_lb)/min(G0(1,G0(1,:)<option.v_lb))*min(option.v_lb(G0(1,:)<option.v_lb));
        G01=G0;
        % -¡÷x
        Dx=-ones(1,dim);
        Dx=c0*Dx/norm(Dx)*norm(option.v_ub-option.v_lb)/2;
        for j=1:dim
            tempX(j+dim,:)=x_c;
            tempX(j+dim,j)=x_c(1,j)+Dx(j);
            if tempX(j+dim,j)>option.ub(j)
                tempX(j+dim,j)=option.ub(j);
                Dx(1,j)=tempX(j,j)-x_c(1,j);
            end
            if tempX(j+dim,j)<option.lb(j)
                tempX(j+dim,j)=option.lb(j);
                Dx(1,j)=tempX(j,j)-x_c(1,j);
            end
            tempY(j+dim,:)=option.fobj(tempX(j,:));
            if tempY(j)*y_c<0
                g0(1,j)=(log(tempY(j))-log(y_c))./Dx(j); %EQ.2-18
            else
                temp=[tempY(j),y_c];
                temp=temp+min(temp)+eps;
                g0(1,j)=(log(temp(1))-log(temp(2)))./Dx(j);
            end
            g0(isnan(g0))=0;
        end
        G0=-g0(1,:)*norm(option.v_ub-option.v_lb)/2/norm(g0(1,:)); % part of Eq 2-18 
        G0(1,G0(1,:)>option.v_ub)=G0(1,G0(1,:)>option.v_ub)/max(G0(1,G0(1,:)>option.v_ub))*max(option.v_ub(G0(1,:)>option.v_ub));
        G0(1,G0(1,:)<option.v_lb)=G0(1,G0(1,:)<option.v_lb)/min(G0(1,G0(1,:)<option.v_lb))*min(option.v_lb(G0(1,:)<option.v_lb));
        G02=G0;
        G0=G01+G02; % part of Eq 2-18 
        G0(isnan(G0))=0;
        if sum(G0)==0
            N=option.numAgent-2*dim;
            Dm=mean(x-repmat(x_c,option.numAgent,1));
            Dm=norm(Dm); %EQ.2-22
            if Dm<norm(option.v_ub-option.v_lb)/20*iter/option.maxIteration
                Dm=norm(option.v_ub-option.v_lb);             
            end
            for j=2*dim+(1:N)
                G0=randn(1,dim);
                tempX(j,:)=x(i,:)+5*rand*G0./norm(G0)*Dm; %EQ.2-21
                tempX(j,:)=checkX(tempX(j,:),option,data);
                tempY(j,:)=option.fobj(tempX(j,:));
            end
        else
            N=option.numAgent-2*dim;
            r1=exp(-10*(0:N-1)/(N-1));
            unitG=norm(Dx)/norm(G0); %EQ.2-19
            if unitG~=1
                r2=1:-(1-unitG)/(N-1):unitG;
                a=r1.*r2; %EQ.2-17
            else
                a=r1;
            end
            for j=2*dim+(1:N)
                tempX(j,:)=x_c+G0*a(j-2*dim); %EQ,2-20
                tempX(j,:)=checkX(tempX(j,:),option,data);
                tempY(j,:)=option.fobj(tempX(j,:));
            end
        end
        [minY,no]=min(tempY);
        if minY<y_c
            y_c=tempY(no);
            x_c=tempX(no,:);
        end
        if rand>(no-dim*2)/(option.numAgent-dim*2)*(option.maxIteration-iter)/option.maxIteration
            gap=max(option.gapMin,gap-option.dec); %EQ.2-15
        end
    else
        for i=1:option.numAgent
            p =tanh(abs(y(i)-y_c)); %EQ.2-30  
            if rand<p*(option.maxIteration-iter)/option.maxIteration
                % EQ 2-28
                At(i,:)=option.w2*At(i,:)+option.w4*rand(size(x(1,:))).*(x_c-x(i,:))+option.w5*rand(size(x(1,:))).*(x_m(i,:)-x(i,:));
                x(i,:)=x(i,:)+At(i,:); %EQ 2-29
                x(i,:)=checkX(x(i,:),option,data);
                tempY(i,:)=y(i);
                y(i)=option.fobj(x(i,:),option,data);
                if tempY(i,:)<y(i)
                    for j=1:dim
                        r1=randi(option.numAgent);
                        r2=randi(option.numAgent);
                        v(i,j)=rand.*(x_m(r1,j)-x_m(r2,j))*-sign(y_m(r1)-y_m(r2));
                        if std(x_m(:,j))<=exp(-20*iter/option.maxIteration)*(option.v_ub(j)-option.v_lb(j))/2
                            if v(i,j)==0
                                v(i,j)=randn*(option.v_ub(j)-option.v_lb(j))/2;
                            else
                                v(i,j)=rand.*sign(x_m(r1,j)-x_m(r2,j))*-sign(y_m(r1)-y_m(r2))*(option.v_ub(j)-option.v_lb(j))/2;
                            end
                        end
                    end
                end
            else
                g0=randn(size(At_c));
                r1=randi(option.numAgent);
                r2=randi(option.numAgent);
                for j=1:dim
                    r1=randi(option.numAgent);
                    r2=randi(option.numAgent);
                    a = atanh(-(iter/option.maxIteration)+1); %EQ.2-6
                    AI(j)=2*a*rand.*(x_m(r1,j)-x_m(r2,j))*-sign(y_m(r1)-y_m(r2)); %2-24
                    if std(x_m(:,j))<=exp(-20*iter/option.maxIteration)*(option.v_ub(j)-option.v_lb(j))/2 %EQ2-26
                        if AI(j)==0
                            AI(j)=randn*(option.v_ub(j)-option.v_lb(j))/2; %2-25
                        else
                            AI(j)=rand.*sign(x_m(r1,j)-x_m(r2,j))*-sign(y_m(r1)-y_m(r2))*(option.v_ub(j)-option.v_lb(j))/2; %EQ.2-27
                        end
                    end
                end
                x(i,:)=x_c+AI;
                At(i,:)=AI;
                x(i,:)=checkX(x(i,:),option,data);
                y(i)=option.fobj(x(i,:),option,data);
            end
            
            if y(i)<y_m(i)
                y_m(i)=y(i);
                x_m(i,:)=x(i,:);
                if y_m(i)<y_c
                    y_c=y_m(i);
                    x_c=x_m(i,:);
                    At_c=At(i,:);
                end
            end
        end
    end
    % EQ.2-31
    if abs(y_c-recording.bestFit(iter))/abs(recording.bestFit(iter))<=pe
        count=count+1;
    else
        count=0;
    end
    if count>L
        for i=1:option.numAgent
            x(i,:)=(option.ub-option.lb)*rand+option.lb;
            y(i)=option.fobj(x(i,:),option,data);
            if y(i)<y_m(i)
                y_m(i)=y(i);
                x_m(i,:)=x(i,:);
                if y_m(i)<y_c
                    y_c=y_m(i);
                    x_c=x_m(i,:);
                    At_c=At(i,:);
                end
            end
        end
        count=0;
    end
    %% ¸üÐÂ¼ÇÂ¼
    recording.bestFit(1+iter)=y_c;
    recording.meanFit(1+iter)=mean(y_m);
%     recording.std(1+iter)=mean(std(x_m));
%     recording.DC(1+iter)=norm(x_m-repmat(x_c,option.numAgent,1));
%     recording.x1(1+iter,:)=x(1,:);
end
bestY=y_c;
bestX=x_c;
end
%%
