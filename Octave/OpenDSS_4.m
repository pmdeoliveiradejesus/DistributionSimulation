% OpenDSS power flow method - 4 wire
%
%      0        1        2 
% kVLL |---zg---|---z----|--->S
%
function [V,Iwide,losses,iter]=OpenDSS_4(ygabcn,zabcn,Sabc,ylabcn,yshabcn)
global kVLN db
global r1 
global r3 YbusO Icomp I Y V 
a=-0.5+j*sqrt(3)*.5;
Sabc(4)=0;
V0=[kVLN;kVLN*a^2;kVLN*a;0]; %initialize v2=kVLL pos. seq. (nominal value)
YbusO=[ygabcn+inv(zabcn),-inv(zabcn);
 -inv(zabcn),ylabcn+inv(zabcn)];%Build an extended Ybus
% guess initial voltages at bus loads
V1=V0;
V2=V0;
e=1;econv=0.0001;k=1;
while e>econv
%for k=1:14
ic1=ygabcn*V0-0.5*yshabcn*V1;
        i2(1,1)  =conj(-Sabc(1)/(V2(1,1)-V2(4,1)));% compensation injected currents at bus loads
        i2(2,1)=conj(-Sabc(2)/(V2(2,1)-V2(4,1)));% compensation injected currents at bus loads
        i2(3,1)=conj(-Sabc(3)/(V2(3,1)-V2(4,1)));% compensation injected currents at bus loads
        i2(4,1)=-i2(1,1)-i2(2,1)-i2(3,1)-V2(4)/(r3);
    ic2= i2 + ylabcn*V2-0.5*yshabcn*V1;
Vx=inv(YbusO)*[ic1;ic2];
Iccmp=[ic1;ic2];
e=max(abs([V1;V2]-Vx));
V1=[Vx(1,1);Vx(2,1);Vx(3,1);Vx(4,1)];
V2=[Vx(5,1);Vx(6,1);Vx(7,1);Vx(8,1)];
k=k+1;
%end
end
ic1=ygabcn*V0-0.50*yshabcn*V1;
        i2(1,1)  =conj(-Sabc(1)/(V2(1,1)-V2(4,1)));% compensation injected currents at bus loads
        i2(2,1)=conj(-Sabc(2)/(V2(2,1)-V2(4,1)));% compensation injected currents at bus loads
        i2(3,1)=conj(-Sabc(3)/(V2(3,1)-V2(4,1)));% compensation injected currents at bus loads
        i2(4,1)=-i2(1,1)-i2(2,1)-i2(3,1)-V2(4)/(r3);
    ic2= i2 + ylabcn*V2-0.50*yshabcn*V1;
Vx=inv(YbusO)*[ic1;ic2];
Icomp=[ic1;ic2];
V=[V1;V2];
iter=k;
%i2=conj(-Sabc./V2);%An injected current at bus 2
i1=-i2+1*yshabcn*V2;
I=[i1;i2];%kA
i1res=(-sum(i1));
i2res=(-sum(i2));
Iwide=[i1;i1res;i2;i2res];%A
losses=sum([V].*conj([I]))*1000;%kW+jkvar
% verifying that
Y=[ inv(zabcn)+yshabcn*.5 -inv(zabcn); 
      -inv(zabcn)  inv(zabcn)+yshabcn*.5];
Y(9,:)=-Y(1,:)-Y(2,:)-Y(3,:);
Y(10,:)=-Y(5,:)-Y(6,:)-Y(7,:);
Y(9,4)=Y(9,4)-inv(r1);
Y(10,8)=Y(10,8)-inv(r3);
I(9)=I(4);
I(10)=I(8);   
end




