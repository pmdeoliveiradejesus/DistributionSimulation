% Z implict power flow method (three phase approach)
% without shunts
%      0        1        2 
% kVLL |---zg---|---z----|--->S
%
function [V,I,losses,iter]=zimplicit_3(zgabc,zabc,Sabc)
global kVLN
a=-0.5+j*sqrt(3)*.5;
v0=[kVLN;kVLN*a^2;kVLN*a]; %initialize v2=kVLL pos. seq. (nominal value)
v2=v0;
e=1;econv=0.000001;k=1;
while e>econv
v2old=v2;
v2=v0+(zabc+zgabc)*conj(-Sabc./(v2));
k=k+1;
e=max(abs(v2-v2old));
end
i2=conj(-Sabc./(v2));%A inzjected current at bus 2
iter=k;
v1=v0+zgabc*i2;%kV
V=[v1;v2];%kV
abs(V);
I=[-i2;i2];%A

abs(I)*1000;
losses=sum(V.*conj(I))*1000; %kW+jkvar
 %verifying that
Ybus=[ inv(zabc),-inv(zabc); 
      -inv(zabc),inv(zabc)];
I-Ybus*V;
Y=[   inv(zgabc), -inv(zgabc), zeros(3,3);
     -inv(zgabc),  inv(zgabc)+inv(zabc), -inv(zabc);
      zeros(3,3),             -inv(zabc), inv(zabc)];
Vx=[v0;v1;v2];%kV
Ix=[-i2;zeros(3,1);i2];%A
      Ix-Y*Vx;
      Vx(4)*conj(Ix(1))+Vx(5)*conj(Ix(2))+Vx(6)*conj(Ix(3))+...
      Vx(7)*conj(Ix(7))+...
      Vx(8)*conj(Ix(8))+...
      Vx(9)*conj(Ix(9));
      end