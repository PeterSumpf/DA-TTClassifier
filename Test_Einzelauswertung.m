%% Experiment 3 - Auswertungsmatrix zur Fehlerbestimmung

dataset='Data_usps'; % 'Data_fmnist' / 'Data_usps' / 'Data_mnist'
d=20; % Ordnung des Koeffiziententensors A
n=2;  % Höchster Grad der Basisfunktionen
r=10;  % TT-Rang der TT-Kerne
gamma=1e-2; % Regularisierungsfaktor
bv=1; % ID der Basis
dec='ecoc'; % Wahl der Entscheidungsstrategie: 'ova','ovo','doc','ecoc'


x=cell(1,1); res=cell(1,1); t=ones(1,1); ind=cell(1,1); indt=cell(1,1);
rng('default');
[x{1},res{1},t(1),ind{1},indt{1}]=runtime(dataset,dec,d,n,r,gamma,bv);


%% Evaluation
% Label Errors
temp=load(dataset,'labels','tlabels');
er=zeros(2,1);
er(1,1)=sum(ind{1}~=temp.labels)/length(temp.labels);
er(2,1)=sum(indt{1}~=temp.tlabels)/length(temp.tlabels);

retrain=[ind{1}, temp.labels];
retest=[indt{1}, temp.tlabels];



tempA=zeros(10,10);
tempB=zeros(10,10);
trainsize=length(retrain);
testsize=length(retest);
for i=1:trainsize
tempA(retrain(i,1)+1,retrain(i,2)+1)=tempA(retrain(i,1)+1,retrain(i,2)+1)+1;
end
for i=1:testsize
tempB(retest(i,1)+1,retest(i,2)+1)=tempB(retest(i,1)+1,retest(i,2)+1)+1;
end

%save fmnist_1_40_10_laguerre_ovo.mat x res t tempA tempB
tempB