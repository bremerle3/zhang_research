% Options/switches
sine_input = 0;
plot_input = 0; 

%%
% y(t)'' + a*y'(t) + b*y(t) = u(t)
a = 3;
b = 2;
% Put equation into CCF
 A = [-a -b
     1    0];
 B = [1
     0];
 C = [0   1];
 D = 0;
 
%10 KHz sine wave input or 3V step input
freq = 1000;
samp_freq = 60*freq;
time = 10000*(1/freq);
T = 0:(1/samp_freq):time;                
if (sine_input == 1)
    U = sin(2*pi*freq.*T);
else
    U = 3*ones(size(T));  
end
if (plot_input == 1)
    figure;
    plot(T,U, 'x')
    title('Input'); xlabel('secs'); ylabel('Voltage');
end
sys = ss(A,B,C,D); 
% simulate and plot the response
[Y1, Tsim, X1] = lsim(sys,U,T);
figure;
plot(Tsim, Y1)
title('Output'); xlabel('secs'); ylabel('Voltage');
figure;
plot(Tsim, X1(:,1))
hold on
plot(Tsim, X1(:,2))
legend('x1', 'x2');
title('State Variables'); xlabel('secs'); ylabel('Voltage');

% Run again with the integrator scaling
%%
int_const = 0.1e5; % 0.16 (1/us)
a = 1*int_const;
b = 2*int_const;
input_gain = 0.2;
% Put equation into CCF
 A = [-a -b
     int_const    0];
 B = [1
     0];
 C = [0   1];
 D = 0;
 
%10 KHz sine wave input or 3V step input
freq = 1000;
samp_freq = 60*freq;
time = 10000*(1/freq);
%T = 0:(1/samp_freq):time;     
T = 0:0.0001:time;   
if (sine_input == 1)
    U = sin(2*pi*freq.*T);
else
    U = 3*input_gain*ones(size(T));  
end
if (plot_input == 1)
    figure;
    plot(T,U, 'x')
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

%%
%Plot the unscaled and scaled equations together
figure
plot(T,Y1./int_const,'x')
hold on
plot(T,Y2,'o')
legend('scaled', 'unscaled');
title('Unscaled vs. Scaled Solution'); xlabel('secs'); ylabel('Voltage');

%%
syms G1 G2 K t
A = [0 K; -G1 -G2];
B = [0; 1];
C = [1 0];
phi = C*expm(A * t)*B;
