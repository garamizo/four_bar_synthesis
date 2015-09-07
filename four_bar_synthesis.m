% Define link lengths
l1 = 30e-2;
l2 = 10e-2;
l3 = 20e-2;
l4 = 20e-2;

% Simulate trajectory
N = 100;
th1 = linspace( pi, pi, N )';
th2 = linspace( 0, 2*pi, N )' + pi/3;

x = [0 -pi/2];
for k = 1 : N
    x = fsolve( @(x) [ l1*cos(th1(k)) + l2*cos(th2(k)) + l3*cos(x(1)) + l4*cos(x(2)) 
                       l1*sin(th1(k)) + l2*sin(th2(k)) + l3*sin(x(1)) + l4*sin(x(2)) ], x );
    th3(k) = x(1);
    th4(k) = x(2);
end

% Animate 
figure
h = plot( 0, 0 );
axis( [-.1 .4 -.2 .3 ] )
fps = 20;

for k = 1 : N
    set( h, 'XData', cumsum( [0 l2*cos(th2(k)) l3*cos(th3(k)) l4*cos(th4(k)) l1*cos(th1(k))] ), ...
            'YData', cumsum( [0 l2*sin(th2(k)) l3*sin(th3(k)) l4*sin(th4(k)) l1*sin(th1(k))] ) );
    pause( 1/fps )
end

% Define desired trajectory
x = linspace( 10e-2, 10e-2, N );
y = linspace( -10e-2, 10e-2, N );

% [x y] * Rz + ones(N,2) * eye(2) * [px py]'