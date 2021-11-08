function [res]=scalar(A,B)
% res = scalar(A,B)
% -------------------------------------------
% Skalarprodukt von Zwei Tensoren im TT-Format nach Oseledets [24]
% res       =   Skalarprodukt von A und B
% 
% A         =   Tensor, erster Faktor
% B         =   Tensor, zweiter Faktor

% Initialisierung der nötigen Größen
d=size(A,2);
if d ~= size(B,2)
    error('Inkompatible TT-Größen.');
end
n=zeros(1,d);
for i=1:d
    n(i)=size(A{i},2);
end

% Nach Alg. 4 aus Oseledets' TT Paper.
v=0;
a=permute(A{1},[1,3,2]);
b=permute(B{1},[1,3,2]);

for i=1:n(1)
    v=v+kron(a(:,:,i),b(:,:,i));
end
for k=2:d-1
    p=cell(1,n(k));
    a=permute(A{k},[1,3,2]);
    b=permute(B{k},[1,3,2]);
    w=0;
    for i=1:n(k)
        p{i}=v*kron(a(:,:,i),b(:,:,i))';
        w=w+p{i};
    end
    v=w;    
end

a=permute(A{d},[1,3,2]);
b=permute(B{d},[1,3,2]);
w=0;
for i=1:n(d)
    w=w+kron(a(:,:,i),b(:,:,i));
end
res=v*w;
end
