function [S,Sabc,yl,ylabc,ylabcn] = demand(db)
global kVLN
Sabc=[db(20);db(21);db(22)];
S=sum(Sabc);
Rg2=db(29);%ohms
yl=(conj(S)/abs(kVLN)^2);% siemens 
ylabc=diag(conj(Sabc)./abs(kVLN)^2/3);% siemens 
ylabcn=ylabc;
ylabcn(4,1)=-ylabcn(1,1);% siemens
ylabcn(4,2)=-ylabcn(2,2);% siemens
ylabcn(4,3)=-ylabcn(3,3);% siemens
ylabcn(1,4)=-ylabcn(1,1);% siemens
ylabcn(2,4)=-ylabcn(2,2);% siemens
ylabcn(3,4)=-ylabcn(3,3);% siemens
ylabcn(4,4)=inv(Rg2)-ylabcn(4,1)-ylabcn(4,2)-ylabcn(4,3);% siemens 
ylabcn=ylabcn*1;
end