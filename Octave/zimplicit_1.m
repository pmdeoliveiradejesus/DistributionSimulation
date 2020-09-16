% Z implict power flow method
%
%      0        1        2 
% kVLL |---zg---|---z----|--->S
%
function [V,I,losses,iter]=zimplicit_1(zg012,z012,S)
global kVLN
v0=kVLN; %initialize v2=kVLL (nominal value)
v2=v0;
e=1;econv=0.000001;k=1;
while e>econv
v2old=v2;
v2=v0+(z012(2,2)+zg012(2,2))*conj(-S/(3*v2));
k=k+1;
e=abs(v2-v2old);
end
i2=conj(-S/(3*v2));%A inzjected current at bus 2
iter=k;
v1=v0+i2*zg012(2,2);%kV
V=[v1;v2];%kV
I=[-i2;i2];%A
losses=sum(3*V.*conj(I))*1000;%kW+jkvar
% verifying that
Ybus=[ inv(z012(2,2)) -inv(z012(2,2)); 
      -inv(z012(2,2))  inv(z012(2,2))];
%I-Ybus*V;
Y=[   inv(zg012(2,2)) -inv(zg012(2,2)) 0;
     -inv(zg012(2,2))  inv(zg012(2,2))+inv(z012(2,2)) -inv(z012(2,2));
      0               -inv(z012(2,2)) inv(z012(2,2))];
Vx=[kVLN;v1;v2];%kV
Ix=[-i2;0;i2];%A
      Ix-Y*Vx;
      end