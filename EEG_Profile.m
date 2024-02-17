function [svm_result,knn_result,ldr_result, seizures] = EEG_Profile(patient,channels,window_size)
    addpath('filters','features','tools','basedFFT');
    chack_args(patient, channels, window_size)
    
    % load files
    EEG = load_files(patient, channels);
    
    % Generate_dataset
    [dataset,test] = generate_dataset(EEG,channels,window_size);
    
    % Analyze Dataset
    [svm_predic,knn_predic,ldr_predic, seizures] = analyze_dataset(EEG,channels,window_size,dataset,test);
    
    % Order Results for multi-channels
	[svm_result,knn_result,ldr_result] = order_results(channels,svm_predic,knn_predic,ldr_predic);
end
