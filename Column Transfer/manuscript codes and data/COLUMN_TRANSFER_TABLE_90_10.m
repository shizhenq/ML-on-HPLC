function OUTPUT=COLUMN_TRANSFER_TABLE_90_10(X_CAL_90,Y_CAL_90,X_CAL_10,Y_CAL_10,ind_METRIC_90,ind_METRIC_10,options)

UNIQUE_LIST=FIND_UNIQUE(string(ind_METRIC_90.column));

UNIQUE_LIST=sort(UNIQUE_LIST);

METRIC=[];
LABEL=string;

for i=1:20
    for k=i+1:20
        UNIQUE_LIST(i,:)
        UNIQUE_LIST(k,:)
        %filter down to desired columns per 90% of our database
        RESULTS_90=HPLC_COLUMN_TRANSFER_SEARCH(X_CAL_90,Y_CAL_90,ind_METRIC_90,UNIQUE_LIST(i,:),UNIQUE_LIST(k,:));
        close all
        %filter down to desired columns per 10% of our database
        RESULTS_10=HPLC_COLUMN_TRANSFER_SEARCH(X_CAL_10,Y_CAL_10,ind_METRIC_10,UNIQUE_LIST(i,:),UNIQUE_LIST(k,:));
        close all
        if length(RESULTS_90.Gnum)>=2
            METRIC(size(METRIC,1)+1,1)=length(RESULTS_90.Gnum);
%             size(METRIC)
            corrcoef(RESULTS_90.Y_SEL_A,RESULTS_90.Y_SEL_B);
            METRIC(end,2)=ans(1,2).^2;
            METRIC(end,3)=length(RESULTS_10.Gnum);
%             size(METRIC)
            p=polyfit(RESULTS_90.Y_SEL_A,RESULTS_90.Y_SEL_B,1);
            METRIC(end,4)=sqrt(sum((RESULTS_10.Y_SEL_B-polyval(p,RESULTS_10.Y_SEL_A)).^2)/length(RESULTS_10.Gnum));
%             size(METRIC)
            LABEL(length(LABEL)+1,1)=UNIQUE_LIST(i,:);
            LABEL(end,2)=UNIQUE_LIST(k,:);
            
            temp=ind_METRIC_10.column==UNIQUE_LIST(i);
            model=pls([X_CAL_90;RESULTS_10.X_SEL_A],[Y_CAL_90;RESULTS_10.Y_SEL_A],5,options);
            pred=pls(RESULTS_10.X_SEL_B,model,options);
            METRIC(end,5)=sqrt(sum((RESULTS_10.Y_SEL_B-pred.pred{1,2}).^2)/length(RESULTS_10.Y_SEL_B));

        else
            METRIC=METRIC;
            LABEL=LABEL;
        end
        
    end
    i
end

OUTPUT.METRIC=METRIC;
OUTPUT.LABEL=LABEL(2:end,:);

        
        