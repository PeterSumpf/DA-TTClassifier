function y=dotkron(varargin)
% y = dotkron(varargin)
% ------------------------------------------------------------------------------
% Reduziertes Kronecker-Produkt fuer 2 oder 3 Matrizen mit gleicher Anzahl Reihen
% y			=	Matrix, Kronecker-Produkt der Input-Matrizen
%
% varargin	=	2 (oder 3) Matrizen

if nargin==2
    L=varargin{1};    [r1,c1]=size(L);
    R=varargin{2};    [r2,c2]=size(R);
    if r1 ~= r2
        error('Invalide Matrizengröße.');
    else
%           y=ones(r1,c1*c2);
%           for i=1:r1
%             for j=1:c1*c2
%                 y(i,j)=L(modulo2(i,r1),modulo2(j,c1)).*R(floor((i-1)/r1 +1),floor((j-1)/c1 +1));
%             end
%           end
         y=repmat(L,1,c2).*kron(R, ones(1, c1));  % Schneller als Schleife
    end
elseif nargin==3
    L=varargin{1};    r1=size(L,1);
    M=varargin{2};    r2=size(M,1);
    R=varargin{3};    r3=size(R,1);
    
    if r1 ~= r2 || r2 ~=r3  ||  r1~=r3
        error('Invalide Matrizengröße.');
    else
        y=dotkron(L, dotkron(M, R));
    end
else
    error('Zu viele / Zu wenig Inputs.');
end
end