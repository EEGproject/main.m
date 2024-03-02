clc;
clear all;
close all;

%% select parameters
addpath('features','tools','basedFFT');
patient = "chb04";
channels = ["F3","F4","T7","T8","P7","P8","P3","P4"];
window_size = 500;
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
%% Plot result and generate confusion matrices
[file_name, confusion_matrices] = plot_result(result, patient, window_size, channels, channels_no_noisy);
%% Features