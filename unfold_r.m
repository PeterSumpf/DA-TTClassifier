function y=unfold_r(x)
%% y = unfold_r(x)
% --------------------------------------------------------------------------------------------
% Realisiert Rechte Entfaltung eines Tensors.
% y			=	Matrix, Rechte Entfaltung von x
% 
% x			=	Tensor
[a,b,c]=size(x);
y=reshape(x,a,b*c);
end