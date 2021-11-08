function [x,res]=TTLeastSquares(a,b,n,r,gamma,bv,varargin)
% [x, res]=TTLeastSquares(a, b, n, r, gamma, bv) oder [x, res]=TTLeastSquares(a, b, n, r, gamma, bv, x0)
% --------------------------------------------------------------------------------------------
% TT-Classifier auf LS-Basis mit variabler Basis & Regularisierung
%
% x         =   Cell, beinhaltet TT-Kerne des Classifiers
% res       =   Vektor, beinhaltet LS-Funktionswert jedes Schritts
%
% a         =   Matrix, N x d-Featurematrix des Datensatzes
% b         =   Matrix, N x 1-Matrix der Labels
% n         =   Skalar, Grad des Classifiers
% r         =   Skalar, Rang der TT-Kerne des Classifiers 
% gamma     =   Skalar, Regularisierungsparameter
% bv        =   Skalar, Index der Basisfunktion im Mapping (vgl. Basis.m)
% x0        =   Cell, optionaler Startwert des Classifiers-TTs. Wenn ein TT
%               gegeben ist werden Raenge des TT-Classifiers uebernommen.
[N,d]=size(a);

%% TT-Ranks r fixieren, G_1,G_{d+1} haben Rang 1 nach TT-Struktur
% Option falls Verfahren zum Bestimmen der TT-Ranks als Übergabe der
% Parameter
if length(r)==1
   r=r*ones(1,d+1);
   r(1)=1; r(d+1)=1;
end

%% Initialisierung der TT-Classifier Kerne, Normierung auf 1 & Orthogonalisierung - Q behalten, R ist nur für i=d wichtig für Initialisierung der Q_k bei k=d
% Falls Bestehender Classifier erweitert wird (z.B. Anpassung der
% Regularisierung nach Sweeps)
if not(isempty(varargin))
    x=varargin{1};
    for i=1:d
        r(i)=size(x{i},1);
    end
else 
    x=cell(1,d);
    for i=1:d % Belegung & Normierung
      x{i}=randn(r(i),n+1,r(i+1));
    end
    x=frnorm(x);
end

%Sukzessive QR-Zerlegung der Cores nach Alternating Linear Scheme
R=1;
for i=1:d 
    temp=R*unfold_r(x{i});
    r(i)=size(R,1);
    temp=reshape(temp, r(i)*(n+1), r(i+1));
    [Q,R]=qr(temp,0);
    x{i}=reshape(Q, r(i), n+1, size(Q,2));
end

%% Initialisierung der p_i(x),q_i(x), a_i(x), e_i(x)
% p_1(x)=1 nach Skript, da Sweeps von links beginnen, q_2 bis q_d 
%AE = 1xd+1-Cell, 1. & d+1.te Stelle sind Nx1-Vektor mit Einereinträgen -
%Cell der a_n, e_n für Regularisierung nach Thikonov
%PQ = 1xd+1-Cell, Index i: Indizes 1 bis i sind P_i, i+1 bis d+1 sind Q_i

PQ=cell(1,d+1);
PQ{d+1}=ones(N,r(d+1)); 
AE=cell(1,d+1);
AE{1}=1; AE{d+1}=1;

for i=d:-1:2
    temp=unfold_l(x{i})*R; %Orthogonalität nach ALS
    r(i+1)=size(R,2);
    temp=reshape(temp, r(i), (n+1)*r(i+1));
    [Q,R]=qr(temp',0);    Q=Q';    R=R';
    x{i}=reshape(Q, size(Q,1), n+1, r(i+1));
    Phi=basis(a(:,i),n,N,bv); %Basisvektoren an a(:,i)
    PQ{i}=dotkron(Phi, PQ{i+1})*Q';
    
    temp=unfold_r(permute(x{i},[2 1 3]));
    temp=sum(dotkron(temp,temp));
    temp=permute(reshape(temp, size(Q,1), r(i+1), size(Q,1), r(i+1)), [1 3 2 4]);
    AE{i}=reshape(temp, size(Q,1)^2, r(i+1)^2)*AE{i+1};
end
temp=unfold_l(x{1})*R;
r(2)=size(R,2);
x{1}=reshape(temp,r(1),n+1,r(2));
PQ{1}=ones(N,r(1));


er0=1e6; devi=1; %Startwerte
sc=0; res={};
while devi>1e-2
    dir=mod(sc,2);
    re=zeros(1,(d-1));
    index=0;
    if dir==0
        %LR-Sweep
        for j=1:d-1
            Phi=basis(a(:,j),n,N,bv);
            C=dotkron(PQ{j},Phi,PQ{j+1});
            
            % Regularisierung nach Tikhonov - Blockdarstellung von D_j
            vn=kron(reshape(AE{j+1}, r(j+1), r(j+1)), reshape(AE{j}, r(j), r(j)));
            D=kron(eye(n+1), vn');
            D=reshape(D, r(j), r(j+1), n+1, r(j), r(j+1), n+1);
            D=permute(D, [1 3 2 4 6 5]);
            D=reshape(D, r(j)*(n+1)*r(j+1), r(j)*(n+1)*r(j+1));
            
            y=(C'*C +gamma*D)\(C'*b);
            
            index=index+1;
            re(index)=norm(C*y-b)^2/2 + gamma/2*(y'*D*y);     % Regularisiertes LS
        
%             eval=[j re(j)]
%             save TTLeastSquares.txt eval -ascii -append 
        
            U=reshape(y, r(j)*(n+1), r(j+1));  %U_k=reshape(G_k^*, r_{k-1}n_k,r_k)
            [Q,R]=qr(U,0);    %QR-Zerlegung von U_k
            x{j+1}=R*unfold_r(x{j+1}); %V_k+1
            r(j+1)=size(Q,2);
            x{j+1}=reshape(x{j+1}, r(j+1), n+1, r(j+2)); %G_k+1
            x{j}=reshape(Q, r(j), n+1, r(j+1)); %G_k
            PQ{j+1}=dotkron(PQ{j}, Phi)*Q;
            
            temp=unfold_r(permute(x{j},[2 1 3]));
            temp=sum(dotkron(temp,temp));
            temp=permute(reshape(temp, r(j), size(Q,2), r(j), size(Q,2)), [1 3 2 4]);
            AE{j+1}=AE{j}*reshape(temp, r(j)^2, size(Q,2)^2);
        end
    else 
        %RL-Sweep
        for j=1:d-1
            ind=d-j+1;
            Phi=basis(a(:,ind),n,N,bv);
            C=dotkron(PQ{ind},Phi,PQ{ind+1});
            
            % Regularisierung nach Tikhonov - Blockdarstellung von D_j
            vn=kron(reshape(AE{ind+1}, r(ind+1), r(ind+1)), reshape(AE{ind}, r(ind), r(ind)));
            D=kron(eye(n+1), vn');
            D=reshape(D, r(ind), r(ind+1), n+1, r(ind), r(ind+1), n+1);
            D=permute(D, [1 3 2 4 6 5]);
            D=reshape(D, r(ind)*(n+1)*r(ind+1), r(ind)*(n+1)*r(ind+1));
            
            y=(C'*C +gamma*D)\(C'*b);
            index=index+1;
            re(index)=norm(C*y-b)^2/2 + gamma/2*(y'*D*y);     % Regularisiertes LS
            
%             eval=[index re(index)]
%             save TTLeastSquares.txt eval -ascii -append 
            
            U=reshape(y, r(ind),(n+1)*r(ind+1));
            [Q,R]=qr(U',0);    Q=Q';    R=R';
            x{ind-1}=unfold_l(x{ind-1})*R; %V_k-1
            r(ind)=size(Q,1);
            x{ind-1}=reshape(x{ind-1}, r(ind-1), n+1, r(ind)); %G_j-1
            x{ind}=reshape(Q, r(ind), n+1, r(ind+1)); %G_j
            PQ{ind}=dotkron(Phi, PQ{ind+1})*Q';
            
            temp=unfold_r(permute(x{ind}, [2 1 3]));
            temp=sum(dotkron(temp,temp));
            temp=permute(reshape(temp, size(Q,1), r(ind+1), size(Q,1), r(ind+1)), [1 3 2 4]);
            AE{ind}=reshape(temp, size(Q,1)^2, r(ind+1)^2)*AE{ind+1};
        end
    end
    % Fortschritt seit letztem Sweep
    if sc==0
        devi=abs(er0-re(end))/er0;
    else
        devi=abs(res{end}(end)-re(end))/abs(res{end}(end));
    end
    sc=sc+1;
    res=cat(2,res,re);
end
res=reshape(cell2mat(res),[],1);
end