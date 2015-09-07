% Define link lengths
clear; clc

l1 = 30e-2;
l2 = 10e-2;
l3 = 20e-2;
l4 = 20e-2;

% Simulate trajectory
N = 15;
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
fps = 5;

for k = 1 : N
    set( h, 'XData', cumsum( [0 l2*cos(th2(k)) l3*cos(th3(k)) l4*cos(th4(k)) l1*cos(th1(k))] ), ...
            'YData', cumsum( [0 l2*sin(th2(k)) l3*sin(th3(k)) l4*sin(th4(k)) l1*sin(th1(k))] ) );
    pause( 1/fps )
end

%% Generate some trajectory
nn = (1 : N)';

X = sin( nn * 2*pi/N ).^3;
Y = - 3*cos( nn * 2*pi/N );

aux = 2*[cos(pi/3) sin(pi/3) 3; -sin(pi/3) cos(pi/3) -2; 0 0 1] * [X'; Y'; ones(1,N)];
Xg = aux(1,:)';
Yg = aux(2,:)';

% subplot(211); plot( X, Y )
% subplot(212); plot( Xg, Yg )

tmp = angle2dcm( th3, zeros(N,1), zeros(N,1), 'ZXY' );
tmp = reshape( permute(tmp(1:2,1:2,:),[2 1 3]), [2 2*N] )';
A = [-tmp reshape( [ X Y ones(N,1) zeros(N,1) Y -X zeros(N,1) ones(N,1) ]', [4 2*N] )'];
B = reshape( [ l2*cos(th2) l2*sin(th2) ]', [1 2*N] )';

coeff = A \ B;

alf = coeff(3)^2 + coeff(4)^2;
R = [ coeff(3) coeff(4); -coeff(4) coeff(3) ] / alf;
P = repmat( coeff(5:6), [1 N] );

aux = alf * R * [X'; Y'] + P;
Xf = l2*cos(th2) + aux(1,:)';
Yf = aux(2,:)';

subplot(211); plot( X, Y, 'bo-', Xg, Yg, 'ro-', reshape([X Xg NaN(N,1)]', [1 3*N])', reshape([Y Yg NaN(N,1)]', [1 3*N])', 'y' ); axis equal
subplot(212); plot( Xf, Yf, 'bo-', Xg, Yg, 'ro--', reshape([Xf Xg NaN(N,1)]', [1 3*N])', reshape([Yf Yg NaN(N,1)]', [1 3*N])', 'y' ); axis equ