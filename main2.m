clc
clear all
%% Load Files
[filename, path] = uigetfile('*.edf', 'Select an EDF file');
if isequal(filename, 0)
    disp('User canceled the operation. Exiting...');
    return;
end
edfFilePath = fullfile(path, filename);

% Load data and header
[EEG, header] = load_files(edfFilePath);
%% find&RemoveNoisyChannels
EEG = EEG(:, 1:8);
header.labels = header.labels(1:8);
[EEG_no_noisy_ch, summary_index] = findRemoveNoisyChannels(EEG, header);
%% NoisyChannels
%[EEG_no_noisy_ch, summary_index] = Remove_noisy(EEG, header);
%% Remove the last three columns from EEG
%EEG = EEG(:, 1:8);
%% split to train & test
[EEG_train,EEG_test] = split_EEG(EEG);
%% Plot Amplitude Over Time
plotAmplitudeOverTimeFromFile(edfFilePath);
%% based FFT
%% Call visualizeFrequencyDomain for the first 8 channels
visualizeFrequencyDomain(EEG(:, 1:8), header.samplerate(1:8), header);
%% Generate datasets
% window_size = 8000; %16*header.samplerate
% result = extract_dataset(EEG, header, window_size);
% dataset_train = extract_dataset(EEG_train_no_noisy_ch ,channels_no_noisy,window_size);
% [dataset_test,len_test] = extract_dataset_test(EEG_test ,channels_no_noisy,window_size);
%%