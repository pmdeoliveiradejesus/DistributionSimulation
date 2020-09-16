% Power Distribution Systems Workshop
% Two bus Kersting test case 
% [1] W.H. Kersting, "A three-phase unbalanced line model with grounded neutrals through
% a resistance," In Proc. IEEE PESGM'08, 208, pp. 1-7.
% [2] Kersting, W. H. (2018). Distribution System Modeling and Analysis. CRC Press.
% -----------------------------------
% Prof. Paulo M. De Oliveira D.
% pm.deoliveiradejes@uniandes.edu.co
% (c) 2020
% Main powerflow and short circuit programs
% -----------------------------------
clear all
clc 
global kVLN
global Y
global S
global Sabc
global yshabcn 
global ygabcn 
global ylabcn 
global YbusO
global rf 
global r1 
global r3
[db] = loaddatabase; %Load database
kVLL=db(27);%Line to line nominal voltage
r1=db(28);%Groundingnce at bus 1 (GSP)
r3=db(29);%Grounding resistance at bus 2 (Load) 
kVLN=kVLL/sqrt(3);%Line to neutral nominal voltage
rf=0.0001;%Fault Resistance
[zgabc,ygabcn,zg012] = generation(db);  %Generation network model 
[zabc,zabcn,yshabc,yshabcn,z012,ysh012] = networkk(db); %Network model
[S,Sabc,yl,ylabc,ylabcn] = demand(db); % Load demand model 
% Power flow analysis
[V1,I1,losses(1),iter1]=zimplicit_1(zg012,z012,S);%The simplest power-flow(z-implicit)
[V2,I2,losses(2),iter2]=OpenDSS_1(zg012,z012,S,yl,ysh012);%OpenDSS Engine
[V3,I3,losses(3),iter3]=Newton_1(zg012,z012,S,ysh012);%Newton method
[V4,I4,losses(4),iter4]=NewtonRaphson_1(zg012,z012,S,ysh012);%Newton-Rhapson method
[V5,I5,losses(5),iter5]=zimplicit_3(zgabc,zabc,Sabc);%The simplest power-flow(z-implicit) 
[V6,I6,losses(6),iter6]=Newton_3(zgabc,zabc,Sabc,yshabc);% Newton method
[V7,I7,losses(7),iter7]=OpenDSS_3(zgabc,zabc,Sabc,ylabc,yshabc);% OpenDSS z-implict 
[V8,I8,losses(8),iter8]=OpenDSS_4(ygabcn,zabcn,Sabc,ylabcn,yshabcn);% OpenDSS z-implict 
[V9,I9,losses(9),iter9]=OpenDSS_4_fsolve(ygabcn,zabcn,Sabc,ylabcn,yshabcn);% OpenDSS Newton 
% Short circuit analysis
[Icc3,Icc1]=shortcircuit(z012,zg012);%Short-circuit analysis (sequence nets)
[V10,I10]=OpenDSS_4_short1a(ygabcn,zabcn,Sabc,ylabcn,yshabcn);% OpenDSS Newton 
[V11,I11]=OpenDSS_4_short3(ygabcn,zabcn,Sabc,ylabcn,yshabcn);% OpenDSS Newton 
losses.'