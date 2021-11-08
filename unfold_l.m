function y=unfold_l(x)
%% y = unfold_l(x)
% --------------------------------------------------------------------------------------------
% Realisiert Linke Entfaltung eines Tensors.
% y			=	Matrix, Linke Entfaltung von x
% 
% x			=	Tensor
[a,b,c]=size(x);
y=reshape(x,a*b,c);
end