%% Main powerflow and short circuit program
%% STRA5432 - Power System Simulation
%% Prof. Paulo M. De Oliveira De jesus
%% v.1.0
%%=========================================
clear all
clc 
global IccR YbusO Icomp I Ypaulo V  kVLN
global S  db
global Sabc
global yshabcn 
global ygabcn 
global ylabcn 
global YbusO
%% Data input 
[db] = loaddatabase; %Load database
% System Modelling routines
[zgabc,ygabcn,zg012] = generation(db);  %Generation network model 
[zabc,zabcn,yshabc,yshabcn,z012,ysh012] = networkk(db); %Network model
[S,Sabc,yl,ylabc,ylabcn] = demand(db); % Load demand model 
% Power flow analysis
%[V1,I1,losses(1),iter1]=zimplicit_1(zg012,z012,S)%The z-implicit power flow
%[V2,I2,losses(2),iter2]=OpenDSS_1(zg012,z012,S,yl,ysh012);%OpenDSS Engine
%[V3,I3,losses(3),iter3]=Newton_1(zg012,z012,S,ysh012);%Newton method
%[V4,I4,losses(4),iter4]=NewtonRaphson_1(zg012,z012,S,ysh012);%Newton-Rhapson
%[V5,I5,losses(5),iter5]=zimplicit_3(zgabc,zabc,Sabc);
%[V6,I6,losses(6),iter6]=Newton_3(zgabc,zabc,Sabc,yshabc);
% [V7,I7,losses(7),iter7]=OpenDSS_3(zgabc,zabc,Sabc,ylabc,yshabc)
% [V8,I8,losses(8),iter8]=OpenDSS_4(ygabcn,zabcn,Sabc,ylabcn,yshabcn);
% [V9,I9,losses(9),iter9]=OpenDSS_4_fsolve(ygabcn,zabcn,Sabc,ylabcn,yshabcn);
 [V10,I10,losses(10),iter10]=OpenDSS_COM_4(Sabc,zgabc,yshabcn);
%%%losses.';
%% Short circuit analysis
%[Icc3,Icc1]=shortcircuit(z012,zg012);%Short-circuit 1ph 3ph (sequence nets)
%[V1c,I2c]=OpenDSS_4_short1a(ygabcn,zabcn,Sabc,ylabcn,yshabcn);% Detailed 1ph
%[V2c,I2c]=OpenDSS_4_short3(ygabcn,zabcn,Sabc,ylabcn,yshabcn);%Detailed 3ph
% [abs(V8) abs(V9) abs(V10)]
% [abs(I8) abs(I9) abs(I10)]
% [losses(8) losses(9) losses(10)]

