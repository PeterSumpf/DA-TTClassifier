function ind=check(str,score,labeltype)
% ind=check(str, score, labeltype)
% --------------------------------------------------------
% Erzeugung der Labels
%
% ind		=	Vektor, beinhaltet Indizes der Labels
%
% str		=   String, Wahl der Entscheidungsstrategie
% score		=	Matrix, Kontraktion des Classifier-Tensors
% labeltype	=	Skalar, Bestimmung der Labelart
if labeltype==-1
    treshold=0;
    y=[-1,1];
else
    treshold=0.5;
    y=[0,1];
end
switch str
    case 'ova'
        [~, ind]=max(score,[],2);
        ind=ind-1;
    case 'doc'
        doc=[y(1),y(1),y(1),y(2),y(1),y(1);...
			 y(2),y(1),y(1),y(1),y(1),y(1);...
			 y(1),y(2),y(2),y(1),y(2),y(1);...
			 y(1),y(1),y(1),y(1),y(2),y(1);...
			 y(2),y(2),y(1),y(1),y(1),y(1);...
			 y(2),y(2),y(1),y(1),y(2),y(1);...
			 y(1),y(1),y(2),y(2),y(1),y(2);...
			 y(1),y(2),y(2),y(1),y(1),y(1);...
			 y(1),y(1),y(1),y(2),y(1),y(1);...
			 y(1),y(1),y(2),y(2),y(2),y(1)];
        N=size(score,1);
        a=zeros(N,10);
        for j=1:N
            for i=1:size(doc,2)
                if (score(j,i)>treshold)%==1
                    score(j,i)=y(2);
                else
                    score(j,i)=y(1);
                end
            end
            for i=1:10
                a(j,i)=sum(score(j,:)~=doc(i,:));
            end
        end
        [~,ind]=min(a,[],2);
        ind=ind-1; 
    case 'ecoc'
        ecoc=[y(2),y(2),y(1),y(1),y(1),y(1),y(2),y(1),y(2),y(1),y(1),y(2),y(2),y(1),y(2);...
			  y(1),y(1),y(2),y(2),y(2),y(2),y(1),y(2),y(1),y(2),y(2),y(1),y(1),y(2),y(1);...
			  y(2),y(1),y(1),y(2),y(1),y(1),y(1),y(2),y(2),y(2),y(2),y(1),y(2),y(1),y(2);...
			  y(1),y(1),y(2),y(2),y(1),y(2),y(2),y(2),y(1),y(1),y(1),y(1),y(2),y(1),y(2);...
			  y(2),y(2),y(2),y(1),y(2),y(1),y(2),y(2),y(1),y(1),y(2),y(1),y(1),y(1),y(2);...
			  y(1),y(2),y(1),y(1),y(2),y(2),y(1),y(2),y(2),y(2),y(1),y(1),y(1),y(1),y(2);...
			  y(2),y(1),y(2),y(2),y(2),y(1),y(1),y(1),y(1),y(2),y(1),y(2),y(1),y(1),y(2);...
			  y(1),y(1),y(1),y(2),y(2),y(2),y(2),y(1),y(2),y(1),y(2),y(2),y(1),y(1),y(2);...
			  y(2),y(2),y(1),y(2),y(1),y(2),y(2),y(1),y(1),y(2),y(1),y(1),y(1),y(2),y(2);...
			  y(1),y(2),y(2),y(2),y(1),y(1),y(1),y(1),y(2),y(1),y(2),y(1),y(1),y(2),y(2)];
        N=size(score,1);
        a=zeros(N,10);
        for j=1:N
            for i=1:size(ecoc,2)
                if (score(j,i)>=treshold)%==1
                    score(j,i)=y(2);
                else
                    score(j,i)=y(1);
                end
            end
            for i=1:10
                a(j,i)=sum((score(j,:))~=(ecoc(i,:)));
            end
        end
        [~,ind]=min(a,[],2);
        ind=ind-1; 
    case 'ovo'
         ovo=[1,1,1,1,1,1,1,1,1 ,2,2,2,2,2,2,2,2 ,3,3,3,3,3,3,3 ,4,4,4,4,4,4 ,5,5,5,5,5 ,6,6,6,6 ,7,7,7 ,8,8 ,9;...
              2,3,4,5,6,7,8,9,10,3,4,5,6,7,8,9,10,4,5,6,7,8,9,10,5,6,7,8,9,10,6,7,8,9,10,7,8,9,10,8,9,10,9,10,10]';
         N=size(score,1);
         a=zeros(N,10);
         for j=1:N
             for i=1:length(ovo)
                 if (score(j,i)>=treshold)
                     score(j,i)=ovo(i,1);
                 else
                     score(j,i)=ovo(i,2);
                 end
             end
             for i=1:10
                 a(j,i)=sum(score(j,:)==i);
             end
         end
         [~,ind]=max(a,[],2);
         ind=ind-1;
end
end