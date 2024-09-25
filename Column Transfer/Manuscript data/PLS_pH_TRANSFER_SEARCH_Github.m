function RESULTS=PLS_pH_TRANSFER_SEARCH_Github(X_CAL,Y_CAL,ind_table,COL,pH_A,pH_B)
%
% pH_A and pH_B have to be input as string. 
%

temp_A=ind_table.samp(ind_table.Column==COL & ind_table.PH==pH_A);
temp_B=ind_table.samp(ind_table.Column==COL & ind_table.PH==pH_B);

Compound_A=ind_table.Compound(temp_A,:);
Compound_B=ind_table.Compound(temp_B,:);

X_CAL_A=X_CAL(temp_A,:);
Y_CAL_A=Y_CAL(temp_A,:);

X_CAL_B=X_CAL(temp_B,:);
Y_CAL_B=Y_CAL(temp_B,:);

UNIQUE_LIST=FIND_UNIQUE(string([Compound_A;Compound_B]));
% size(UNIQUE_LIST)
Y_SEL_A=[];
X_SEL_A=[];
Y_SEL_B=[];
X_SEL_B=[];
Compound=string;

for i=1:length(UNIQUE_LIST)
    ind_A=find(Compound_A==UNIQUE_LIST(i,:))
    ind_B=find(Compound_B==UNIQUE_LIST(i,:))

    if isempty(ind_A) | isempty(ind_B)
        X_SEL_A=X_SEL_A;
        Y_SEL_A=Y_SEL_A;
        X_SEL_B=X_SEL_B;
        Y_SEL_B=Y_SEL_B;
        Compound=Compound;
    else

        disp('pH_A=pH_B')
        X_SEL_A(size(X_SEL_A,1)+1,:)=X_CAL_A(ind_A,:);
        Y_SEL_A(size(Y_SEL_A,1)+1,:)=Y_CAL_A(ind_A,:);

        X_SEL_B(size(X_SEL_B,1)+1,:)=mean(X_CAL_B(ind_B,:),1);
        Y_SEL_B(size(Y_SEL_B,1)+1,:)=mean(Y_CAL_B(ind_B,:),1);
        Compound(size(Compound,1)+1,:)=UNIQUE_LIST(i,:);
    end
end

RESULTS.X_SEL_A=X_SEL_A;
RESULTS.X_SEL_B=X_SEL_B;
RESULTS.Y_SEL_A=Y_SEL_A;
RESULTS.Y_SEL_B=Y_SEL_B;
RESULTS.Compound=Compound(2:end,:);

figure

if length(Y_SEL_A)==length(Y_SEL_B)
    plot(Y_SEL_A,Y_SEL_B,'ro')
    title(COL)
    xlabel(['measured Rt on pH=' pH_A '(min)'])
    ylabel(['measured Rt on pH=' pH_B '(min)'])
else
end



