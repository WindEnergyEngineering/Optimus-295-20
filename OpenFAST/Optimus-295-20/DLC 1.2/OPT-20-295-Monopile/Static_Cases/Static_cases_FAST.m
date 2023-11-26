 % -----------------------------

% Script: Read FAST output files in this folder and find static end conditions 
%
% Input:    roh           - Information for power on rotor
%           D             - Rotorradius
%           dt            - Simulation timesteps
%           outb-files    - Put the files in current folder
%
% Output: 
% Section 1: Read FAST Output file in this folder
% Section 2: Plot results from static tests simulation
% Section 3: Calculate steady states
% Section 4: Plot results from steady states calculation
% Section 5: Plot power curve and calculated cp
% Section 6: P-n characteristic curve

% -----------------------------

clearvars;close all;clc;

%% Input 

roh         = 1.225;                        % Information for power on rotor
D           = 295;

fi          = dir('*.outb');                % list outb in this folder
nn          = length(fi);

dt          = 0.1;                           % Time step of the simulation


%% Section 1: Read FAST Output file

for i=1:nn	

file = fi(i).name;

[Channels, ChanName] = ReadFASTbinary(file);

%eval(sprintf('Fast%d = [Channels]', i)) ;          % get full outb if you want

Time                = Channels(:,1);                % load simulation data
Wind1VelX(:,i)      = Channels(:,2);
BldPitch1(:,i)      = Channels(:,6);
RotSpeed(:,i)       = Channels(:,9);
GenPower(:,i)       = Channels(:,56);
GenTq(:,i)          = Channels(:,57);

Ncl_acceleration_x(:,i)    = Channels(:,47);        % Nacelle acceleration in x directon for the calculation of displacement 

end

ncl_disp = Ncl_acceleration_x * dt;                % calculate nacelle displaement

%% Section 2: Plot results from static tests simulation

figure
subplot(511)
hold on;box on;grid on;
plot(Time, Wind1VelX)
xlim([0 600])
ylabel('v_0 [m/s]')

subplot(512)
hold on;box on;grid on;
plot(Time, BldPitch1)
xlim([0 600])
ylabel('Angle [°]')

subplot(513)
hold on;box on;grid on;
plot(Time, RotSpeed)
xlim([0 600])
ylabel('\Omega [rpm]')

subplot(514)
hold on;box on;grid on;
plot(Time, GenPower)
xlim([0 600])
ylabel('P_{gen} [W]')
xlabel('time [s]')

subplot(515)
hold on;box on;grid on;
plot(Time, ncl_disp)
xlim([0 600])
ylabel('Displacement [m]')
xlabel('time [s]')




%% Section 3: Calculate steady states

last_vals = 60/dt;                                                              % Data points for the last minute of the simulation 

for i=1:nn                                                                      % get last minutes mean values and std dev of nacelle movement 

    Wind_SS(1,i)        = sort(sum(Wind1VelX(end-last_vals+1:end,i))/last_vals);       % means
    Pitch_SS(1,i)       = sort(sum(BldPitch1(end-last_vals+1:end,i))/last_vals);
    RotSpeed_SS(1,i)    = sum(RotSpeed(end-last_vals+1:end,i))/last_vals;
    GenPower_SS(1,i)    = sum(GenPower(end-last_vals+1:end,i))/last_vals;
    GenTq_SS(1,i)       = sum(GenTq(end-last_vals+1:end,i))/last_vals;

    Ncl_ac(1,i)         = std(ncl_disp(end-last_vals+1:end,i));

end

Wind_Speed = Wind_SS;
Pitch_Angle = Pitch_SS;
Rotor_Speed = RotSpeed_SS;
Generator_Power = GenPower_SS;
Generator_Torque = GenTq_SS;

Tip_speed = Rotor_Speed./60*2*pi*0.5*D;
TSR = Tip_speed./Wind_Speed;
                                                       
Static_Conditions = table(Wind_Speed.', Pitch_Angle.', Rotor_Speed.', Generator_Power.', TSR.',Generator_Torque.' , Ncl_ac.' , ...       % write stedy states table  
    'VariableNames', ["Wind_Speed","Pitch_Angle","RotSpeed", "GenPower", "TSR","Generator_Torque", "Nacell_acceleration"]);
Steady_States = sortrows(Static_Conditions);                                                                         % sort table

%% Section 4: Plot results from steady states calculation

Wind_Speed = sort(Wind_SS);
Pitch_Angle = sort(Pitch_SS);
Rotor_Speed = sort(RotSpeed_SS);
Generator_Power = sort(GenPower_SS);

figure 
subplot(411)
hold on; box on; grid on;
plot(Wind_Speed, Pitch_Angle, 'b - x')
ylabel('Angle [°]')

subplot(412)
hold on; box on; grid on;
plot(Wind_Speed, Rotor_Speed, 'b - x')
ylabel('\Omega [rpm]')

subplot(413)
hold on; box on; grid on;
plot(Wind_Speed, Generator_Power, 'b - x')
ylabel('P_{gen} [W]')

Std_Dev = table2array(Steady_States(:,7));

subplot(414)
hold on; box on; grid on;
plot(Wind_Speed, Std_Dev ,'b - x')
ylabel('Std.Disp [m]')
xlabel('Wind speeds [m/s]')

%% Section 5: Plot power curve and calculated cp

wind = sort(Wind_Speed);
power = sort(Generator_Power);

pwind = roh/2 * pi/4 * D.^(2) * wind.^(3);
cp = 1000*power./pwind;

figure
subplot(211)
hold on;box on;grid on;
plot(wind, power, 'b - x')
ylabel('P_{gen} [kW]')
%axis([71500 73000 15.5 16.5])

subplot(212)
hold on;box on;grid on;
plot(wind, cp, 'b - x')
ylabel('cp [-]')
xlabel('Wind speeds [m/s]')
%axis([71500 73000 15.5 16.5])

%% Section 6: P-n characteristic curve 
% (calculation is not accurant enoug; find the edge points in the crossing sections)


figure 
subplot(111)
hold on; box on; grid on;
plot(Rotor_Speed, Generator_Power, 'b - x')
ylabel('Power [kW]')
xlabel('Rotor speed [rpm]')
axis([4 7 0 22000])



