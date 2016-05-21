% Options/switches
sine_input = 0;
plot_input = 0; 

%%
fid = fopen('buff_board_underdamped.txt','r');
A = fscanf(fid,'%f');
nidaq_buffer = 2^10;
nidaq_samples = 2^8;
signal_freq = 1000;
nidaq_interval = nidaq_buffer/nidaq_samples;

time = linspace( 0, nidaq_interval, nidaq_buffer );
figure;
plot(time(200:450),A(200:450),'x')

title('Board Data, (Under Damped)');
xlabel('Samples')
ylabel('Voltage');

%Simulated System, Critically Damped
%%
int_const = 0.1e5; % 0.16 (1/us)
a = 1*int_const;
b = 2*int_const;
input_gain = 0.2;
w_n = sqrt(int_const*a);
% Put equation into CCF
 A = [-a -b
     int_const    0];
 B = [int_const
     0];
 C = [0   1];
 D = 0;
 
%10 KHz sine wave input or 3V step input
freq = 1000;
samp_freq = 60*freq;
time = 1*(1/freq);
T = 0:(1/samp_freq):time;     
%T = 0:0.0001:time;   
if (sine_input == 1)
    U = sin(2*pi*freq.*T);
else
    U = 3*input_gain*ones(size(T));  
end
if (plot_input == 1)
    figure;
    plot(time,U, 'x')
    title('Input'); xlabel('secs'); ylabel('Voltage');
end
sys = ss(A,B,C,D); 
% simulate and plot the response
X0 = [0;0];   %Initial conditions
[Y2, Tsim, X2] = lsim(sys,U,T,X0);
figure;
plot(Tsim, Y2,'x')
title('Output'); xlabel('secs'); ylabel('Voltage');
figure;
plot(Tsim, X2(:,1),'x')
hold on
plot(Tsim, X2(:,2),'o')
legend('x1', 'x2');
title('State Variables'); xlabel('secs'); ylabel('Voltage');

