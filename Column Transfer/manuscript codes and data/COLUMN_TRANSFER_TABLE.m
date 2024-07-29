function OUTPUT=COLUMN_TRANSFER_TABLE(X_CAL,Y_CAL,ind_METRIC)

UNIQUE_LIST=FIND_UNIQUE(string(ind_METRIC.column));

METRIC=[];
LABEL=string;

for i=1:20
    for k=i+1:20
        UNIQUE_LIST(i,:)
        UNIQUE_LIST(k,:)
        RESULTS=HPLC_COLUMN_TRANSFER_SEARCH(X_CAL,Y_CAL,ind_METRIC,UNIQUE_LIST(i,:),UNIQUE_LIST(k,:));
        close all

        if length(RESULTS.Gnum)>=2
            METRIC(length(METRIC)+1,1)=length(RESULTS.Gnum);
%             size(METRIC)
            corrcoef(RESULTS.Y_SEL_A,RESULTS.Y_SEL_B);
            METRIC(end,2)=ans(1,2).^2;
%             size(METRIC)
            p=polyfit(RESULTS.Y_SEL_A,RESULTS.Y_SEL_B,1);
            METRIC(end,3)=sqrt(sum((RESULTS.Y_SEL_B-polyval(p,RESULTS.Y_SEL_A)).^2)/length(RESULTS.Gnum));
%             size(METRIC)
            LABEL(length(LABEL)+1,1)=UNIQUE_LIST(i,:);
            LABEL(end,2)=UNIQUE_LIST(k,:);
        else
            METRIC=METRIC;
            LABEL=LABEL;
        end
        
    end
    i
end

OUTPUT.METRIC=METRIC([1 4:end],:);
OUTPUT.LABEL=LABEL(2:end,:);

        
        