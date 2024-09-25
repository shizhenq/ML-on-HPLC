function OUTPUT=PLS_independent_test_Github(X_CAL,Y_CAL,X_test,Y_test,ind_CAL,ind_Test,Project,options)

UNIQUE_LIST=FIND_UNIQUE(string(ind_Test.Column))

RMSEP_1=[];
RMSEP_2=[];
LABEL={};

for i=1:5
    for k=i+1:5
        UNIQUE_LIST(i,:);
        UNIQUE_LIST(k,:);
        ind_cal_1=zeros(144,1);
        ind_cal_1(ind_Test.Project==Project & ind_Test.Column==UNIQUE_LIST(i,:))=1;
        ind_cal_1=logical(ind_cal_1);
        ind_cal_2=isnan(Y_test);
        ind_cal=ind_cal_1.*~ind_cal_2;
        ind_cal=logical(ind_cal);
        
        ind_val_1=zeros(144,1);
        ind_val_1(ind_Test.Project==Project & ind_Test.Column==UNIQUE_LIST(k,:))=1;
        ind_val_1=logical(ind_val_1);
        ind_val_2=isnan(Y_test);
        ind_val=ind_val_1.*~ind_val_2;
        ind_val=logical(ind_val);
       
        if sum(ind_cal)<3 | sum(ind_val)<3
            RMSEP_1=RMSEP_1
            RMSEP_2=RMSEP_2;
            LABEL=LABEL;
        else
            disp('Pete')       
            % PLS approach
            model=pls([X_CAL; X_test(ind_cal,:)],[Y_CAL; Y_test(ind_cal)],5,options);
            pred_2=pls(X_test(ind_val,:),model,options);
            RMSEP_temp=sqrt(sum((Y_test(ind_val)-pred_2.pred{1,2}).^2)/(sum(ind_val)));
            LABEL{size(LABEL,1)+1,1}=UNIQUE_LIST(i,:);
            LABEL{end,3}=UNIQUE_LIST(k,:);
            LABEL{end,2}=ind_Test.Compound(ind_cal);
            LABEL{end,4}=ind_Test.Compound(ind_val);
            LABEL{end,5}(:,1)=Y_test(ind_val);
            LABEL{end,5}(:,2)=pred_2.pred{1,2};
            RMSEP_2(length(RMSEP_2)+1,1)=RMSEP_temp;
            
            % empirical fitting
            
            Y_A=Y_test(ind_cal);
            Y_B=Y_test(ind_val);
            Rt_A=[];
            Rt_B=[];
            
            RESULTS=HPLC_COLUMN_TRANSFER_SEARCH_Github(X_CAL,Y_CAL,ind_CAL,UNIQUE_LIST(i,:),UNIQUE_LIST(k,:));
            close all
            
            p=polyfit(RESULTS.Y_SEL_A,RESULTS.Y_SEL_B,1);
            
            for r=1:length(LABEL{end,4})
                ind_temp=LABEL{end,2}==LABEL{end,4}(r,:);
                if sum(ind_temp)==0
                    Rt_A=Rt_A;
                    Rt_B=Rt_B;
                else
                    Rt_A(length(Rt_A)+1)=Y_A(ind_temp);
                    Rt_B(length(Rt_B)+1)=Y_B(r);
                end
            end
            size(Rt_A)
            size(Rt_B)
            pred_1=polyval(p,Rt_A);
            RMSEP_1(length(RMSEP_1)+1,1)=sqrt(sum((Rt_B-pred_1).^2)/(length(Rt_B)));
            LABEL{end,6}(:,1)=Rt_B;
            LABEL{end,6}(:,2)=pred_1;

        end
    end
end

OUTPUT.LABEL=LABEL;
OUTPUT.RMSEP_1=RMSEP_1;
OUTPUT.RMSEP_2=RMSEP_2;