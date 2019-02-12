%% data preprocessing for demonstration
clear all;
clear;
clc;
% Define the time interval between each data point
time_interval=0.001;
% read falcon data
% robot parameters
N=21; % N joints
r=25; 
dd=5.5;
H0=0.8;
%% The first demonstration
falcon=load ('falconChen11.mat');
falcon.falconChen11=falcon.falconChen11+rand*0.00001;
n=length(falcon.falconChen11(:,1));
zb=zeros(n,1);
dalphax=zeros(n,1);
for i=1:n  %read line by line 
    zb(i)=(falcon.falconChen11(i,2)-4500)/4500; % stepper motor control value  0-9000
	dalphax(i)=(falcon.falconChen11(i,3)-1500)/500; % servo motor control value 1000-2000      
end
motor1=[zb';dalphax'];
%% The second demonstration
falcon=load ('falconChen12.mat');
falcon.falconChen12=falcon.falconChen12+rand*0.00001;
n=length(falcon.falconChen12(:,1));
zb=zeros(n,1);
dalphax=zeros(n,1);
for i=1:n  %read line by line 
    zb(i)=(falcon.falconChen12(i,2)-4500)/4500; % stepper motor control value  0-9000
	dalphax(i)=(falcon.falconChen12(i,3)-1500)/500; % servo motor control value 1000-2000     
end
motor2=[zb';dalphax'];
%% The third demonstration
falcon=load ('falconChen14.mat');
falcon.falconChen14=falcon.falconChen14+rand*0.00001;
n=length(falcon.falconChen14(:,1));
zb=zeros(n,1);
dalphax=zeros(n,1);
for i=1:n  %read line by line 
    zb(i)=(falcon.falconChen14(i,2)-4500)/4500; % stepper motor control value  0-9000
	dalphax(i)=(falcon.falconChen14(i,3)-1500)/500; % servo motor control value 1000-2000  
end
motor4=[zb';dalphax'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inte=3;
range=2500;
Data=[motor1(:,1:inte:range),motor2(:,1:inte:range),motor4(:,1:inte:range)];
% Plot the 2D data
plot(Data(1,1:ceil(range/inte)),Data(2,1:ceil(range/inte)),Data(1,ceil(range/inte)+1:2*ceil(range/inte)),Data(2,ceil(range/inte)+1:2*ceil(range/inte)),Data(1,2*ceil(range/inte)+1:3*ceil(range/inte)),Data(2,2*ceil(range/inte)+1:3*ceil(range/inte)));
temperal=[0:time_interval*inte:(ceil(range/inte)-1)*time_interval*inte];
% The final training data consists of three rows
% The first row denotes the time values
% The second and third rows represent the motor commands
Data=[temperal,temperal,temperal;Data(1,:);Data(2,:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


