function [result] = analyze_datasets(dataset_train, dataset_test, len_test)
    svm_predict_array = zeros(length(dataset_test), len_test);
    knn_predict_array = zeros(length(dataset_test), len_test);
    ldr_predict_array = zeros(length(dataset_test), len_test);

    for i = 1:length(dataset_train)
        current_dataset_train = dataset_train(i).dataset;
        fprintf("Analyze channel %s\n", dataset_train(i).ch_name);
        X = removevars(current_dataset_train, {'Seizure'});
        Y = current_dataset_train.Seizure;
        svmmdl = fitcsvm(X, Y);
        knnmdl = fitcknn(X, Y, 'NumNeighbors', 3);
        % Use 'pseudoLinear' instead of 'linear' to avoid zero within-class variance issue
        ldrmdl = fitcdiscr(X, Y, 'DiscrimType', 'pseudoLinear');
        current_dataset_test = dataset_test(i).dataset;
        X = removevars(current_dataset_test, {'Seizure'});
        svm_predicted = predict(svmmdl, X);
        knn_predicted = predict(knnmdl, X);
        ldr_predicted = predict(ldrmdl, X);
        svm_predict_array(i, :) = svm_predicted;
        knn_predict_array(i, :) = knn_predicted;
        ldr_predict_array(i, :) = ldr_predicted;
    end

    true_value = current_dataset_test.Seizure;
    svm = mode(svm_predict_array)';
    knn = mode(knn_predict_array)';
    ldr = mode(ldr_predict_array)';
    result = [true_value, svm, knn, ldr];
end
