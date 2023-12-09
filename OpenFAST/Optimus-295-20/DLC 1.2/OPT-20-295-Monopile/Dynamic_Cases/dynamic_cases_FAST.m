% -----------------------------

% Script: Read FAST output files in this folder and find static end conditions 
%
% Input:       outb-files    - Put the files in current folder
%
% Output: 
% Section 1: Read FAST Output file in this folder
% Section 2: 
% Section 3: 
% Section 4: 

% -----------------------------
clearvars;close all;clc;

%% Read FAST Output file
fi = dir('*.outb');                 %list folder
nn = length(fi);


for i=1:nn	

file = fi(i).name;

[Channels, ChanName] = ReadFASTbinary(file);

%eval(sprintf('Fast%d = [Channels]', i)) ;      %get full outb if you want

Time                = Channels(:,1);                % load simulation data
Wind1VelX(:,i)      = Channels(:,2);
BldPitch1(:,i)      = Channels(:,6);
RotSpeed(:,i)       = Channels(:,9);
GenPower(:,i)       = Channels(:,56);
GenTq(:,i)          = Channels(:,57);

end

%% Plot Values 
figure

subplot(411)
hold on;box on;grid on;
plot(Wind1VelX)
ylabel('v_0 [m/s]')
%axis([71500 73000 15.5 16.5])
%axis([0 4801 19.9 20.2])

subplot(412)
hold on;box on;grid on;
plot(BldPitch1)
ylabel('Angle [°]')
%axis([71500 73000 5 10])
%axis([0 4801 0.1 0.25])

subplot(413)
hold on;box on;grid on;
plot(RotSpeed)
ylabel('\Omega [rpm]')
%axis([71500 73000 7.5 7.6])
%axis([0 4801 12 12.5])

subplot(414)
hold on;box on;grid on;
plot(GenPower)
ylabel('P_{gen} [W]')
xlabel('time [1/80*s]')
%% Evaluate Pitch Controller

%% Evaluate Torque Controller


