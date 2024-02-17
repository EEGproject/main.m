clc;
close all;
clear all;

%% select parameters
addpath('features','tools','basedFFT');
patient = "chb01";
channels = ["FP1","F3","T7","F7","FP2","F4","T8","F8"];
window_size = 4096;
chack_args(patient, channels, window_size)

%% Load files
EEG = load_files(patient, channels);

%% split to train & test
[EEG_train,EEG_test] = split_EEG(EEG);

%% Remove noisy channles from train
if length(channels) > 10
    [EEG_train_no_noisy_ch,noisy_ch_index] = Remove_noisy(EEG_train, channels);
    ch_index = sum(noisy_ch_index)>(length(EEG_train)/2);
    fprintf("Remove %d channels records from %d\n",sum(sum(noisy_ch_index)),length(channels)*length(EEG_train))
    fprintf("Total remove channels %s\n",channels(ch_index))
    channels_no_noisy = channels;
    channels_no_noisy(ch_index) = [];
else
    fprintf("Skip remove noisy channles, length(channels) < 10\n")
    EEG_train_no_noisy_ch = EEG_train;
    channels_no_noisy = channels;
end

%% Generate datasets
dataset_train = extract_dataset(EEG_train_no_noisy_ch ,channels_no_noisy,window_size);
[dataset_test,len_test] = extract_dataset_test(EEG_test ,channels_no_noisy,window_size);
%% Analyze Dataset
[result] = analyze_datasets(dataset_train,dataset_test,len_test);
%% Plot result
plot_result(result,patient,window_size,channels,channels_no_noisy)

% %% Analyze Results
% [svm_result,knn_result,ldr_result] = order_results(channels,svm_predic,knn_predic,ldr_predic);
% %[svm_result,knn_result,ldr_result, seizures] = analyze_results(EEG,channels,window_size,svm_predic,knn_predic,ldr_predic);
% figure()
% hold on
% plot(seizures)
% plot(svm_result)
% plot(knn_result)
% plot(ldr_result)
%% extract features based FFT
% result = extract_features_table(dataset, channels, window_size);
% [trainedModel,~] = trainSVMClassifier(ch_2_table2);
% SVMMdl = trainedModel.ClassificationSVM;
% test_accurecy(EEG,window_size,SVMMdl);
% %% extract features based filters
% addpath('basedFilters');
% [ch_1_table1,ch_2_table1] = extract_features_table(dataset);
% %% test hilbert huang
% addpath('hilbert_huang');
% num_of_imfs = 4;
% dataset_HHT = calc_wfs(dataset,num_of_imfs);
% [train, test] = seperate(dataset_HHT);
% wf_mean = calc_wf_mean(dataset_HHT,num_of_imfs);
% test_accurecy(EEG,4096,wf_mean,num_of_imfs);
%% Perform DWT on EEG signals
%[EEG_DWT_train, EEG_DWT_test] = performDWT(EEG, channels, window_size);

