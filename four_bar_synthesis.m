% Define link lengths
l1 = 30e-2;
l2 = 10e-2;
l3 = 20e-2;
l4 = 20e-2;

% Simulate trajectory
N = 100;
th1 = linspace( pi, pi, N )';
th2 = linspace( 0, 2*pi, N )' + pi/3;

x = [0 0];
for k = 1 : N
    x = fsolve( @(x) [ l1*cos(th1(k)) + l2*cos(th2(k)) + l3*cos(x(1)) + l4*cos(x(2)) 
                       l1*sin(th1(k)) + l2*sin(th2(k)) + l3*sin(x(1)) + l4*sin(x(2)) ], x );
    th3(k) = x(1);
    th4(k) = x(2);
end

% plot
