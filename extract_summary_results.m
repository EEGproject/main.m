function [T_SVM,T_KNN,T_LDR] = extract_summary_results(files_names,window_size,channels_type)
    if strcmp(channels_type,"low")
        channels_type = true;
    elseif strcmp(channels_type,"all")
        channels_type = false;
    else
        error("channel type dont support %s",channels_type);
    end
	folder_name = "results";
    files = dir2(folder_name);
    files(end) = [];
    file = strings(0);
    SVM_res_array = [];
    KNN_res_array = [];
    LDR_res_array = [];
    SVMacc = [];
    SVMpre = [];
    SVMrec = [];
    KNNacc = [];
    KNNpre = [];
    KNNrec = [];
    LDRacc = [];
    LDRpre = [];
    LDRrec = [];
    for f = 1:length(files)
        file_name = files(f).name;
        file_pram = split(file_name(1:end-4),'_');
        if ~contains(files_names,cell2mat(file_pram(1))) %file name check
            continue
        end
        if str2double(cell2mat(file_pram(2))) ~= window_size %file name check
            continue
        end
        if channels_type && str2double(cell2mat(file_pram(3))) > 20
            continue
        elseif ~channels_type && str2double(cell2mat(file_pram(3))) < 20
            continue
        end
        load(folder_name + "/" + file_name)
        fprintf("%s result:\n",file_name)
        True_values = result(:,1);
        SVM = result(:,2);
        KNN = result(:,3);
        LDR = result(:,4);
        t = find(True_values==1);
        if isempty(t)
            error("!!! file dont have Sezu\n");
        end
        loc = diff(t)>2;
        num_of_seizures = sum(loc) + 1;
        fprintf("num of Seizu = %d \n",num_of_seizures)
        if(num_of_seizures>1)
            s = t(loc)+ 1;
            True_values(s:end) = 0; 
            SVM(s:end) = 0; 
            KNN(s:end) = 0; 
            LDR(s:end) = 0; 
        end 
        SVM_res = find(SVM(True_values==1)==1, 1 );
        KNN_res = find(KNN(True_values==1)==1, 1 );
        LDR_res = find(LDR(True_values==1)==1, 1 );
        if isempty(SVM_res)
            SVM_res = 0;
        end
        if isempty(KNN_res)
            KNN_res = 0;
        end
        if isempty(LDR_res)
            LDR_res = 0;
        end
        file = [file cell2mat(file_pram(1))];
        SVM_res_array = [SVM_res_array SVM_res];
        KNN_res_array = [KNN_res_array KNN_res];
        LDR_res_array = [LDR_res_array LDR_res];
        if SVM_res == 0
            SVMacc = [SVMacc 0];
        else
            SVMacc = [SVMacc accuracy(1)];
        end
        SVMpre = [SVMpre precision(1)];
        SVMrec = [SVMrec recall(1)];
        
        if KNN_res == 0
        	KNNacc = [KNNacc 0];
        else
            KNNacc = [KNNacc accuracy(2)];
        end
        KNNpre = [KNNpre precision(2)];
        KNNrec = [KNNrec recall(2)];
        if LDR_res == 0
            LDRacc = [LDRacc 0];
        else
            LDRacc = [LDRacc accuracy(3)];
        end
        LDRpre = [LDRpre precision(3)];
        LDRrec = [LDRrec recall(3)];
    end
    
    fprintf("SVM:\n")
    for i = 1:length(file)
        fprintf("file: %s Acc = %d pre = %d rec= %d delay %d\n",file(i),SVMacc(i),SVMpre(i),SVMrec(i),SVM_res_array(i))
    end 
	fprintf("KNN:\n")
    for i = 1:length(file)
        fprintf("file: %s Acc = %d pre = %d rec= %d delay %d\n",file(i),KNNacc(i),KNNpre(i),KNNrec(i),KNN_res_array(i))
    end 
	fprintf("LDR:\n")
    for i = 1:length(file)
        fprintf("file: %s Acc = %d pre = %d rec= %d delay %d\n",file(i),LDRacc(i),LDRpre(i),LDRrec(i),LDR_res_array(i))
    end 
    T_SVM = table(file',SVMacc',SVMpre',SVMrec',SVM_res_array',...
        'VariableNames',{'Patient','Accuracy','Precision','Recall','delay'});
    
    T_KNN = table(file',KNNacc',KNNpre',KNNrec',KNN_res_array',...
        'VariableNames',{'Patient','Accuracy','Precision','Recall','delay'});
    
    T_LDR = table(file',LDRacc',LDRpre',LDRrec',LDR_res_array',...
        'VariableNames',{'Patient','Accuracy','Precision','Recall','delay'});
end

