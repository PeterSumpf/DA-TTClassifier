function [res]=frnorm(x)
% res = frnorm(x)
% -------------------------------------------------------
% Berechnet Frobenius-Norm sqrt(<x,x>) eines TT-Tensors x
% res       =   Frobenius-Norm von x
%
% x         =   Tensor
frn=sqrt(scalar(x,x)); d=length(x);
res=cellfun(@(x) x/ (frn^(1/d)), x,'un',0); 
end