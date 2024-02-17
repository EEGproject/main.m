function [EEG_no_noisy_ch,summary_index] = Remove_noisy(EEG, channels)
    summary_index = zeros(length(EEG),length(channels));
    for i = 1:length(EEG)
        disp("Remove noisy ch from " + EEG(i).file_name)
        EEG_no_noisy_ch(i).file_name = EEG(i).file_name;
        ch_index = findNoisyChannels(EEG(i).content);
        summary_index(i,:) = ch_index;
        EEG_no_noisy_ch(i).content.ch = EEG(i).content.ch(~ch_index);
        EEG_no_noisy_ch(i).content.signals = EEG(i).content.signals(~ch_index,:);
        EEG_no_noisy_ch(i).content.samples = EEG(i).content.samples;
        EEG_no_noisy_ch(i).content.srate = EEG(i).content.srate;
        EEG_no_noisy_ch(i).content.ch_num = EEG(i).content.ch_num - sum(ch_index);
        EEG_no_noisy_ch(i).content.seizures = EEG(i).content.seizures;
    end    
end