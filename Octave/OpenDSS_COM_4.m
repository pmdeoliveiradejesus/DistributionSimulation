% OpenDSS power flow method - 4 wire  COM Interface
%
%      0        1        2 
% kVLL |---zg---|---z----|--->S
%
function [V8x,I8x,losses,iter]=OpenDSS_COM_4(Sabc,zgabc,yshabcn)
global kVLN L db
global S1a S1b S1c
global pf1a pf1b pf1c
DSSObj = actxserver('OpenDSSEngine.DSS');
if ~DSSObj.Start(0)
disp('Unable to start the OpenDSS Engine');
return
end
DSSObj.ActiveCircuit.Solution.Solve()
DSSText = DSSObj.Text; % Used for all text interfacing from matlab to opendss
DSSCircuit = DSSObj.ActiveCircuit; % active circuit
% Write Path where Master and its associated files are stored and compile as per following command
%DSSText.Command='Compile (C:\Users\VaioPC\OpenDSSTutorial\ODOCR_ANSI67N\GridModel.dss)';
DSSText.Command='clear';
%DSSText.Command='New Vsource.SOURCE_3 bus1=n1.3  bus2=n1.4 basekV=7.1996 pu=1 angle=120 Z1=[0.0983474,0.2950422133]  phase=1';
DSSText.Command=strcat('New circuit.SOURCE_1 bus1=n1.1  bus2=n1.4 basekV=',num2str(kVLN),' pu=1 angle=0  Z1=[',num2str(real(zgabc(1,1))),',',num2str(imag(zgabc(1,1))),']   phase=1');
DSSText.Command=strcat('New Vsource.SOURCE_2 bus1=n1.2  bus2=n1.4 basekV=',num2str(kVLN),' pu=1 angle=-120 Z1=[',num2str(real(zgabc(2,2))),',',num2str(imag(zgabc(2,2))),']   phase=1');
DSSText.Command=strcat('New Vsource.SOURCE_3 bus1=n1.3  bus2=n1.4 basekV=',num2str(kVLN),' pu=1 angle=120  Z1=[',num2str(real(zgabc(3,3))),',',num2str(imag(zgabc(3,3))),']   phase=1');
DSSText.Command='set earthmodel=carson';
DSSText.Command=strcat('new wiredata.conductor Runits=mi Rac=',num2str(db(3)),' GMRunits=ft GMRac=',num2str(db(2)),' Radunits=in Diam=',num2str(2*db(4)), '  ');
DSSText.Command=strcat('new wiredata.neutral Runits=mi Rac=',num2str(db(6)),' GMRunits=ft GMRac=',num2str(db(5)),' Radunits=in Diam=',num2str(2*db(7)), '  ');
DSSText.Command='new linegeometry.4wire nconds=4 nphases=3 reduce=no ';
DSSText.Command='~ cond=1 wire=conductor units=ft x=-4   h=28';
DSSText.Command='~ cond=2 wire=conductor units=ft x=-1.5 h=28'; 
DSSText.Command='~ cond=3 wire=conductor units=ft x=3    h=28'; 
DSSText.Command='~ cond=4 wire=neutral   units=ft x=0    h=24'; 
DSSText.Command=strcat('new line.line1 geometry=4wire length=',num2str(L),' units=ft bus1=n1.1.2.3.4 bus2=n2.1.2.3.4 Rho=100');
DSSText.Command=strcat('New Load.load1a.1 Phases=1  Bus1=n2.1.4   kVA=',num2str(S1a),' pf=',num2str(pf1a),'  kV=12.47 conn=wye  vminpu=0.1 vmaxpu=1.9');
DSSText.Command=strcat('New Load.load1b.2 Phases=1  Bus1=n2.2.4   kVA=',num2str(S1b),' pf=',num2str(pf1b),'  kV=12.47 conn=wye  vminpu=0.1 vmaxpu=1.9');
DSSText.Command=strcat('New Load.load1c.3 Phases=1  Bus1=n2.3.4   kVA=',num2str(S1c),' pf=',num2str(pf1c),' kV=12.47 conn=wye  vminpu=0.1 vmaxpu=1.9');
DSSText.Command='New Reactor.Load1Ground Phases=1 Bus1=n2.4 Bus2=n2.0 R=5 X=0';
DSSText.Command='New Reactor.SourceGround Phases=1 Bus1=n1.4 Bus2=n1.0 R=.5 X=0';
DSSText.Command='set voltagebases=[12.47]'; 
DSSText.Command='calcvoltagebases     ! **** let DSS compute voltage bases';
% DSSText.Command='New Fault.faseA   Phases=1  Bus1=n2.1  Bus2=n2.4 R=.000001';
% DSSText.Command='New Fault.faseB   Phases=1  Bus1=n2.2  Bus2=n2.4 R=.000001';
% DSSText.Command='New Fault.faseC   Phases=1  Bus1=n2.3  Bus2=n2.4 R=.000001';
%DataPath='C:\Users\VaioPC\Dropbox (Uniandes)\UNIANDES\Docencia Uniandes\2020_20\STRA-5432 2020_20\STRA5432 - Workshop 2020\Octave';
DSSText.Command='CD [C:\Users\VaioPC\OneDrive - Universidad de Los Andes\DistributionSimulation\Octave]';
DSSText.Command='solve';
DSSText.Command='Export Yprims';
MM=csvread('SOURCE_1_EXP_YPRIM.CSV',1,2);
isconverged = DSSCircuit.Solution.converged
DSSSolution = DSSCircuit.Solution;
n = length(DSSCircuit.AllNodeNames);
ineven=2:2:2*n;
inodd=1:2:(2*n-1);
YbusX=DSSCircuit.SystemY;
%YbusP=DSSCircuit.Yprim;
Ya=reshape(YbusX,2*n,n)';
YopenDSS=Ya(:,inodd)+Ya(:,ineven)*sqrt(-1);
YopenDSS2=YopenDSS(:,[1 3 4 2 5 6 7 8]);
YopenDSS3=YopenDSS2([1 3 4 2 5 6 7 8],:);

 DSSCircuit.AllElementNames;
%Ysparse = sparse(YopenDSS3);
% AllBuses=DSSCircuit.AllBusNames;
% for i= 1:DSSCircuit.NumBuses
% %DSSCircuit.SetActiveBus(AllBuses(i)); %sets active bus
% N_nodes(i) = DSSBus.NumNodes; %DSSBus points to active bus
% end

% Vxx = DSSCircuit.AllBusVolts;
% V3 = DSSCircuit.YNodeVarray;
DSSLines = DSSObj.ActiveCircuit.Lines;
DSSActiveCktElement = DSSObj.ActiveCircuit.ActiveCktElement;
i = DSSCircuit.Lines.First;
while i > 0
Iarray(i,:) = DSSActiveCktElement.Currents;
i  = DSSCircuit.Lines.Next;
end
j=1;
for k=1:2:length(Iarray)/2
I8x(j,1)=complex(Iarray(k),Iarray(k+1))/1000;
j=j+1;
end
I8x(j,1)=-I8x(1,1)-I8x(2,1)-I8x(3,1)-I8x(4,1);
j=j+1;
for k=9:2:length(Iarray)
I8x(j,1)=complex(Iarray(k),Iarray(k+1))/1000;
j=j+1;
end
I8x(j)=-I8x(6,1)-I8x(7,1)-I8x(8,1)-I8x(9,1);

i = DSSCircuit.Lines.First;
while i > 0
Varray(i,:) = DSSActiveCktElement.Voltages;
i  = DSSCircuit.Lines.Next;
end

j=1;
for k=1:2:length(Varray)/2
V8x(j,1)=complex(Varray(k),Varray(k+1))/1000;
j=j+1;
end
for k=9:2:length(Varray)
V8x(j,1)=complex(Varray(k),Varray(k+1))/1000;
j=j+1;
end

ygabcnx(1,1)=complex(MM(2,1),MM(2,2));
ygabcnx(1,4)=-ygabcnx(1,1);
ygabcnx(4,1)=-ygabcnx(1,1);
ygabcnx(2,2)=complex(MM(5,1),MM(5,2));
ygabcnx(2,4)=-ygabcnx(2,2);
ygabcnx(4,2)=-ygabcnx(2,2);
ygabcnx(3,3)=complex(MM(8,1),MM(8,2));
ygabcnx(3,4)=-ygabcnx(3,3);
ygabcnx(4,3)=-ygabcnx(3,3);
ygabcnx(4,4)=1/.5+ygabcnx(1,1)+ygabcnx(2,2)+ygabcnx(3,3);

rr=18;
 ylabcnx(1,1)=complex(MM(2+rr,1),MM(2+rr,2));
 ylabcnx(1,4)=- ylabcnx(1,1);
 ylabcnx(4,1)=- ylabcnx(1,1);
 ylabcnx(2,2)=complex(MM(5+rr,1),MM(5+rr,2));
 ylabcnx(2,4)=- ylabcnx(2,2);
 ylabcnx(4,2)=- ylabcnx(2,2);
 ylabcnx(3,3)=complex(MM(8+rr,1),MM(8+rr,2));
 ylabcnx(3,4)=- ylabcnx(3,3);
 ylabcnx(4,3)=- ylabcnx(3,3);
 ylabcnx(4,4)=1/5+ ylabcnx(1,1)+ ylabcnx(2,2)+ ylabcnx(3,3);
a=complex(-0.5,sqrt(3)*.5);
V0=[kVLN;kVLN*a^2;kVLN*a;0];
ic1x=ygabcnx*V0-0.5*yshabcn*[V8x(1,1);V8x(2,1);V8x(3,1);V8x(4,1)];
        i2x(1,1) =conj(-Sabc(1)/(V8x(5,1)-V8x(8,1)));% compensation injected currents at bus loads
        i2x(2,1)=conj(-Sabc(2)/(V8x(6,1)-V8x(8,1)));% compensation injected currents at bus loads
        i2x(3,1)=conj(-Sabc(3)/(V8x(7,1)-V8x(8,1)));% compensation injected currents at bus loads
        i2x(4,1)=-i2x(1,1)-i2x(2,1)-i2x(3,1)-V8x(8,1)/(5);
 ic2x= i2x + ylabcnx*[V8x(5,1);V8x(6,1);V8x(7,1);V8x(8,1)]-0.5*yshabcn*[V8x(1,1);V8x(2,1);V8x(3,1);V8x(4,1)];
Icompx=[ic1x;ic2x];
Icompx-YopenDSS3*V8x;
losses=complex(DSSCircuit.Losses(1),DSSCircuit.Losses(2))/1000;
iter=1;
