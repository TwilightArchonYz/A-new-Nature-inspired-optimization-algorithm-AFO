function [bestY,bestX,recording]=AFO2(x,y,option,data)
% Update log.
% 1. 2021.1.1 
% Version 1.0
% All experiments of the paper are run based on this version, except for the experiments of running time.
% 2. 2021.1.7 
% Version 1.1
% Disadvantages of version 1.0
% (1) Too slow
% (2) The total number of evaluations is T*(N+m) after the catastrophe strategy is triggered, and m is the number of times the catastrophe strategy is triggered. 
% However, this problem will not affect the results of this experiment because the maximum number of iterations of the experiment is 50, and the catastrophe strategy will basically not be triggered.
% The runtime experiments of the paper are based on this version
% Updated content.
% (1) Optimization based on the advantages of MATLAB. The problem of too slow speed is solved.
% The core reason for the excessive slowness was that strategy 2 did not use matrix operations in version 1.0.
% Note: In order to use matrix operations, this version updates all individuals of the population when using the third strategy, but calculates the fitness value only for those individuals that are eligible. The total number of evaluations is still T*N.
% (2) After using the catastrophe strategy, the current iteration number +1,the total evaluation number reverts to T*N
%% Authority
% Author: Zhe Yang
% E-mail: 454170989@qq.com
% School: University of Manchester
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
maxIteration=option.maxIteration;
recording.bestFit=zeros(maxIteration+1,1);
recording.meanFit=zeros(maxIteration+1,1);
numAgent=option.numAgent;
At=randn(numAgent,dim);
w2=option.w2; %weight of Moving strategy III
w4=option.w4;%weight of Moving strategy III
w5=option.w5;%weight of Moving strategy III
pe=option.pe; % rate to judge Premature convergence
gapMin=option.gapMin;
dec=option.dec;
ub=option.ub;
lb=option.lb;
v_lb=option.v_lb;
v_ub=option.v_ub;
fobj=option.fobj;
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
iter=1;
while iter<=maxIteration
    %Dmp(['AFO,iter:',num2str(iter),',minFit:',num2str(y_c)])
    %% Moving Strategy I for center of population
    if rem(iter, gap)==0
        meanD=mean(abs(repmat(x_c,numAgent,1)-x));
        for i=1:numAgent
            tempX(i,:)=x_c+randn(1,dim).*meanD;
            tempY(i,:)=fobj(tempX(i,:));
        end
        [minY,no]=min(tempY);
        if minY<y_c
            y_c=tempY(no);
            x_c=tempX(no,:);
        end
        if rand>(no-dim*2)/(numAgent-dim*2)*(maxIteration-iter)/maxIteration
            gap=max(gapMin,gap-dec); %EQ.2-15
        end
    else
        R1=rand(numAgent,dim);
        R2=rand(numAgent,dim);
        R3=rand(numAgent,dim);
        Rn=rand(numAgent,dim);
        indexR1=ceil(rand(numAgent,dim)*numAgent);
        indexR2=ceil(rand(numAgent,dim)*numAgent);
        std0=exp(-20*iter/maxIteration)*(v_ub-v_lb)/2;
        std1=std(x_m); 
        % In order to use matrix operations, all individuals of the population are updated.
        % Although more individuals were updated, the running time of the algorithm dropped tremendously. 
        % This is because MATLAB is extremely good at matrix operations.
        % If you want to rewrite this code in another language, we suggest you refer to AFO1.
        % AFO2 is optimized for MATLAB and may not be suitable for your language.
        for j=1:dim
            x_m1(:,j)=x_m(indexR1(:,j),j);
            x_m2(:,j)=x_m(indexR2(:,j),j);
            y_m1(:,j)=y_m(indexR1(:,j));
            y_m2(:,j)=y_m(indexR2(:,j));
            AI(:,j)=R1(:,j).*sign(y_m1(:,j)-y_m2(:,j)).*(x_m1(:,j)-x_m2(:,j));
            if std1(j)<=std0(j)
                position=find(AI(:,j)==0);
                AI(position,j)=Rn(position,j)*(v_ub(j)-v_lb(j))/2;
                position=find(AI(:,j)~=0);
                AI(position,j)=R2(:,j).*sign(y_m1(:,j)-y_m2(:,j)).*sign(x_m1(:,j)-x_m2(:,j))*(v_ub(j)-v_lb(j))/2;
            end
        end
        for i=1:numAgent
            p =tanh(abs(y(i)-y_c)); %EQ.2-30
            if rand<p*(maxIteration-iter)/maxIteration
                % EQ 2-28
                At(i,:)=w2*At(i,:)+w4*R1(i,:).*(x_c-x(i,:))+w5*R2(i,:).*(x_m(i,:)-x(i,:));
                x(i,:)=x(i,:)+At(i,:); %EQ 2-29
                x(i,x(i,:)<lb)=lb(x(i,:)<lb);
                x(i,x(i,:)>ub)=ub(x(i,:)>ub);
                tempY(i,:)=y(i);
                y(i)=fobj(x(i,:));
                if tempY(i,:)<y(i)
                    for j=1:dim
                        r1=indexR1(i,j);
                        r2=indexR2(i,j);
                        v(i,j)=R3(i,j).*(x_m(r1,j)-x_m(r2,j))*-sign(y_m(r1)-y_m(r2));
                        if std1(j)<=std0(j)
                            if v(i,j)==0
                                v(i,j)=randn*(v_ub(j)-v_lb(j))/2;
                            else
                                v(i,j)=rand.*sign(x_m(r1,j)-x_m(r2,j))*-sign(y_m(r1)-y_m(r2))*(v_ub(j)-v_lb(j))/2;
                            end
                        end
                    end
                end
            else
                x(i,:)=x_c+AI(i,:);
                At(i,:)=AI(i,:);
                x(i,x(i,:)<lb)=lb(x(i,:)<lb);
                x(i,x(i,:)>ub)=ub(x(i,:)>ub);
                y(i)=fobj(x(i,:));
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
    %% ¸üÐÂ¼ÇÂ¼
    recording.bestFit(1+iter)=y_c;
    recording.meanFit(1+iter)=mean(y_m);
    %     recording.std(1+iter)=mean(std(x_m));
    %     recording.DC(1+iter)=norm(x_m-repmat(x_c,numAgent,1));
    %     recording.x1(1+iter,:)=x(1,:);
    iter=iter+1;
    %%
    if count>L
        for i=1:numAgent
            x(i,:)=(ub-lb)*rand+lb;
            y(i)=fobj(x(i,:));
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
        recording.bestFit(1+iter)=y_c;
        recording.meanFit(1+iter)=mean(y_m);
        iter=iter+1;
    end
end
bestY=y_c;
bestX=x_c;
end
%%
