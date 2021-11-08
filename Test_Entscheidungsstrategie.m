%% Experiment 2 - Effizienzvergleich der Entscheidungsstrategien

dataset='Data_mnist'; % 'Data_fmnist' / 'Data_usps' / 'Data_mnist'
str={'ova','ovo','doc','ecoc'};

d=20; % Ordnung des Koeffiziententensors A
n=2;  % Höchster Grad der Basisfunktionen
r=10;  % TT-Rang der TT-Kerne
gamma=1e-2; % Regularisierungsfaktor
bv=1; % ID der Basis


x=cell(1,4); res=cell(1,4); t=ones(1,4); ind=cell(1,4); indt=cell(1,4);
for j=1:4
    rng('default');
%     [x{j},res{j},ind{j},indt{j}]=runtime(dataset,str{j},labeltype,d,n,r,gamma,bv);
    [x{j},res{j},t(j),ind{j},indt{j}]=runtime(dataset,str{j},d,n,r,gamma,bv);
end


%% Evaluation
% Label Errors
temp=load(dataset,'labels','tlabels');
er=zeros(2,4);
for j=1:4
er(1,j)=sum(ind{j}~=temp.labels)/length(temp.labels);
er(2,j)=sum(indt{j}~=temp.tlabels)/length(temp.tlabels);
end

temp=[n,d,r];
save Batch.txt temp t er -ascii -append 

% Plotting
% temp=cell(1,4);
% temp2=cell(1,4);
% for j=1:4
%     temp{j}=cellmed(res{j});
%     temp2{j}=cellmax(res{j});
% end
% sc=size(temp{1},1);
% semilogy(1:sc, temp{1},'black')
% hold on
% semilogy(1:sc, temp{2},'yellow')
% semilogy(1:sc, temp{3},'cyan')
% semilogy(1:sc, temp{4},'red')
% legend('One-vs-All', 'One-vs-One', 'DOC', 'ECOC')
% hold off

%% Auswertung
% doc ist müll, zu viele Fehlerquellen, keine Korrekturmöglichkeiten
% ova & ecoc sind gleichwertig, ecoc besser bei längeren Läufen
% ovo hat Hang zur Überbestimmung durch viele kleine Klassifikationen,
% zus. Mehrheitsvoting kann Mehrere Maxima haben > Fehlerquelle

% Besser für Grafik: Langer durchlauf mit max. Sweepcount (99 bzw. 100 der
% Schönheit halber)
% function y=cellmed(res)
% temp=zeros(length(res{1}),length(res));
% for j=1:length(res)
%    temp(:,j)=res{j};
% end
% y=median(temp,2);
% end
% 
% function y=cellmax(res)
% temp=zeros(length(res{1}),length(res));
% for j=1:length(res)
%    temp(:,j)=res{j};
% end
% y=max(temp,[],2);
% end