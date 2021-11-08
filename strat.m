function labels=strat(y,str,dataset)
% labels=strat(y,str,dataset)
% ------------------------------------------------------------
% Laden der noetigen Labels 
%
% labels    =   Vektor, beinhaltet Labels
%
% y			=	Skalar, Grad des Classifiers
% str		=   String, Bestimmung der Entscheidungsstrategie
% dataset	=   String, Bestimmung des Datensatzes
switch str
    case 'ova'
        if y~=0
            temp=load(dataset,'rflabels');
            labels=temp.rflabels;
        else
            temp=load(dataset,'rflabels01');
            labels=temp.rflabels01;
        end
    case 'doc'
        if y~=0
            temp=load(dataset,'rflabels_doc');
            labels=temp.rflabels_doc;
        else
            temp=load(dataset,'rflabels01_doc');
            labels=temp.rflabels01_doc;
        end
    case 'ecoc'
        if y~=0
            temp=load(dataset,'rflabels_ecoc');
            labels=temp.rflabels_ecoc;
        else
            temp=load(dataset,'rflabels01_ecoc');
            labels=temp.rflabels01_ecoc;
        end
    otherwise
        if y~=0
            temp=load(dataset,'rflabels');
            labels=temp.rflabels;
        else
            temp=load(dataset,'rflabels01');
            labels=temp.rflabels01;
        end
end
end