 % -----------------------------
% Script: Read FAST output files and find static endconditions 
% -----------------------------

clearvars;close all;clc;

%% Read FAST Output file
fi = dir('*.outb');                 %list folder
nn = length(fi);


for i=1:nn	

file = fi(i).name;

[Channels, ChanName] = ReadFASTbinary(file);

%eval(sprintf('Fast%d = [Channels]', i)) ;      %get full outb if you want

Time                = Channels(:,1);            % load simulation data
Wind1VelX(:,i)      = Channels(:,2);
BldPitch1(:,i)      = Channels(:,6);
RotSpeed(:,i)       = Channels(:,9);
GenPower(:,i)       = Channels(:,56);

end

%% Plot Values 

figure
subplot(411)
hold on;box on;grid on;
plot(Time, Wind1VelX)
xlim([0 600])
ylabel('v_0 [m/s]')

subplot(412)
hold on;box on;grid on;
plot(Time, BldPitch1)
xlim([0 600])
ylabel('Angle [°]')

subplot(413)
hold on;box on;grid on;
plot(Time, RotSpeed)
xlim([0 600])
ylabel('\Omega [rpm]')

subplot(414)
hold on;box on;grid on;
plot(Time, GenPower)
xlim([0 600])
ylabel('P_{gen} [W]')
xlabel('time [s]')

%% Static values 

Wind_Speed = Wind1VelX(end,:);
Pitch_Angle = BldPitch1(end,:);
Rotor_Speed = RotSpeed(end,:);
Generator_Power = GenPower(end,:);

Static_Conditions = table(Wind_Speed.', Pitch_Angle.', Rotor_Speed.', Generator_Power.', 'VariableNames', ["Wind_Speed","Pitch_Angle","RotSpeed", "GenPower"]);

%% Plot power curve and cp
wind = sort(Wind_Speed);
power = sort(Generator_Power);

roh = 1.225;
D = 295;
pwind = roh/2 * pi/4 * D.^(2) * wind.^(3);
cp = 1000*power./pwind;

figure
subplot(211)
hold on;box on;grid on;
plot(wind, power)
ylabel('P_{gen} [W]')
%axis([71500 73000 15.5 16.5])

subplot(212)
hold on;box on;grid on;
plot(wind, cp)
ylabel('cp [-]')
xlabel('Wind speeds [m/s]')
%axis([71500 73000 15.5 16.5])

%% Calculate steady states

dt = 0.1;                   % Time step of the simulation
last_vals = 60/dt;          % Data points for the last minute of the simulation 

for i=1:nn
    Pitch_SS(1,i) = sort(sum(BldPitch1(end-last_vals+1:end,i))/last_vals);
    RotSpeed_SS(1,i) = sum(RotSpeed(end-last_vals+1:end,i))/last_vals;
    GenPower_SS(1,i) = sum(GenPower(end-last_vals+1:end,i))/last_vals;
end

Pitch_SS_sorted = sort(Pitch_SS);
RotSpeed_SS_sorted = sort(RotSpeed_SS);
GenPower_SS_sorted = sort(GenPower_SS);



figure 
subplot(311)
hold on; box on; grid on;
plot(wind, Pitch_SS_sorted, '.-', 'MarkerSize',20)
ylabel('Angle [°]')

subplot(312)
hold on; box on; grid on;
plot(wind, RotSpeed_SS_sorted, '.-', 'MarkerSize',20)
ylabel('\Omega [rpm]')

subplot(313)
hold on; box on; grid on;
plot(wind, GenPower_SS_sorted, '.-', 'MarkerSize',20)
ylabel('P_{gen} [W]')
xlabel('Wind speeds [m/s]')



