% FILE: Constraint3.m% Script to generate constraint diagram: %%disp(' '); disp('*** Start here ***'); disp(' ')% DataSectionWperSmin=0.2   % Limit on the axes of the constraint diagram (lbf/ft^2)WperSmax=1.9   % Limit on the axes of the constraint diagram (lbf/ft^2)WperPmin= 0   % Limit on the axes of the constraint diagram (lbf/hp)WperPmax=200   % Limit on the axes of the constraint diagram (lbf/hp)Vs=23 %Stall speed (ft/sec)CLmax=[1.3,1.4,1.5] % Possible values of maximum lift coefficient (nondimensional), use 3 of themrho=0.002393 % Air Density (slugs/ft^3)Vcr=40       % Cruise Speed (ft/sec)EtaP=.5 % Propeller Efficiency (nondimensional)CD0=[.02,0.03,0.04] % Possible values of CD0, use 3 of themLoverDmax=[10,12] % Estimated Maximum Lift to Drag Ratiogamma=25/(180/pi) % Take-off Flight Path AnglevLoiter = 1.3*Vs; %Loiter speed (ft/sec)oswaldEfficiency = 0.98; %Elliptical loading efficiency factor for tapered wingsAR = [5,6,7]; %Aspect ratioturnG = 3; %G's required for a sustained turnlandingDist = 100; %ft% Stall speed constraintfigure(1)hold onWperS1=.5*rho*Vs^2*CLmax; % wing loading constraintsnumCLmax=length(CLmax);ifig=0;ifig=ifig+1; figure(ifig)clfaxis([WperSmin,WperSmax,WperPmin,WperPmax])WperSdat=[WperS1(1),WperS1(1)];WperPdat=[WperPmin,WperPmax];plot(WperSdat,WperPdat)hold ontitle('Constraint Diagram')hash_right(WperSdat,WperPdat)%hash_left(WperSdat,WperPdat,30)WperSdat=[WperS1(2),WperS1(2)];plot(WperSdat,WperPdat)hash_right(WperSdat,WperPdat)%hash_left(WperSdat,WperPdat)WperSdat=[WperS1(3),WperS1(3)];plot(WperSdat,WperPdat)hash_right(WperSdat,WperPdat)%hash_left(WperSdat,WperPdat,-30)%string1=['Stall: CLmax=[', num2str(CLmax),'], Vs= ', num2str(Vs), ' f/s'];%text2(.2,.2,string1)% Cruise speed constraintslopes=((.75)*(550)/(.5*rho*1.1))*EtaP./(Vcr^3*CD0);inc=(WperSmax-WperSmin)/10;WperSdat=WperSmin:inc:WperSmax;plot(WperSdat,slopes(1)*WperSdat)hash_left(WperSdat,slopes(1)*WperSdat,0)plot(WperSdat,slopes(2)*WperSdat)hash_left(WperSdat,slopes(2)*WperSdat,0)plot(WperSdat,slopes(3)*WperSdat)hash_left(WperSdat,slopes(3)*WperSdat,0)%string2=['Cruise Constraint: CD0=[', num2str(CD0),'], Vcruise= ', num2str(Vcr), ' ft/sec'];%text2(.05,.9,string2)%text2(.3,.03,'DESIGN SPACE')% Climb constraintWperPclimb=550*EtaP./(Vcr./(.866*LoverDmax)+Vcr*sin(gamma))plot([WperSmin WperSmax],[WperPclimb(1) WperPclimb(1)])plot([WperSmin WperSmax],[WperPclimb(2) WperPclimb(2)])hash_left([WperSmin WperSmax],[WperPclimb(1) WperPclimb(1)])hash_left([WperSmin WperSmax],[WperPclimb(2) WperPclimb(2)])%string3=['Climb constraint, gamma= ',num2str(gamma*57.3),' deg, Vclimb= ',num2str(Vcr),' ft/sec. Lower L/D gives lower line.']%text2(.05,.08,string3)%string4=['L/D max= ',num2str(LoverDmax)]%text2(.05,.15,string4)%Loiter constraintWperSLoiter = 0.5*rho*vLoiter^2*sqrt(3*pi*AR*oswaldEfficiency*0.03); %Choose CD0 = 0.03plot([WperSLoiter(1) WperSLoiter(1)], [WperPmin, WperPmax])hash_right([WperSLoiter(1) WperSLoiter(1)], [WperPmin, WperPmax])plot([WperSLoiter(2) WperSLoiter(2)], [WperPmin, WperPmax])hash_right([WperSLoiter(2) WperSLoiter(2)], [WperPmin, WperPmax])plot([WperSLoiter(3) WperSLoiter(3)], [WperPmin, WperPmax])hash_right([WperSLoiter(3) WperSLoiter(3)], [WperPmin, WperPmax])%Sustained Turn ConstraintWperSTurn = 0.5*rho*Vcr^2*sqrt(pi*AR*oswaldEfficiency*0.03)/turnG; %Choose CD0 = 0.03plot([WperSTurn(1) WperSTurn(1)], [WperPmin, WperPmax])hash_right([WperSTurn(1) WperSTurn(1)], [WperPmin, WperPmax])plot([WperSTurn(2) WperSTurn(2)], [WperPmin, WperPmax])hash_right([WperSTurn(2) WperSTurn(2)], [WperPmin, WperPmax])plot([WperSTurn(3) WperSTurn(3)], [WperPmin, WperPmax])hash_right([WperSTurn(3) WperSTurn(3)], [WperPmin, WperPmax])%Landing ConstraintWperSLanding = 100/80*CLmaxplot([WperSLanding(1) WperSLanding(1)], [WperPmin, WperPmax])hash_right([WperSLanding(1) WperSLanding(1)], [WperPmin, WperPmax])plot([WperSLanding(2) WperSLanding(2)], [WperPmin, WperPmax])hash_right([WperSLanding(2) WperSLanding(2)], [WperPmin, WperPmax])plot([WperSLanding(3) WperSLanding(3)], [WperPmin, WperPmax])hash_right([WperSLanding(3) WperSLanding(3)], [WperPmin, WperPmax])xlabel('Wing Loading (lbf/ft^2)')ylabel('Power Loading (lbf/hp)')axis([WperSmin,WperSmax,WperPmin,WperPmax])%disp('Click twice on the desired design point')% [X,Y] = GINPUT(N)%[WperSin,WperHPin]=ginput(1)%plot(WperSin,WperHPin,'rx')%weight=2.5%S=weight/WperSin%Bhp=weight/WperHPin% Add text to figures after drawing last plot because scaling changes.string1=['Stall Constraint: CLmax=[',num2str(CLmax),'], Vs= ', num2str(Vs), 'ft/s'];text2(.2,.2,string1)string2=['Cruise Constraint: CD0=[',num2str(CD0),'], Vcruise= ', num2str(Vcr), 'ft/s'];text2(.05,.9,string2)text2(.3,.03,'DESIGN SPACE')string3=['Climb constraint, gamma= ',num2str(gamma*57.3),' deg, Vclimb= ',num2str(Vcr),' ft/s. Lower L/D gives lower line.']text2(.05,.08,string3)string4=['L/D max= ',num2str(LoverDmax)]text2(.05,.15,string4)