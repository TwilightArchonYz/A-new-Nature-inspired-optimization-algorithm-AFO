# A-new-nature-inspired-optimization-algorithm-AFO
A new nature-inspired optimization algorithm: Aptenodytes Forsteri Optimization algorithm (AFO)  
%%--------------------------------------------%%

Paper

Yang Z, Deng L B, Wang Y, et al. Aptenodytes Forsteri Optimization: Algorithm and applications[J]. Knowledge-Based Systems, 2021, 232: 107483.

%%--------------------------------------------%%

更新日志 Updating Log

2022.3.25 

Version 1.3

It is experimentally found that the gradient estimation strategy is less efficient in most cases. Here the replacement is Gaussian perturbation with a perturbation step of x_c the average distance from x

x_new=x_c+Rn*(x_r1-x_r2).*Dm

where x_new is the new individual position; Rn is a 1xN matrix of random numbers obeying normal distribution; x_r1 and x_r2 are the positions of the r1st and r2nd penguins in the population, r1 and r2 are randomly generated, and Dm is the average distance of x_c from all penguins in the population in each dimension, a 1xN matrix.

Ps：Perturbation step of x_c distance x_m is also a good choice, interested in their own experiments.

实验发现，在大多数情况下，梯度估计策略的效率较低。这里的替换是高斯扰动，扰动步长为x_c，与x的平均距离为x

x_new=x_c+Rn*(x_r1-x_r2).*Dm

其中，x_new是新个体位置; Rn是一个1xN的随机数矩阵，服从正态分布; x_r1和x_r2是种群中第r1和第r2只企鹅的位置，r1和r2随机生成，Dm是x_c距离种群中所有企鹅在每一个维度上的平均距离，是一个1xN的矩阵。

注：可以讲基准参考从当前企鹅位置X替换为企鹅记忆中最优位置X_m.

%%--------------------------------------------%%  
这里有两个文件夹，一个是AFO在标准测试集上的实验的代码，一个是AFO在一些实际问题上的应用  
除去论文提到的四个工业设计问题，还有其他问题再该集合当中，具体目录如下  
（1）论文中提及的四种带约束的工业设计问题  
（2）优化神经网络的权值和阈值  
（3）航空调度-多扇区  
（4）柔性车间调度  
（5）栅格地图-机器人寻路  
（6）物流中心选址问题：工厂-中心-需求点  
（7）多行车间调度-考虑AVG分区  
（8）石油厂区-无人机路径规划  
（9）基于潮流计算的电力系统总线优化  
（10）某乳制品企业冷链配送物流车辆调度优化研究  
（11）面向6R工业机器人等离子加工轨迹规划  
（12）TSP问题及其变种问题  
注意：  
（1）所有代码使用matlab2021a编写，但matlab 2021a和之前版本可能存在兼容问题，有可能出现乱码。如果乱码，使用txt打开，再将txt中的代码复制到.m文件当中  
（2）后续会添加AFO的改进算法，以及更多的应用案例。本实验室参与并完成了各类基于群智能优化的应用项目数百例，涉及电力系统，车间调度，物流配送，选址布局，无人机路径规划、机器人路径规划，复杂网络优化，资源调度，优化各类机器学习算法等各个方向。本实验室会继续挑选经典案例添加到本代码集合当中，请及时关注。如果需要某个方向的代码，可以留言或者邮箱联系。  
（3）本实验室发表过大量高水平改进算法，会陆续添加到本代码集中，请多多关注。  
  
There are two folders, one for the code of AFO experiments on the standard test set and one for the application of AFO to some practical problems  
In addition to the four industrial design problems mentioned in the thesis, there are other problems in the collection, which are listed below  
(1) The four industrial design problems with constraints mentioned in the paper  
(2) Optimising the weights and thresholds of neural networks  
(3) Aviation scheduling: multi-sector  
(4) Flexible workshop scheduling  
(5) Raster maps: robot pathfinding  
(6) Logistics centre location problem: factory-centre-demand point  
(7) Multi-row shop floor layout considering AVG partitioning   
(8) Oil plants: UAVs for path planning  
(9) Power system bus optimization based on tide calculation  
(10) Optimization study of cold chain distribution logistics vehicle scheduling for a dairy company  
(11) Plasma processing trajectory planning for 6R industrial robots  
(12) TSP problem and its variant problems  
  
Notes.  
(1) All code is written using matlab 2021a, but there may be compatibility problems between matlab 2021a and previous versions, and garbled codes may appear. If the code is garbled, use txt to open it and copy the code from txt to .m file  
(2) Improved algorithms for AFO will be added later, as well as more application examples. The lab has participated in and completed hundreds of applications based on swarm intelligence, including power systems, workshop scheduling, logistics and distribution, site layout, UAV path planning, robot path planning, complex network optimisation, resource scheduling, optimisation of various machine learning algorithms and other directions. The lab will continue to select classic cases to add to this code collection, so please stay tuned. If you need code for a particular direction, please leave a message or contact us by email.  
(3) Our lab has published a large number of high-level improvement algorithms, which will be added to this code collection one after another, so please pay attention to them.  
%%--------------------------------------------%%  
Copy right    
你可以免费使用本代码库中的所有代码，但是请注明出处并引用相关的参考文献。  
You are free to use all the code in this code base, but please give credit and cite the relevant references.  
%%--------------------------------------------%%  
作者：杨喆  
邮箱：454170989@qq.com  
学校：英国曼彻斯特大学
Author：Yang Zhe  
E-mail: 454170989@qq.com  
School: University of Manchester, UK
%%--------------------------------------------%%  
逍遥一世  
人生如梦未醒时，一半年华皆梦中。  
自言行乐朝朝是，岂料浮生渐渐忙。  
年年九陌看春还，旧隐空劳梦寐间。  
弥起长恨欢娱少，繁星闪烁度华年。  
浮生未歇几时欢，心系虚妄怎逍遥。  

人心多是少相投，非识尘中上品流。  
人是人非意颇同，较量此事尽归空。  
无为政化求真理，方表深仁大道雄。  
铸鼎铭钟封爵邑，功名让与英雄立。  
浮生聚散是浮萍，何须日夜苦蝇营。  

笑看沧海欲成尘，王母花前别众真。  
千岁却归天上去，一心珍重世间人。  
直上五云云路稳，紫鸾朱凤自来迎。  
人间天上尽修行，七宝山高混太清。  
自觉浮生幻化事，逍遥快乐实善哉。  
  
         ——逍遥浮世，与道俱成    
%%--------------------------------------------%%  
[![View A-new-Nature-inspired-optimization-algorithm-AFO on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://ww2.mathworks.cn/matlabcentral/fileexchange/85700-a-new-nature-inspired-optimization-algorithm-afo)
