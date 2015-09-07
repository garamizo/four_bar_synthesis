[U,S,V] = svd( A );

%%
S*U*V'

%%
U*S*V'

%% Generate some trajectory
clear; clc

N = 10;

X = sin( ( 1 : N )' * 2*pi/N ).^3;
Y = - 5*cos( ( 1 : N )' * 2*pi/N );

aux = [1 2; -2 1] * [X'; Y'];
Xg = aux(1,:);
Yg = aux(2,:);

% subplot(211); plot( X, Y )
% subplot(212); plot( Xg, Yg )

A = reshape( [ X Y Y -X ]', [2 2*N] )';
B = reshape( [ Xg Yg ]', [1 2*N] )';

coeff = A \ B;

R = [ coeff(1) coeff(2); -coeff(2) coeff(1) ];

aux = R * [X'; Y'];
aux2 = reshape( A * coeff, [2 N] )
Xf = aux(1,:);
Yf = aux(2,:);

plot( X, Y, 'b', Xg, Yg, 'r', Xf, Yf, 'b--' )

%% General matrix
clear; clc

N = 10;

X = sin( ( 1 : N )' * 2*pi/N ).^3;
Y = - 5*cos( ( 1 : N )' * 2*pi/N );

aux = [10 2; -2 1] * [X'; Y'];
Xg = aux(1,:);
Yg = aux(2,:);

% subplot(211); plot( X, Y )
% subplot(212); plot( Xg, Yg )

aux = [ X Y ];
A = zeros( 2*N, 4 );
A(1:2:end,[1 2]) = aux;
A(2:2:end,[3 4]) = aux;
B = reshape( [ Xg Yg ]', [1 2*N] )';

coeff = A \ B

aux2 = reshape( A * coeff, [2 N] )
Xf = aux2(1,:);
Yf = aux2(2,:);

plot( X, Y, 'b', Xg, Yg, 'r', Xf, Yf, 'b--' )