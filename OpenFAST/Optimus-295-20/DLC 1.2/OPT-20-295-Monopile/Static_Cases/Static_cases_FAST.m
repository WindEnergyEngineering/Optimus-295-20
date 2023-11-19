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

%% Static values 

Wind_Speed = Wind1VelX(end,:);
Pitch_Angle = BldPitch1(end,:);
Rotor_Speed = RotSpeed(end,:);

Static_Conditions = table(Wind_Speed.', Pitch_Angle.', Rotor_Speed.', 'VariableNames', ["Wind_Speed","Pitch_Angle","RotSpeed"]);

