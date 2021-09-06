% File: Takeoff3.m
% Script to perform takeoff analysis on electric powered aircraft
% The output is stored in an array called DATA
%         DATA(k,1)=WperS(i);    % wing loading, lbf/ft^2
%         DATA(k,2)=WperBhp(j);  % power loading, lbf/hp
%         DATA(k,3)=TakeOffTime; % takeoff time, sec
%         DATA(k,4)=TakeOffDistance; % takeoff distance, ft
%         DATA(k,5)=WbPerW;      % battery weight fraction, nondimensional
%         DATA(k,6)=FailedTakeoff; % =1 if takeoff was NOT performed within the allowed TO distance
%                                 % =1 if takeoff was performed within the allowed TO distance
% INPUTS
ETAp=0.6       % propeller efficiency
ETAm=0.75       % Motor efficiency
rho=0.002377   % air density slugs per ft^3
Cd0=0.0300     % paracite drag coefficient
mu=0.05        % coefficient of rolling friction
Vtakeoff=40       % Take-off velocity, ft/sec
MaxTOdistance=120 % Maximum allowable take off ground roll, ft
RHOeNiCAD=  72900 % Energy density of NiCad (joule/lbf)
RHOeNiMH=   92500 % Energy density of NiMH (joule/lbf)
RHOeLiPoly=239000 % Energy density of Lithium Polymer (joule/lbf)
RHOused=RHOeLiPoly

WperS=0.1:.1:1;   % lbf/ft^2
WperBhp=1:1:100; % lbf/Bhp
rows=length(WperS)*length(WperBhp)
DATA=zeros(rows,5);

k=0;
for i=1:length(WperS)
    for j=1:length(WperBhp)
        k=k+1;
        %str1=['wing loading= ',num2str(WperS(i)),', powerloading= ',num2str(WperBhp(j))];
        %disp(str1)
        %[T,Y]=ode45(@TakeOffEOM,TSPAN,Y0,[],wingloading,powerloading,ETAp,rho,Cd0,mu);
        Tmax=60;  % Maximum amount of time to integrate, sec
        [T,Y]=ode45(@TakeOffEOM,[0 Tmax],[0 .1],[],WperS(i),WperBhp(j),ETAp,rho,Cd0,mu);
        % YI = INTERP1(X,Y,XI)
        TakeOffTime=interp1(Y(:,2),T,Vtakeoff); % will be NaN if the velocity was ot attained.
        if isnan(TakeOffTime); 
            disp('ERROR: You have not integrated long enough to achieve Vtakeoff'); 
            last=length(Y(:,1));
            TakeOffDistance=Y(last,1);
        else
            TakeOffDistance=interp1(T,Y(:,1),TakeOffTime);
        end
        
        if TakeOffDistance>MaxTOdistance | isnan(TakeOffTime); 
            FailedTakeoff=1; % Takeoff failed for either of two reasons
        else 
            FailedTakeoff=0; % Takeoff was successful
        end
        % Battery weight fraction for takeoff
        WbPerW=745.7*TakeOffTime/(ETAm*WperBhp(j)*RHOused); % nondimensional
        % store data
        DATA(k,1)=WperS(i);    % wing loading, lbf/ft^2
        DATA(k,2)=WperBhp(j);  % power loading, lbf/hp
        DATA(k,3)=TakeOffTime; % takeoff time, sec
        DATA(k,4)=TakeOffDistance; % takeoff distance, ft
        DATA(k,5)=WbPerW;      % battery weight fraction, nondimensional
        DATA(k,6)=FailedTakeoff; % =1 if takeoff failed for either of two reasons
                                 % =0 if takeoff was successful
    end
end

%SAVE FILENAME X Y Z  saves X, Y, and Z
save DATAfile DATA

[rowsDATA,colDATA]=size(DATA)
DATA
figure(1)
clf
axis([WperS(1),WperS(length(WperS)),WperBhp(1),WperBhp(length(WperBhp))])
hold on
% Find and plot points that represent successful takeoffs
k=find(DATA(:,6)==0);
plot(DATA(k,1),DATA(k,2),'ko')
disp('Battery weight fractions for successful takeoffs (mean, max, min).')
WbPerWmean=mean(DATA(k,5))
WbPerWmax=  max(DATA(k,5))
WbPerWmin=  min(DATA(k,5))
TakeOffTimeMean=mean(DATA(k,3))
TakeOffTimeMax=  max(DATA(k,3))
TakeOffTimeMin=  min(DATA(k,3))


% Find and plot points that represent failed takeoffs
k=find(DATA(:,6)==1);
plot(DATA(k,1),DATA(k,2),'rx')
xlabel('Wing Loading (lbf/ft^2)')
ylabel('Power loading (lbf/hp)')
title('Takeoff Constraint')
text2(.05,.95,'x represents failed takeoffs')
text2(.6,.05,'o represents successful takeoffs')
hold off
