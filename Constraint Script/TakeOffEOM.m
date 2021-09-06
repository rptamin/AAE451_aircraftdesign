function ydot=TakeOffEOM(t,y,wingloading,powerloading,ETAp,rho,Cd0,mu)
% Differential equations for take-off.
%
% [y(1) y(2)]=[x xdot]
% [ydot(1) ydot(2)]=[xdot xdotdot]

ydot(1,1)=y(2);
ydot(2,1)=32.17*(550*ETAp/(y(2)*powerloading)-0.5*rho*y(2)*y(2)*Cd0/wingloading-mu);
