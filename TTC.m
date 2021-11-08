function y = TTC(Input, x,bv)
% y = TTC(Input, x, bv)
% -----------------------------------------------------------------------
% Schnelle TT-Kontraktion nach [30]
%
% y			=	Mehrdimensionale Kontraktion von x
%
% Input		=	Matrix, N x d-Featurematrix des Datensatzes
% x			=   Cell, beinhaltet TT-Kerne des Classifiers
% bv		=   Skalar, Index der Basisfunktion im Mapping (vgl. Basis.m)

N=size(Input,1);
d=length(x);
n=zeros(1,d);
r=ones(1,d+1);
for i=1:d
    r(i)=size(x{i}, 1);
    n(i)=size(x{i}, 2);
end

y=ones(N,1);    R=1;
for i=1:d
    temp=R*unfold_r(x{i});
    r(i)=size(R,1);
    temp=reshape(temp, r(i)*n(i), r(i+1));
    [Q, R]=qr(temp, 0);
    Phi=basis(Input(:,i),n(i)-1,N,bv);
    y=dotkron(y, Phi)*Q;
end

y=y*R;
end