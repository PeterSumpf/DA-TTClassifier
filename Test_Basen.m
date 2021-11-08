%% Experiment 3 - Effizienzvergleich der Basisvarianten

% 1 - Vandermonde-Basis - [-1,1]
% 2 - Legendre-Polynome - [-1,1]
% 3 - Hermit-Polynome Physicists' - [-1,1] - SCHROTT
% 4 - Hermit-Polynome Probabilists' - [-1,1]
% 5 - Chebyshev-Polynome 1. Art - [-1,1] - SCHROTT
% 6 - Chebyshev-Polynome 2. Art - [-1,1]
% 7 - Stoudemire's Quantenrichtung - [0,1] - n=1 - SCHROTT
% 8 - Variierter Stoudemire mit variablem a - [0,1] - n=1
% 9 - Gausskern, verschiedene Sigmas - [-1,1]
% 10 - Linear - [0,1] - SCHROTT bei alpha =1, Vergleichbar bei 0.59
% 11 - Laguerre - [0,1]




dataset='Data_fmnist'; % 'Data_mnist' / 'Data_fmnist' / 'Data_usps'
% labeltype=-1; % -1 ~ y=[-1,1] bzw. 0 ~ y=[0,1] - Zu Orthogonalit‰tsbeschr‰nkungen der Verwendeten Basis
str='ecoc';

d=40; % Ordnung des Koeffiziententensors A
n=3;  % Hˆchster Grad der Basisfunktionen
r=4;  % TT-Rang der TT-Kerne | mom. stand: 8
gamma=1e-2; % Regularisierungsfaktor
bv=[1,2,4,6,9,11]; %Beliebiges n
% bv=[1,2,4,6,7,8,9,10,11]; n=1; % labeltype=0; %Fixes Label & n

m=length(bv);
x=cell(1,m); res=cell(1,m); t=ones(1,m); ind=cell(1,m); indt=cell(1,m);
for j=1:m
    rng('default');
    [x{j},res{j},t(j),ind{j},indt{j}]=runtime(dataset,str,d,n,r,gamma,bv(j));
end


%% Evaluation
% Label Errors
temp=load(dataset,'labels','tlabels');
er=zeros(2,m);
for j=1:m
er(1,j)=sum(ind{j}~=temp.labels)/length(temp.labels);
er(2,j)=sum(indt{j}~=temp.tlabels)/length(temp.tlabels);
end
t
er
temp=[n,d,r];
save Batch.txt temp t er -ascii -append 

% % Plotting
% temp=cell(1,m);
% temp2=cell(1,m);
% for j=1:m
%     temp{j}=celleval(res{j},'mean');
%     temp2{j}=celleval(res{j},'max');
% end
% sc=size(temp{1},1);
% semilogy(1:sc, temp{1},'black')
% hold on
% semilogy(1:sc, temp{2},'yellow')
% semilogy(1:sc, temp{3},'cyan')
% semilogy(1:sc, temp{4},'red')
% semilogy(1:sc, temp{5},'magenta')
% semilogy(1:sc, temp{6},'green')
% semilogy(1:sc, temp{7},'blue')
% % semilogy(1:sc, temp{8},':black')
% % semilogy(1:sc, temp{9},':yellow')
% % semilogy(1:sc, temp{10},':cyan')
% % semilogy(1:sc, temp{11},':red')
% legend('Vandermonde', 'Legendre', 'Hermit I', 'Hermit II', 'Chebyshev I', 'Chebyshev II', 'Gauﬂkerne');
% % legend('Vandermonde', 'Legendre', 'Hermit I', 'Hermit II', 'Chebyshev I', 'Chebyshev II', 'Gauﬂkerne', 'Laguerre');
% % legend('Vandermonde', 'Legendre', 'Hermit I', 'Hermit II', 'Chebyshev I', 'Chebyshev II', 'Stoudenmire', 'Var. Stoudenmire', 'Gauﬂkerne', 'Linear', 'Laguerre');
% hold off
% 
% function y=celleval(res, func)
% %% Berechnung versch. Aggregationen der *existenten* Werte eines Cell-Array mit verschiedenen L‰ngen.
% [~,id] = sort(cellfun(@length, res));
% res=res(id); %Cell Array, aufst. nach L‰nge sortiert 
% order=[0; cellfun(@length, res)]; %L‰nge der einzelnen Arrays
% y=zeros(order(end),1);
% for j=1:length(res)
%     %Reduzierung des Arrays auf "aktuellen Abschnitt"
%     temp=cell(1,length(res)+1-j);
%     temp{1}=res{j}(order(j)+1:order(j+1),:);
%     if j~=length(res)
%         for i=j+1:length(res)
%             temp{i}=res{i}(order(j)+1:order(j+1),:);
%         end
%     end
%     temp=cat(2,temp{:});
%     switch func
%         case 'mean'
%             y(order(j)+1:order(j+1),:)=mean(temp,2);
%         case 'max'
%             y(order(j)+1:order(j+1),:)=max(temp,[],2);
%         otherwise
%             y(order(j)+1:order(j+1),:)=mean(temp,2);
%     end
% end
% end