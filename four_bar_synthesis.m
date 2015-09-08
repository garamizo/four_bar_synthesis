%% Define link lengths
clear; clc

l1 = 30e-2;
l2 = 10e-2;
l3 = 20e-2;
l4 = 22e-2;

% Calculate kinematics
N = 30;
th1 = linspace( pi, pi, N )';
th2 = linspace( 0, 2*pi, N )' + pi/4;

th3 = NaN(N,1);
th4 = NaN(N,1);
x = [0 -pi/2];
for k = 1 : N
    [x,~,flag] = fsolve( @(x) [ l1*cos(th1(k)) + l2*cos(th2(k)) + l3*cos(x(1)) + l4*cos(x(2)) 
                                l1*sin(th1(k)) + l2*sin(th2(k)) + l3*sin(x(1)) + l4*sin(x(2)) ], x );
    if flag == 1
        th3(k) = x(1);
        th4(k) = x(2);
    end
end

% Animate kinematics 
figure
h = plot( 0, 0 );
axis( [-.1 .4 -.2 .3 ] )
fps = 5;

for k = 1 : N
    set( h, 'XData', cumsum( [0 l2*cos(th2(k)) l3*cos(th3(k)) l4*cos(th4(k)) l1*cos(th1(k))] ), ...
            'YData', cumsum( [0 l2*sin(th2(k)) l3*sin(th3(k)) l4*sin(th4(k)) l1*sin(th1(k))] ) );
    pause( 1/fps )
end

%% Generate desired trajectory
nn = (1 : N)';

X = .2*cos( nn * 1*pi/N );
Y = 0.01*sin( nn * 1*pi/N );

figure; plot( cumsum( [0 l2*cos(th2(1)) l3*cos(th3(1)) l4*cos(th4(1)) l1*cos(th1(1))] ), ...
    cumsum( [0 l2*sin(th2(1)) l3*sin(th3(1)) l4*sin(th4(1)) l1*sin(th1(1))] ), 'o-' );
[Xp,Yp] = getpts();
s = [0; cumsum( sqrt( diff(Xp).^2 + diff(Yp).^2 ) )];
X = interp1( s*N/s(end), Xp, nn );
Y = interp1( s*N/s(end), Yp, nn );

% Calculate physical parameters
tmp = angle2dcm( -th3, zeros(N,1), zeros(N,1), 'ZXY' );
tmp = reshape( permute(tmp(1:2,1:2,:),[2 1 3]), [2 2*N] )';
A = [-tmp reshape( [ X -Y ones(N,1) zeros(N,1) Y X zeros(N,1) ones(N,1) ]', [4 2*N] )'];
B = reshape( [ l2*cos(th2) l2*sin(th2) ]', [1 2*N] )';

coeff = A \ B;
LM = fitlm( A, B, 'Intercept', false );

rx = coeff(1);
ry = coeff(2);
alf = sqrt( coeff(3)^2 + coeff(4)^2 );
psi = atan2( coeff(4), coeff(3) );
dx = coeff(5);
dy = coeff(6);

R = [ cos(psi) -sin(psi); sin(psi) cos(psi) ];
P0 = repmat( [dx dy], [N 1] );

tmp = ( l2*[cos(th2) sin(th2)] + [rx*cos(th3)-ry*sin(th3), rx*sin(th3)+ry*cos(th3)] - P0 ) * R / alf;
Xf = tmp(:,1);
Yf = tmp(:,2);

figure
plot( Xf, Yf, 'bo-', X, Y, 'ro--', reshape([X Xf NaN(N,1)]', [1 3*N])', reshape([Y Yf NaN(N,1)]', [1 3*N])', 'y' ); axis equal
legend( 'fit', 'target' )

%% Animate 
figure
plot( X, Y, '--' )
hold on
h = plot( 0, 0, 'o-' );
axis( [min(X)-2*(max(X)-min(X)) max(X)+2*(max(X)-min(X)) min(Y)-2*(max(Y)-min(Y)) max(Y)+2*(max(Y)-min(Y))] )
fps = 5;

while true
for k = 1 : N
    lp = [ cumsum( [0 l2*cos(th2(k)) l3*cos(th3(k)) l4*cos(th4(k)) l1*cos(th1(k))] )
           cumsum( [0 l2*sin(th2(k)) l3*sin(th3(k)) l4*sin(th4(k)) l1*sin(th1(k))] ) ];
    lp = [lp(:,1:2) [l2*cos(th2(k))+rx*cos(th3(k))-ry*sin(th3(k)); l2*sin(th2(k))+rx*sin(th3(k))+ry*cos(th3(k))] lp(:,[3 2:end])];
    lp = R \ ( lp - repmat( [dx; dy], [1 8] ) ) / alf;
    set( h, 'XData', lp(1,:), 'YData', lp(2,:) );
    pause( 1/fps )
end
end
