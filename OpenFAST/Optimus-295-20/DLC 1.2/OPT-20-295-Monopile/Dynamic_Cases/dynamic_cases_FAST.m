% -----------------------------

% Script: Read FAST output files in this folder and find static end conditions 
%
% Input:       outb-files    - Put the files in current folder
%
% Output: 
% Section 1: Read FAST Output file in this folder
% Section 2: Plot all Values 
% Section 3: Evaluate Pitch Controller
% Section 4: Evaluate Torque Controller

% -----------------------------
clearvars;close all;clc;

%% Section 1: Read FAST Output file
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

%% Section 2: Plot all Values 
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
%% Section 3: Evaluate Pitch Controller

windspeed        = Wind1VelX(:,1:4);
Rot_speed        = RotSpeed(:,1:4);

figure

subplot(211)
hold on;box on;grid on;
plot(windspeed)
ylabel('\Omega [rpm]')
axis([0 1200 10 20])

subplot(212)
hold on;box on;grid on;
plot(Rot_speed)
ylabel('\Omega [rpm]')
xlabel('time [0.5 s]')
axis([0 1200 6.47 6.51])

%% Section 4: Evaluate Torque Controller

D           = 295;

wind        = Wind1VelX(:,5);
gentorque   = GenTq(:,5);
omega       = RotSpeed(:,5);

Tip_speed   = omega./60*2*pi*0.5*D;
TSR         = Tip_speed./wind;


figure

% plot wind
subplot(411)
hold on;box on;grid on;
plot(wind)
ylabel('v_0 [m/s]')
axis([0 1200 7.5 9.5])


% plot generator torque
subplot(412)
hold on;box on;grid on;
plot(gentorque)
ylabel('M_G [kNm]')
axis([0 1200 250 400])

% plot rotor speed
subplot(413)
hold on;box on;grid on;
plot(omega)
ylabel('\Omega [rpm]')
axis([0 1200 5 6.5])

% plot tip speed ratio
subplot(414)
hold on;box on;grid on;
plot(TSR)
ylabel('\lambda [-]')
xlabel('time [0.5 s]')
axis([0 1200 9 11])
