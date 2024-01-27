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
%% NoisyChannels
[EEG_no_noisy_ch, summary_index] = Remove_noisy(EEG, header);
%% Remove the last three columns from EEG
EEG = EEG(:, 1:8);
%% split to train & test
[EEG_train,EEG_test] = split_EEG(EEG);
%% Plot Amplitude Over Time
%plotAmplitudeOverTimeFromFile(edfFilePath);
%% based FFT
%% Call visualizeFrequencyDomain for the first 8 channels
visualizeFrequencyDomain(EEG(:, 1:8), header.samplerate(1:8), header);
%% Generate synthetic EEG data
%{
numChannels = 8;
samplerate = 500; %Hz
totalTime = 120; %sec
t = 0:(1/samplerate):totalTime;

% Create EEG data with multiple frequency components
EEG = zeros(length(t), numChannels);
for channelIdx = 1:numChannels
    % Simulate a mixture of different frequency components
    EEG(:, channelIdx) = sin(2*pi*5*t) + 0.8*sin(2*pi*15*t) + 0.5*sin(2*pi*25*t);
end

% Call visualizeFrequencyDomain function
visualizeFrequencyDomain(EEG, header.samplerate(1:8), {'Fp1', 'AF3', 'Fp2', 'AF4', 'F7', 'T7', 'F8', 'T8'});
%}