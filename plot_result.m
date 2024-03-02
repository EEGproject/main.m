function [file_name, confusion_matrices] = plot_result(result, patient, window_size, channels, channels_no_noisy)
     All_channels = ["F3","F4","T7","T8","P7","P8","P3","P4"];
     True_values = result(:, 1);
     accuracy = zeros(5, 1);
     precision = zeros(5, 1);
     recall = zeros(5, 1);
     confusion_matrices = cell(5, 1);

     for i = 2:size(result, 2)
         predicted_values = result(:, i);
         TN = sum(predicted_values == 0 & True_values == 0);
         FN = sum(predicted_values == 0 & True_values == 1);
         FP = sum(predicted_values == 1 & True_values == 0);
         TP = sum(predicted_values == 1 & True_values == 1);

         % Compute accuracy, precision, and recall
         accuracy(i-1) = (TP + TN) / (TP + TN + FP + FN);
         precision(i-1) = TP / (TP + FP);
         recall(i-1) = TP / (TP + FN);

         % Save confusion matrix
         confusion_matrices{i-1} = [TN, FP; FN, TP];
     end

     % Handle NaN values
     accuracy(isnan(accuracy)) = 0;
     precision(isnan(precision)) = 0;
     recall(isnan(recall)) = 0;

     % Additional code for creating plots
     for i = 1:5
         classifier_name = '';
         switch i
             case 1
                 classifier_name = 'SVM';
             case 2
                 classifier_name = 'KNN';
             case 3
                 classifier_name = 'LDA';
             case 4
                 classifier_name = 'RF'; % Added Random Forest
             case 5
                 classifier_name = 'XGB'; % Added XGB
         end

         % Display confusion matrix
         disp(sprintf('\nConfusion Matrix for %s:\n', classifier_name));
         disp(confusion_matrices{i});

         % Create and save confusion matrix plot
         plot_confusion_matrix(confusion_matrices{i}, classifier_name);
         title(sprintf('%s Confusion Matrix', classifier_name));
         saveas(gcf, sprintf('%s_%s_Confusion_Matrix.png', patient, classifier_name));
         close gcf; % Close the figure after saving
     end

     num_noise = length(channels) - length(channels_no_noisy);
     bins = contains(All_channels, channels_no_noisy);
     bins = num2str(bins);
     folder_name = "results";
     file_name = sprintf("%s/%s_%d_%d", folder_name, patient, window_size, bin2dec(bins));
     log_result = sprintf("Results: %s \n File Name : %s \n Patient:%s \n Window size:%d \n Requested Channels:", char(datetime()), file_name, patient, window_size);
     log_result = log_result + sprintf("%s, ", channels);
     log_result = log_result + sprintf("\n Num of Noise channels: %d ", num_noise);
     log_result = log_result + sprintf("\n Without Noise channels:, ");
     log_result = log_result + sprintf("%s, ", channels_no_noisy) + newline;
     log_result = log_result + sprintf(" SVM:\n Accuracy: %.2f Precision: %.2f Recall: %.2f\n", accuracy(1) * 100, precision(1) * 100, recall(1) * 100 );
     log_result = log_result + sprintf(" KNN:\n Accuracy: %.2f Precision: %.2f Recall: %.2f\n", accuracy(2) * 100, precision(2) * 100, recall(2) * 100 );
     log_result = log_result + sprintf(" LDA:\n Accuracy: %.2f Precision: %.2f Recall: %.2f\n", accuracy(3) * 100, precision(3) * 100, recall(3) * 100 );
     log_result = log_result + sprintf(" RF:\n Accuracy: %.2f Precision: %.2f Recall: %.2f\n", accuracy(4) * 100, precision(4) * 100, recall(4) * 100 ); % Added RF
     log_result = log_result + sprintf(" XGB:\n Accuracy: %.2f Precision: %.2f Recall: %.2f\n", accuracy(5) * 100, precision(5) * 100, recall(5) * 100 ); % Added XGB
     log_result = log_result + newline;
     fprintf("%s", log_result)
     save(file_name, 'result', 'accuracy', 'precision', 'recall')
     fileID = fopen(folder_name + '/results_log.txt', 'a+');
     fprintf(fileID, "%s", log_result);
     fclose(fileID);
end
