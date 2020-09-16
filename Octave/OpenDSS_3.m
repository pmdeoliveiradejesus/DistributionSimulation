% OpenDSS power flow method - Positive Sequence
%
%      0        1        2 
% kVLL |---zg---|---z----|--->S
%
function [V,Iwide,losses,iter]=OpenDSS_3(zgabc,zabc,Sabc,ylabc,yshabc)
global kVLN
a=-0.5+j*sqrt(3)*.5;
V0=[kVLN;kVLN*a^2;kVLN*a]; %initialize v2=kVLL pos. seq. (nominal value)
  
YbusO=[inv(zgabc)+inv(zabc),-inv(zabc);
 -inv(zabc),ylabc+inv(zabc)];%Build an extended Ybus
% guess initial voltages at bus loads
V1=V0;
V2=V0;
e=1;econv=0.000001;k=1;
while e>econv
%for k=1:14
ic1=inv(zgabc)*V0-0.5*yshabc*V1;
ic2=conj(-Sabc./V2)+ylabc*V2-0.5*yshabc*V2;% compensation injected currents at bus loads
Vx=inv(YbusO)*[ic1;ic2];
e=max(abs([V1;V2]-Vx));
V1=[Vx(1,1);Vx(2,1);Vx(3,1)];
V2=[Vx(4,1);Vx(5,1);Vx(6,1)];
k=k+1;
%end
end
V=[V1;V2];
iter=k;
i2=conj(-Sabc./V2);%An injected current at bus 2
i1=-i2+0*yshabc*V2;
I=[i1;i2];%A
i1res=(-sum(i1));
i2res=(-sum(i2));
Iwide=[i1;i1res;i2;i2res];%A
losses=sum([V].*conj([I]))*1000;%kW+jkvar
% verifying that
Ybus=[ inv(zabc)+yshabc*.5 -inv(zabc); 
      -inv(zabc)  inv(zabc)+yshabc*.5];
I-Ybus*V;
end


