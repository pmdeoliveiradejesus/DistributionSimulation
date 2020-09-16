% OpenDSS power flow method - Positive Sequence
%
%      0        1        2 
% kVLL |---zg---|---z----|--->S
%
function [V,I,losses,iter]=OpenDSS_1(zg012,z012,S,yl,ysh012)
global kVLN  
 YbusO(1,1)=inv(zg012(2,2))+inv(z012(2,2)); %Build an extended Ybus
 YbusO(2,2)=yl+inv(z012(2,2));
 YbusO(1,2)=-inv(z012(2,2));
 YbusO(2,1)=-inv(z012(2,2));
% guess initial voltages at bus loads
V=[kVLN;kVLN];
e=1;econv=0.000001;k=1;
while e>econv
%for k=1:14
ic1=inv(zg012(2,2))*kVLN-V(1)*ysh012(2,2)*.5;
ic2=conj(-S/(3*V(2)))+V(2)*yl-V(2)*ysh012(2,2)*.5;% compensation injected currents at bus loads
Vx=inv(YbusO)*[ic1;ic2];
e=max(abs(V-Vx));
V=Vx;
k=k+1;
%end
end
iter=k;
i2=conj(-S/(3*V(2)));%An injected current at bus 2
i1=-i2;
I=[i1;i2];%A
losses=sum(3*V.*conj(I))*1000;%kW+jkvar
% verifying that
Ybus=[ inv(z012(2,2))+ysh012(2,2)*.5 -inv(z012(2,2)); 
      -inv(z012(2,2))  inv(z012(2,2))+ysh012(2,2)*.5];
I-Ybus*V;
Y=[   inv(zg012(2,2)) -inv(zg012(2,2)) 0;
     -inv(zg012(2,2))  inv(zg012(2,2))+inv(z012(2,2))+ysh012(2,2)*.5 -inv(z012(2,2));
      0               -inv(z012(2,2)) inv(z012(2,2))+ysh012(2,2)*.5];
Vx=[kVLN;V(1);V(2)];%kV
Ix=[-i2;0;i2];%A
%      Ix-Y*Vx
end


