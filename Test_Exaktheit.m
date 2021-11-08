%% Experiment 1 - Exaktheitstest
% Part 1: Exaktheit
% Part 2: Verzerrte Labels
%       #1: Hoeherer Rang Erzeugertensor als Test-Tensor
%       #2: Verzerrung mittels White Noise
dataset='Data_usps';
d=20; % Ordnung des Koeffiziententensors A
gamma=1e-2; % Regularisierungsfaktor
bv=1; % ID der Basis

temp=load(dataset,'feature','labels','tlabels');
feature=temp.feature;
N=length(temp.labels);

p=(d-20)/5+1; %d-10 for mnist/fmnist, -20 for usps - 10-40 vs 20-40
fimgs=feature{p}(1:N, :);    ftimgs=feature{p}((N+1):end,:);

%% Part 1 Setup für Grafik, n=[5,4,3,2,1];
% n=[5,4,3,2,1];
% r=10;
% res=cell(1,5);
% diff=ones(1,5);
% maxd=ones(1,5);
% avgd=ones(1,5);
% avgdt2=ones(1,5);
% re=ones(1,5);
% 
% r=r*ones(1,d+1);
% r(1)=1; r(d+1)=1;
% for j=1:5
%     rng('default');
%     %Initialisierung eines zufälligen Classifiers
%     x=cell(1,d);
%     for i=1:d % Belegung & Normierung
%         x{i}=randn(r(i),n(j)+1,r(i+1));
%     end
%     x=frnorm(x);
%     genlabel=TTC(fimgs,x,bv);
%     %genlabel=awgn(genlabel,100,'measured',42);
%     %rng('default');
%     %r=10;
%     [y,res{j}]=TTLeastSquares(fimgs,genlabel,n(j),r,gamma,bv);
%     
%     classlabel=TTC(fimgs,y,bv);
%     diff(j)=sum(abs(classlabel-genlabel));
%     maxd(j)=max(abs(classlabel-genlabel));
%     %avgd(j)=sum(abs(classlabel-genlabel))/N;
%     avgdt2(j)=sum(abs(classlabel-genlabel).^2)/length(classlabel);
% 
%     re(j)=res{j}(end);
% end
% diff
% maxd
% avgdt2
% re
% 
% j=size(res{1},1);
% for i=2:5
%     if(j>size(res{i},1))
%         j=size(res{i},1);
%     end
% end
% semilogy(1:j,res{5}(1:j),'Color','#0073c8'); %blue '0073c8'
% hold on
% semilogy(1:j,res{4}(1:j),'Color','#009c00'); %green '009c00'
% semilogy(1:j,res{3}(1:j),'Color','#cc9c00'); %gold 'cc9c00'
% semilogy(1:j,res{2}(1:j),'Color','#960000'); %dark red '960000'
% semilogy(1:j,res{1}(1:j),'Color','#000000'); %black '000000'
% legend({' n=1',' n=2',' n=3',' n=4',' n=5'},'Location','northeast');
% 
% hold off
% save test_exaktheit.mat j res d n r gamma bv diff maxd avgdt2 re
% saveas(gcf,'4_3_Exp1_Plot_espc','epsc')

%% Part 2: Setup mit Verzerrung der Daten mittels Hohem Erzeugerrang / Gaussian Noise
n=5;  % Höchster Grad der Basisfunktionen
r=10;  % TT-Rang der TT-Kerne zur Erzeugung der Labels für #1
rng('default');
%Initialisierung eines zufälligen Classifiers
r=r*ones(1,d+1);
r(1)=1; r(d+1)=1;
x=cell(1,d);
for i=1:d % Belegung & Normierung
    x{i}=randn(r(i),n+1,r(i+1));
end
x=frnorm(x);
genlabel=TTC(fimgs,x,bv);
%r=10; % TT-Rang der TT-Kerne zur Exaktheitsprüfung, nur bei #1
genlabel=awgn(genlabel,20,'measured',42); %Gaussian Noise für #2
[y,res]=TTLeastSquares(fimgs,genlabel,n,r,gamma,bv);

classlabel=TTC(fimgs,y,bv);
diff=sum(abs(classlabel-genlabel)) %Delta
maxd=max(abs(classlabel-genlabel)) %DeltaMax
%avgd=sum(abs(classlabel-genlabel))/N
avgdt2=sum(abs(classlabel-genlabel).^2)/length(classlabel) %Varianz
res(end) %J(A)

% %Späße mit Testdaten, nicht relevant ggü. Test
% gentlabel=TTC(ftimgs,x,bv);
% classtlabel=TTC(ftimgs,y,bv);
% difft=sum(abs(classtlabel-gentlabel))
% maxdt=max(abs(classtlabel-gentlabel))
% avgdt2=sum(abs(classtlabel-gentlabel).^2)/length(classtlabel)
% 
% clr=(classlabel>median(classlabel));
% glr=(genlabel>median(classlabel));
% labeldiff=sum(clr~=glr)
