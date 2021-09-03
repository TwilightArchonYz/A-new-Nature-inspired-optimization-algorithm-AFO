%% 2020.11.30 µÛÆó¶ìËã·¨  Æ½ÒÆºóµÄ±ê×¼²âÊÔº¯Êý
% µÛÆó¶ìËã·¨ÔÚÆ½ÒÆºóµÄ±ê×¼²âÊÔº¯ÊýÉÏµÄÊµÑé
% AFO on shifted classcial benchmark functions
clc;
clear;
close all;
warning off
%%
rng('default')
%% Ñ¡Ôñ²âÊÔº¯Êý
addpath('code');
global option
option.no=3; %µÚ15¸ö²âÊÔº¯Êý
option.F=['F',num2str(option.no)];
[lb,ub,dim,fobj] = Get_Functions_details(option.F);
option.lb=lb;
option.ub=ub;
option.dim=dim;
if length(option.lb)==1
    option.lb=ones(1,option.dim)*option.lb;
    option.ub=ones(1,option.dim)*option.ub;
end
option.fobj0=fobj;
option.fobj=@fitFCN_BX;
option.showIter=0;

%% Ëã·¨²ÎÊýÉèÖÃ Parameters 
option.repeatNum=10; % Number of repetitions of the test
% »ù±¾²ÎÊý
option.numAgent=200;        %ÖÖÈº¸öÌåÊý size of population
option.maxIteration=50;    %×î´óµü´ú´ÎÊý maximum number of interation
% µÛÆó¶ìËã·¨
option.v_lb=-(option.ub-option.lb)/4;
option.v_ub=(option.ub-option.lb)/4;
option.w2=0.5; %weight of Moving strategy III
option.w4=1;%weight of Moving strategy III
option.w5=1;%weight of Moving strategy III
option.pe=0.01; % rate to judge Premature convergence
option.gap0=ceil(sqrt(option.maxIteration*2))+1;
option.gapMin=5; % min gap
option.dec=2;    % dec of gap
option.L=10;     % Catastrophe
data=[];
str_legend=[{'AFO1'},{'AFO2'}];
for ii=1:option.repeatNum
    ii
    rng(ii)
    %% shift classcial benchmark functions
    option.RateB1=0.6; %Bound of Shift in x space
    option.RateB2=0.3; %Bound of Shift in x space
    temp1=rand(1,option.dim).*(option.RateB1-option.RateB2).*option.ub+option.RateB2.*option.ub;
    temp2=rand(1,option.dim).*(option.RateB1-option.RateB2).*option.lb+option.RateB2.*option.lb;
    tempR=rand(1,option.dim);
    if lb==0
        option.XB=temp1;
    elseif ub==0
        option.XB=temp2;
    else
        option.XB=zeros(1,option.dim);
        option.XB(tempR>0.5)=temp1(tempR>0.5);
        option.XB(tempR<0.5)=temp2(tempR<0.5);
    end
    option.XB=-option.XB;
    %% Initialize population individuals (common to control experiment algorithm)
    x=ones(option.numAgent,option.dim);
    y=ones(option.numAgent,1);
    for i=1:option.numAgent
        x(i,:)=rand(size(option.lb)).*(option.ub-option.lb)+option.lb;
        y(i)=option.fobj(x(i,:),option,data);
    end
    %% Ê¹ÓÃËã·¨Çó½â
    % Based on the same population, solve the selected benchmarks functions by using different algorithms
    bestX=x;
    rng(ii)
    tic
    [bestY(1,:),bestX(1,:),recording(1)]=AFO1(x,y,option,data);
    tt(ii,1)=toc;
    rng(ii)
    tic
    [bestY(2,:),bestX(2,:),recording(2)]=AFO2(x,y,option,data);
    tt(ii,2)=toc;
    for i=1:length(recording)
        recordingCruve{i}(ii,:)=recording(i).bestFit;
        recordingY(i,ii)=bestY(i,:);
    end
end
%% Cruve
figure
hold on
for i=1:length(recording)
    if i>=8
        plot(mean(recordingCruve{i}),'LineWidth',2)
    else
        plot(mean(recordingCruve{i}),'--','LineWidth',2)
    end
end
legend(str_legend)
%% Cruve based log
figure
hold on
for i=1:length(recording)
    if i >=8
        plot(log(mean(recordingCruve{i})),'LineWidth',2)
    else
        plot(log(mean(recordingCruve{i})),'-.','LineWidth',2)
    end
end
legend(str_legend)
%% »ã×Ü½á¹û Aggregate results
meanY=mean(recordingY');
stdY=std(recordingY');
minY=min(recordingY');
maxY=max(recordingY');
maeY=mean(abs(recordingY'-meanY));
runningT=mean(tt(2:end,:));
%% »æÖÆº¯ÊýÍ¼Ïñ Plotting function images
option.F=['F',num2str(option.no)];
figure
func_plot(option.F)
