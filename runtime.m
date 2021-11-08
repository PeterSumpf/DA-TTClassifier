function [x,res,t,ind,indt]=runtime(dataset,str,d,n,r,gamma,bv,varargin)
% [x, res,t,ind,indt]=runtime(dataset, str, d, n, r, gamma, bv) oder [x, res,t,ind,indt]=runtime(dataset, str, d, n, r, gamma, bv, x0)
% -------------------------------------------------------------------------
% Realisierung des Algorithmus fuer sequentielle Durchlaeufe
%
% x         =   Cell, beinhaltet TT-Kerne des Classifiers
% res		=	Vektor, beinhaltet LS-Funktionswert jedes Schritts
% t			=	Skalar, benoetigte Zeit des Durchlaufes
% ind		=	Vektor, beinhaltet Indizes der Trainings-Labels
% indt		=	Vektor, beinhaltet Indizes der Test-Labels
%
% dataset	=   String, Wahl des Datensatzes
% str		=   String, Wahl der Entscheidungsstrategie
% d			=	Skalar, Dimension des Classifiers
% n			=	Skalar, Grad des Classifiers
% r         =   Skalar, Rang der TT-Kerne des Classifiers 
% gamma		=   Skalar, Regularisierungsparameter
% bv 		=	Skalar, Index der Basisfunktion im Mapping (vgl. Basis.m)
% x0 		=	Cell, optionaler Startwert des Classifiers-TTs. Wenn ein TT
% 				gegeben ist werden Raenge des TT-Classifiers uebernommen.
temp=load(dataset,'feature','labels','tlabels');
feature=temp.feature;
labels=temp.labels;
tlabels=temp.tlabels;

trainingsize=size(labels,1);      testsize=size(tlabels,1);
p=(d-20)/5+1; %d-10 for mnist/fmnist, -20 for usps - 10-40 vs 20-40
fimgs=feature{p}(1:trainingsize, :);    ftimgs=feature{p}((trainingsize+1):end,:);

%% Wenn x aus früherem Durchlauf fortgesetzt wird, verwende dieses x0
if not(isempty(varargin))
    xi=varargin{1};
    for i=1:d
        r(i)=size(xi{i},1);
    end
end
if bv==7||bv==8||bv==10||bv==11 %Automatische Skalierung der Labels, evtl. schlechter als fix [0,1]
    labeltype=0;
else
    labeltype=-1;
end

%% Wahl der Entscheidungsstrategie, Adaption der Labels
switch str
    case 'ovo'
        % Realisierung Jeder-gegen-Jeden
        % Läd 1v1-Labelmatrix
        rfl=strat('ova',str,dataset);
        if labeltype==-1
            y=[-1,1];
        else
            y=[0,1];
        end
        % Aufteilung des Datasets nach Klasse
        fimg=cell(1,10);
        for j=1:10
            fimg{j}=fimgs(~all(rfl(:,j)==-1,2),:); % Löscht alle Zeilen in fimgs, deren Label ungleich j-1 ist
        end
        % Erstellen von n(n-1)/2 Label-Paaren & Ingest des nötigen
        % Datensatzes
        a=0; m=45;
        rfl=cell(1,m);
        fimg_ovo=cell(1,m);
        for j=1:9
            for i=j+1:10
                a=a+1;
                fimg_ovo{a}=[fimg{j};fimg{i}];
                rfl{a}=[ones(length(fimg{j}),1)*y(2);ones(length(fimg{i}),1)*y(1)];
            end
        end
    otherwise
        rfl=strat(labeltype,str,dataset);
end

%% Überprüfung Skalierung bei Stoudenmire / Linear - x in [0,1] statt [-1,1]
if bv==7||bv==8||bv==10||bv==11
    switch str
        case 'ovo'
            fimg_ovo=(fimg_ovo+1)/2;
        otherwise
            fimgs=(fimgs+1)/2;
    end
    ftimgs=(ftimgs+1)/2;
end
%% Generation der m Classifier, abhängig von der gew. Entscheidungsstrategie
m=size(rfl,2);
x=cell(m,1);   res=cell(m,1);
timer=tic;
for j=1:m
    switch str
        case 'ovo'
            [x{j}, res{j}]=TTLeastSquares(fimg_ovo{j}, rfl{j}, n, r, gamma, bv);
        otherwise
            [x{j}, res{j}]=TTLeastSquares(fimgs, rfl(:,j), n, r, gamma, bv);
    end
end
t=toc(timer);
%% Labelerzeugung mittels TTC
score=zeros(trainingsize, m);
tscore=zeros(testsize,m);
for j=1:m
    score(:,j) =TTC(fimgs,  x{j},bv);
    tscore(:,j)=TTC(ftimgs, x{j},bv);
end
ind=check(str,score,labeltype);
%train_err=sum(ind~=labels)/trainingsize

indt=check(str,tscore,labeltype);
%test_err=sum(indt~=tlabels)/testsize
end