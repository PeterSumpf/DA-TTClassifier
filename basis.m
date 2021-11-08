function phi=basis(x,n,N,bv)
% phi = basis(varargin)
% -------------------------------------------------------------------------
% Auswertung der Feature-Map an der aktuellen Stelle und Basis
%
% phi	=	Matrix, Ausgewertete Feature-Map
% 
% x		=   Vektor, Feature-Map an aktuellem Index
% n		=	Skalar, Grad des Classifiers
% N		=   Skalar, Groesse des Datensatzes
% bv	=	Skalar, Index der Basisfunktion im Mapping
%% Moegliche Basis-Indizes
% 1:	Vandermonde-Basis
% 2:	Legendre-Polynome
% 3:	Hermit-Polynome Physicists'
% 4:	Hermit-Polynome Probabilists'
% 5:	Chebyshev-Polynome 1. Art
% 6:	Chebyshev-Polynome 2. Art
% 7:	Stoudemire's Quantenrichtung
% 8:	Variierter Stoudemire mit variablem a
% 9:	Gausskern, verschiedene Sigmas

switch bv
    case 1
        %% Vandermonde-Polynome
        phi=repmat(x,1,n+1).^(kron(0:n,ones(N,1)));
    case 2
        %% Legendre-Polynome     
        switch n
            case 1
                phi=[ones(N,1), x];
            case 2
                phi=[ones(N,1), x, (3*x.^2)/2 - 1/2];
            case 3
                phi=[ones(N,1), x, (3*x.^2)/2 - 1/2, (5*x.^3)/2 - (3*x)/2];
            case 4
                phi=[ones(N,1), x, (3*x.^2)/2 - 1/2, (5*x.^3)/2 - (3*x)/2, (35*x.^4)/8 - (15*x.^2)/4 + 3/8]; 
            case 5
                phi=[ones(N,1), x, (3*x.^2)/2 - 1/2, (5*x.^3)/2 - (3*x)/2, (35*x.^4)/8 - (15*x.^2)/4 + 3/8, (63*x.^5)/8 - (35*x.^3)/4 + (15*x)/8];
            case 6
                phi=[ones(N,1), x, (3*x.^2)/2 - 1/2, (5*x.^3)/2 - (3*x)/2, (35*x.^4)/8 - (15*x.^2)/4 + 3/8, (63*x.^5)/8 - (35*x.^3)/4 + (15*x)/8, (231*x.^6)/16 - (315*x.^4)/16 + (105*x.^2)/16 - 5/16];
            otherwise
                disp('Die verwendete Basis ist nicht für n>6 definiert.')
        end
    case 3
        %% Hermite Polynomials (Physicists')
        switch n
            case 1
                phi=[ones(N,1), 2*x];
            case 2
                phi=[ones(N,1), 2*x, 4*x.^2 - 2];
            case 3
                phi=[ones(N,1), 2*x, 4*x.^2 - 2,8*x.^3 - 12*x];
            case 4
                phi=[ones(N,1), 2*x, 4*x.^2 - 2,8*x.^3 - 12*x, 16*x.^4 - 48*x.^2 + 12];
            case 5
                phi=[ones(N,1), 2*x, 4*x.^2 - 2,8*x.^3 - 12*x, 16*x.^4 - 48*x.^2 + 12, 32*x.^5 - 160*x.^3 + 120*x];
            case 6
                phi=[ones(N,1), 2*x, 4*x.^2 - 2,8*x.^3 - 12*x, 16*x.^4 - 48*x.^2 + 12, 32*x.^5 - 160*x.^3 + 120*x, 64*x.^6 - 480*x.^4 + 720*x.^2 - 120];
            otherwise
                disp('Die verwendete Basis ist nicht für n>6 definiert.')
        end 
    case 4
        %% Hermite Polynomials (Probabilists')
        switch n
            case 1
                phi=[ones(N,1), x];
            case 2
                phi=[ones(N,1), x, x.^2-1];
            case 3
                phi=[ones(N,1), x, x.^2-1, x.^3-3*x];
            case 4
                phi=[ones(N,1), x, x.^2-1, x.^3-3*x, x.^4-6*x.^2+3];
            case 5
                phi=[ones(N,1), x, x.^2-1, x.^3-3*x, x.^4-6*x.^2+3, x.^5-10*x.^3+15*x];
            case 6
                phi=[ones(N,1), x, x.^2-1, x.^3-3*x, x.^4-6*x.^2+3, x.^5-10*x.^3+15*x, x.^6-15*x.^4+45*x.^2-15];
              otherwise
                disp('Die verwendete Basis ist nicht für n>6 definiert.')
        end 
    case 5
        %% Chebyshev-Polynome 1. Art
        switch n
            case 1
                phi=[ones(N,1), 2*x];
            case 2
                phi=[ones(N,1), 2*x, 4*x.^2-1];
            case 3
                phi=[ones(N,1), 2*x, 4*x.^2-1, 8*x.^3-4*x];
            case 4
                phi=[ones(N,1), 2*x, 4*x.^2-1, 8*x.^3-4*x, 16*x.^4-12*x.^2+1];
            case 5
                phi=[ones(N,1), 2*x, 4*x.^2-1, 8*x.^3-4*x, 16*x.^4-12*x.^2+1, 32*x.^5-32*x.^3+6*x];
            case 6
                phi=[ones(N,1), 2*x, 4*x.^2-1, 8*x.^3-4*x, 16*x.^4-12*x.^2+1, 32*x.^5-32*x.^3+6*x, 64*x.^6-80*x.^4+24*x.^2-1];
            otherwise
                disp('Die verwendete Basis ist nicht für n>6 definiert.')
        end
                
    case 6
        %% Chebyshev-Polynome 2. Art
        switch n
            case 1
                phi=[ones(N,1), x];
            case 2
                phi=[ones(N,1), x, 2*x.^2-1];
            case 3
                phi=[ones(N,1), x, 2*x.^2-1, 4*x.^3-3*x];
            case 4
                phi=[ones(N,1), x, 2*x.^2-1, 4*x.^3-3*x, 8*x.^4-8*x.^2+1];
            case 5
                phi=[ones(N,1), x, 2*x.^2-1, 4*x.^3-3*x, 8*x.^4-8*x.^2+1, 16*x.^5-20*x.^3+5*x];
            case 6
                phi=[ones(N,1), x, 2*x.^2-1, 4*x.^3-3*x, 8*x.^4-8*x.^2+1, 16*x.^5-20*x.^3+5*x, 32*x.^6-48*x.^4+18*x.^2-1];
            otherwise
                disp('Die verwendete Basis ist nicht für n>6 definiert.')
        end
    case 7
        %% Alternativ: Stoudenmire's Approach mit Quantenrichtung für n=1
        % Für Bereich [0,1] verwendbar und nur für n=1
        % Phi.^n(x_j)=[cos(pi/2*x_j), sin(pi/2 * x_j)]
%         switch n
%             case 1
%                 phi=[ones(N,1) cos(pi*x)];
%             case 2
%                 phi=[ones(N,1) cos(pi*x) sin(pi*x)];
%             case 3
%                 phi=[ones(N,1) cos(pi*x) sin(pi*x) cos(2*pi*x)];
%             case 4
%                 phi=[ones(N,1) cos(pi*x) sin(pi*x) cos(2*pi*x) sin(2*pi*x)];
%             otherwise
%                 error('Diese Basis ist für n ungleich 1 nicht verwendbar!');
%         end
        if n~=1
           error('Diese Basis ist für n ungleich 1 nicht verwendbar.');
        else
           alpha = pi/2;
           phi=[cos(alpha*x) sin(alpha*x)];
        end
    case 8
        %% Alternativ: Variierter Stoudenmire-Approach nach Stefah Nklus / Patrick Geiß
        % Funktioniert nicht wie gewünscht
        % Phi.^n(x_j)=[cos(alpha x), sin(alpha x)]
        if n~=1
           error('Diese Basis ist für n ungleich 1 nicht verwendbar.');
        else
           alpha = 0.59; %empirisch gefundener "idealer" Wert für MNIST
           phi=[cos(alpha*x) sin(alpha*x)];
        end
        
    case 9
        %% Gaußkerne, variables Sigma, Sigma-Wahl nach Plot für "sinnvolle" y-Werte
%         sm=[2.9,1.1,0.79,0.6675,0.603,0.5636,0.537];
        sm=0.5*ones(6,1);
        switch n
            case 1
                phi=[ones(N,1), gk(x,sm(1),1)];
            case 2
                phi=[ones(N,1), gk(x,sm(1),1), gk(x,sm(2),2)];
            case 3
                phi=[ones(N,1), gk(x,sm(1),1), gk(x,sm(2),2), gk(x,sm(3),3)];
            case 4
                phi=[ones(N,1), gk(x,sm(1),1), gk(x,sm(2),2), gk(x,sm(3),3), gk(x,sm(4),4)];
            case 5
                phi=[ones(N,1), gk(x,sm(1),1), gk(x,sm(2),2), gk(x,sm(3),3), gk(x,sm(4),4), gk(x,sm(5),5)];
            case 6
                phi=[ones(N,1), gk(x,sm(1),1), gk(x,sm(2),2), gk(x,sm(3),3), gk(x,sm(4),4), gk(x,sm(5),5), gk(x,sm(6),6)];
            otherwise
                error('Die verwendete Basis ist nicht für n>6 definiert.');
        end
    case 10
        %% Linear
        if n~=1
           error('Die verwendete Basis ist für n ungleich 1 nicht verwendbar.');
        else
           alpha = 0.59; 
           phi=[alpha*x+(1-alpha), 1-alpha*x];
        end
    case 11
        %% Laguerre-Polynome
        switch n
            case 1
                phi=[ones(N,1), -x+1];
            case 2
                phi=[ones(N,1), -x+1, 1/2*(x.^2-4*x+2)];
            case 3
                phi=[ones(N,1), -x+1, 1/2*(x.^2-4*x+2), 1/6*(-x.^3+9*x.^2-18*x+6)];
            case 4
                phi=[ones(N,1), -x+1, 1/2*(x.^2-4*x+2), 1/6*(-x.^3+9*x.^2-18*x+6), 1/24*(x.^4-16*x.^3+72*x.^2-96*x+24)];
            case 5
                phi=[ones(N,1), -x+1, 1/2*(x.^2-4*x+2), 1/6*(-x.^3+9*x.^2-18*x+6), 1/24*(x.^4-16*x.^3+72*x.^2-96*x+24), 1/120*(-x.^5+25*x.^4-200*x.^3+600*x.^2-600*x+120)];
            case 6
                phi=[ones(N,1), -x+1, 1/2*(x.^2-4*x+2), 1/6*(-x.^3+9*x.^2-18*x+6), 1/24*(x.^4-16*x.^3+72*x.^2-96*x+24), 1/120*(-x.^5+25*x.^4-200*x.^3+600*x.^2-600*x+120), 1/720*(x.^6-36*x.^5+450*x.^4-2400*x.^3+5400*x.^2-4320*x+720)];
            otherwise
                error('Die verwendete Basis ist nicht für n>6 definiert.');
        end
    otherwise
        error('Basis mit dieser ID nicht verfügbar.');
end
end

function y=gk(x,sigma,m)
%Gaußkern mit Standardabweichung Sigma, m Dimension
% Gaußkern: y=1/sqrt(2*pi)*exp(-x.^2/2);
y=(2*pi*sigma^2)^(-m/2).*exp(-(abs(x).^2)/(2*sigma.^2));
end