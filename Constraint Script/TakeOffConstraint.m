% File: TakeOffConstraint.m
% Script to plot the take off constraint line on an existing constraint
% diagram. It used data computed from the takeoff EOMs and stored in 
% and array called DATA.

WperS=0.1:.1:1.9;
WperHP=zeros(size(WperS));
for i=1:length(WperS)
    y=find(DATA(:,1)==WperS(i))
    DATA(100,:)
    DATA2=DATA(y,:);
    size(DATA2)
    y2=find(DATA2(:,6)==0)
    WperHP(i)=max(DATA2(y2,2))
end

figure(1)
hold on
plot(WperS,WperHP)
hash_left(WperS,WperHP,80)
string5=['Takeoff constraint from integrating EOMs'];
text2(.2,.3,string5)