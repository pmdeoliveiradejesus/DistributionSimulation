% Test case; Kersting NEV
% Kersting, W.H. A three-phase unbalanced line model with grounded neutrals
% through a resistance.  In Proceedings of the  2008 IEEE Power and Energy 
% Society General Meeting-PESGM, Pittsburgh, PA, USA, 20--24 July 2008; 
% pp.  12651-12652.
% Only two nodes, distance 1.13miles
function [db] = loaddatabase
global rf  S1a S1b S1c
global r1 pf1a pf1b pf1c L
global r3 db
global kVLN
L=6000;%feet
S1a=3000;
S1b=3500;
S1c=2500;
pf1a=0.9;
pf1b=0.95;
pf1c=0.85;
db(1)=L*0.000189393939;%L=section length miles
db(2)=0.0244;%GMRf=feet
db(3)=0.306;%rf=ohm/mile
db(4)=0.721/2;%RDf=inches
db(5)=0.00814;%GMRn=feet
db(6)=0.5920;%rn=ohm/mile
db(7)=0.563/2;%RDn=inches
db(8)=60;%f=Hz
db(9)=100;%rvd= soil resistivity (ohm-m)
db(10)=2.5;%Dab=feet
db(11)=4.5;%Dbc=feet
db(12)=7.0;%Dac=feet
db(13)=5;%Dcn=feet
db(14)=3;%Dn=feet
db(15)=4.272001872658765;%Dbn=feet
db(16)=5.656854249492381;%Dan=feet
db(17)=29;%hqa=feet
db(18)=29;%hqb=feet
db(19)=29;%hqc=feet
db(20)=25;%hqn=feet
db(20)=0.001*S1a*complex(pf1a,sqrt(1-pf1a^2));%S1a (MVA)
db(21)=0.001*S1b*complex(pf1b,sqrt(1-pf1b^2));%S1b (MVA)
db(22)=0.001*S1c*complex(pf1c,sqrt(1-pf1c^2));%S1c (MVA)
db(23)=500;%MVAsc3 
db(24)=500;%MVAsc1 
db(25)=3;%R1/X1
db(26)=3;%R0/X0
db(27)=12.47;%Nominal voltage (kV)
db(28)=0.5;% substation ground mat resistance (ohms)
db(29)=5.0;% grounding resistance at load (ohms)
db(30)=0.000001;% fault resistance (ohms)
kVLL=db(27);%Line to line nominal voltage
r1=db(28);%Grounding resistance at bus 1 (GSP)
r3=db(29);%Grounding resistance at bus 2 (Load) 
kVLN=kVLL/sqrt(3);%Line to neutral nominal voltage
rf=db(30);%Fault Resistance (ohms)
end




