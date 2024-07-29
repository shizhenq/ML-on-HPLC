function RESULTS=HPLC_COLUMN_TRANSFER_SEARCH(X_CAL,Y_CAL,ind_table,COL_A,COL_B)


temp_A=ind_table.samp(ind_table.column==COL_A);
temp_B=ind_table.samp(ind_table.column==COL_B);

Gnum_A=ind_table.Gnum(temp_A,:);
Gnum_B=ind_table.Gnum(temp_B,:);

X_CAL_A=X_CAL(temp_A,:);
Y_CAL_A=Y_CAL(temp_A,:);

X_CAL_B=X_CAL(temp_B,:);
Y_CAL_B=Y_CAL(temp_B,:);

UNIQUE_LIST=FIND_UNIQUE(string([Gnum_A;Gnum_B]));

Y_SEL_A=[];
X_SEL_A=[];
Y_SEL_B=[];
X_SEL_B=[];
Gnum=string;

for i=1:length(UNIQUE_LIST)
    ind_A=find(Gnum_A==UNIQUE_LIST(i,:));
    ind_B=find(Gnum_B==UNIQUE_LIST(i,:));
    
    if isempty(ind_A) | isempty(ind_B)
        X_SEL_A=X_SEL_A;
        Y_SEL_A=Y_SEL_A;
        X_SEL_B=X_SEL_B;
        Y_SEL_B=Y_SEL_B;
        Gnum=Gnum;
    elseif length(ind_A)==length(ind_B)

        for k=1:length(ind_A)
            temp=X_CAL_A(ind_A(k),end)-X_CAL_B(ind_B,end);  %given the flow rate is linearly correlated with column length, only need to search pH
            ind=find(sum(temp,2)==0);
            disp('Col_A=Col_B');
            if isempty(ind)
                X_SEL_A=X_SEL_A;
                Y_SEL_A=Y_SEL_A;
                X_SEL_B=X_SEL_B;
                Y_SEL_B=Y_SEL_B;
                Gnum=Gnum;
            else
                X_SEL_A(size(X_SEL_A,1)+1,:)=X_CAL_A(ind_A(k),:);
                Y_SEL_A(size(Y_SEL_A,1)+1,:)=Y_CAL_A(ind_A(k),:);
%                 X_CAL_B(ind_B(ind),end-1:end)
                X_SEL_B(size(X_SEL_B,1)+1,:)=mean(X_CAL_B(ind_B(ind),:),1);
                Y_SEL_B(size(Y_SEL_B,1)+1,:)=mean(Y_CAL_B(ind_B(ind),:));
                Gnum(size(Gnum,1)+1,:)=UNIQUE_LIST(i,:);
            end
        end
    elseif length(ind_A)<length(ind_B)
        for k=1:length(ind_A)
            temp=X_CAL_A(ind_A(k),end)-X_CAL_B(ind_B,end);
            ind=find(sum(temp,2)==0);
            disp('Col_A<Col_B');
%             UNIQUE_LIST(i,:)
%             COL_A
%             COL_B
%             [X_CAL_A(ind_A,end-1:end) Y_CAL_A(ind_A,:)]
%             [X_CAL_B(ind_B,end-1:end) Y_CAL_B(ind_B,:)]
            
            if isempty(ind)
                X_SEL_A=X_SEL_A;
                Y_SEL_A=Y_SEL_A;
                X_SEL_B=X_SEL_B;
                Y_SEL_B=Y_SEL_B;
                Gnum=Gnum;
            else
                X_SEL_A(size(X_SEL_A,1)+1,:)=X_CAL_A(ind_A(k),:);
                Y_SEL_A(size(Y_SEL_A,1)+1,:)=Y_CAL_A(ind_A(k),:);
%                 X_CAL_B(ind_B(ind),end-1:end)
                X_SEL_B(size(X_SEL_B,1)+1,:)=mean(X_CAL_B(ind_B(ind),:),1);
                Y_SEL_B(size(Y_SEL_B,1)+1,:)=mean(Y_CAL_B(ind_B(ind),:));
                Gnum(size(Gnum,1)+1,:)=UNIQUE_LIST(i,:);
            end
        end
    elseif length(ind_A)>length(ind_B)
        for k=1:length(ind_B)
            temp=X_CAL_A(ind_A,end)-X_CAL_B(ind_B(k),end);
            ind=find(sum(temp,2)==0);
            disp('Col_A>Col_B');
%             UNIQUE_LIST(i,:)
%             COL_A
%             COL_B
%             [X_CAL_A(ind_A,end-1:end) Y_CAL_A(ind_A,:)]
%             [X_CAL_B(ind_B,end-1:end) Y_CAL_B(ind_B,:)]
            
            if isempty(ind)
                X_SEL_A=X_SEL_A;
                Y_SEL_A=Y_SEL_A;
                X_SEL_B=X_SEL_B;
                Y_SEL_B=Y_SEL_B;
                Gnum=Gnum;
            else
%                 X_CAL_A(ind_A(ind),end-1:end)
                X_SEL_A(size(X_SEL_A,1)+1,:)=mean(X_CAL_A(ind_A(ind),:),1);
                Y_SEL_A(size(Y_SEL_A,1)+1,:)=mean(Y_CAL_A(ind_A(ind),:));
                X_SEL_B(size(X_SEL_B,1)+1,:)=X_CAL_B(ind_B(k),:);
                Y_SEL_B(size(Y_SEL_B,1)+1,:)=Y_CAL_B(ind_B(k),:);
                Gnum(size(Gnum,1)+1,:)=UNIQUE_LIST(i,:);
            end
        end
    else
        UNIQUE_LIST(i,:)
    end
end

RESULTS.X_SEL_A=X_SEL_A;
RESULTS.X_SEL_B=X_SEL_B;
RESULTS.Y_SEL_A=Y_SEL_A;
RESULTS.Y_SEL_B=Y_SEL_B;
RESULTS.Gnum=Gnum(2:end,:);

figure

if length(Y_SEL_A)==length(Y_SEL_B)
    plot(Y_SEL_A,Y_SEL_B,'ro')
    xlabel(['measured Rt on' COL_A '(min)'])
    ylabel(['measured Rt on' COL_B '(min)'])
else
end



