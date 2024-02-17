function [svm_result,knn_result,ldr_result] = order_results(channels,svm_predic,knn_predic,ldr_predic)
    len = length(channels);
    if len == 1
        svm_result = svm_predic;
        knn_result = knn_predic;
        ldr_result = ldr_predic;
    elseif len == 2
        svm_result = svm_predic(:,1) & svm_predic(:,2);
        knn_result = knn_predic(:,1) & knn_predic(:,2);
        ldr_result = ldr_predic(:,1) & ldr_predic(:,2);
    else
        svm_result = zeros(length(svm_predic),1);
        knn_result = zeros(length(knn_predic),1);
        ldr_result = zeros(length(ldr_predic),1);
        for i = 1:length(ldr_predic)
            svm_result(i) = sum(svm_predic(i,:))>floor(len/2);
            knn_result(i) = sum(knn_predic(i,:))>floor(len/2);
            ldr_result(i) = sum(ldr_predic(i,:))>floor(len/2);
        end
    end

end