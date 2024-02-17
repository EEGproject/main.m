function [file_name] = plot_result(result,patient,window_size,channels,channels_no_noisy)
    All_channels = ["FP1","F3","T7","F7","FP2","F4","T8","F8"];
    True_values = result(:,1); 
    accuracy = zeros(3,1);
    precision = zeros(3,1);
    recall = zeros(3,1);
    for i=2:size(result,2)
        predicted_values = result(:,i);
        TN = sum(predicted_values == 0 & True_values == 0);
        FN = sum(predicted_values == 0 & True_values == 1);
        FP = sum(predicted_values == 1 & True_values == 0);
        TP = sum(predicted_values == 1 & True_values == 1);
        accuracy(i-1) = (TP + TN)/(TP + TN + FP + FN);
        precision(i-1) = TP/(TP + FP);
        recall(i-1) = TP/(TP + FN);
    end
    accuracy(isnan(accuracy)) = 0;
    precision(isnan(precision)) = 0;
    recall(isnan(recall)) = 0;
    num_noise = length(channels) - length(channels_no_noisy);
    bins = contains(All_channels,channels_no_noisy);
    bins = num2str(bins);
    folder_name = "results";
    file_name = sprintf("%s/%s_%d_%d",folder_name,patient,window_size,bin2dec(bins));
    log_result = sprintf("Results: %s \n File Name : %s \n Patient:%s \n Window size:%d \n Requested Channels:",char(datetime()),file_name,patient,window_size);
    log_result = log_result + sprintf("%s, ",channels);
    log_result = log_result + sprintf("\n Num of Noise channels: %d ",num_noise);
    log_result = log_result + sprintf("\n Without Noise channels:, ");
    log_result = log_result + sprintf("%s, ",channels_no_noisy) + newline;
    log_result = log_result + sprintf(" SVM:\n  Accuracy: %.2f Precision: %.2f Recall: %.2f\n",accuracy(1)*100,precision(1)*100,recall(1)*100);
    log_result = log_result + sprintf(" KNN:\n  Accuracy: %.2f Precision: %.2f Recall: %.2f\n",accuracy(2)*100,precision(2)*100,recall(2)*100);
    log_result = log_result + sprintf(" LDR:\n  Accuracy: %.2f Precision: %.2f Recall: %.2f\n",accuracy(3)*100,precision(3)*100,recall(3)*100);
    log_result = log_result + newline;
    fprintf("%s",log_result)
    save(file_name,'result','accuracy','precision','recall')
    fileID = fopen(folder_name + '/results_log.txt','a+');
    fprintf(fileID,"%s",log_result);
    fclose(fileID);
end