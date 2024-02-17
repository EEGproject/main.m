%% loop

clc;
close all;
clear all;
addpath('features','tools','basedFFT');
chb = ["chb01","chb03","chb05","chb08","chb19","chb20","chb24"];
window_size = 256;
channels_1 = ["FP2-F8","F7-T7","FP2-F4","F8-T8"];
channels_2 = ["FP1-F7","F7-T7","T7-P7",...
          "P7-O1","FP1-F3","F3-C3",...
          "C3-P3","P3-O1","FP2-F4",...
          "F4-C4","C4-P4","P4-O2",...
          "FP2-F8","F8-T8","T8-P8",...
          "P8-O2","FZ-CZ","CZ-PZ",...
          "T7-FT9","FT9-FT10","FT10-T8"];
for i=1:length(chb)
    patient = chb(i);

    channels = channels_2;
    EEG = load_files(patient, channels);
    [EEG_train,EEG_test] = split_EEG(EEG);
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
    dataset_train = extract_dataset(EEG_train_no_noisy_ch ,channels_no_noisy,window_size);
    [dataset_test,len_test] = extract_dataset_test(EEG_test ,channels_no_noisy,window_size);
    [result] = analyze_datasets(dataset_train,dataset_test,len_test);
    plot_result(result,patient,window_size,channels,channels_no_noisy)
    channels = channels_1;
    EEG = load_files(patient, channels);
    [EEG_train,EEG_test] = split_EEG(EEG);
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
    dataset_train = extract_dataset(EEG_train_no_noisy_ch ,channels_no_noisy,window_size);
    [dataset_test,len_test] = extract_dataset_test(EEG_test ,channels_no_noisy,window_size);
    [result] = analyze_datasets(dataset_train,dataset_test,len_test);
    plot_result(result,patient,window_size,channels,channels_no_noisy)
end

