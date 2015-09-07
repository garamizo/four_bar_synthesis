%% Generate some trajectory
clear; clc

N = 15;
nn = (1 : N)';

X = sin( nn * 2*pi/N ).^3;
Y = - 3*cos( nn * 2*pi/N );

aux = 2*[cos(pi/3) -sin(pi/3) 3; sin(pi/3) cos(pi/3) 2; 0 0 1] * [X'; Y'; ones(1,N)] + randn(3,N)/3;
Xg = aux(1,:)';
Yg = aux(2,:)';

A = reshape( [ X -Y ones(N,1) zeros(N,1) Y X zeros(N,1) ones(N,1) ]', [4 2*N] )';
B = reshape( [ Xg Yg ]', [1 2*N] )';

coeff = A \ B;

alf = coeff(1)^2 + coeff(2)^2;
R = [ coeff(1) -coeff(2); coeff(2) coeff(1) ] / alf;
P = repmat( coeff(3:4), [1 N] );

aux = alf * R * [X'; Y'] + P;
Xf = aux(1,:)';
Yf = aux(2,:)';

subplot(211); plot( X, Y, 'bo-', Xg, Yg, 'ro-', reshape([X Xg NaN(N,1)]', [1 3*N])', reshape([Y Yg NaN(N,1)]', [1 3*N])', 'y' ); axis equal
subplot(212); plot( Xf, Yf, 'bo-', Xg, Yg, 'ro--', reshape([Xf Xg NaN(N,1)]', [1 3*N])', reshape([Yf Yg NaN(N,1)]', [1 3*N])', 'y' ); axis equal

