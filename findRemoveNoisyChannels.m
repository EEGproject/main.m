function [EEG_no_noisy_ch, summary_index] = findRemoveNoisyChannels(EEG, header)
    % Method 1: Standard Deviation
    deviationThreshold = 5;
    channelDeviation = std(EEG);
    deviationMedian = median(channelDeviation);
    deviationSD = std(channelDeviation);
    deviationScore = (channelDeviation - deviationMedian) / deviationSD;
    badChannelsFromDeviation = abs(deviationScore) > deviationThreshold;

    % Method 2: Noise Change
    noiseThreshold = 5;
    bandpassFilter = designfilt('bandpassfir', 'FilterOrder', 100, 'CutoffFrequency1', 1, 'CutoffFrequency2', 50, 'SampleRate', header.samplerate(1));
    filteredChannels = filter(bandpassFilter, EEG);
    noiseIndex = median(EEG - filteredChannels) / median(filteredChannels);
    noiseSD = std(noiseIndex);
    noiseScore = (noiseIndex - median(noiseIndex)) / noiseSD;
    badChannelsFromNoise = noiseScore > noiseThreshold;

    % Method 3: Correlation
    correlationThreshold = 0.4;
    badTimeThreshold = 0.01;
    correlationWindowSeconds = 1;
    correlationFrames = round(correlationWindowSeconds * header.samplerate);
    correlationOffsets = 1:correlationFrames:(size(EEG, 1) - correlationFrames);
    WCorrelation = length(correlationOffsets);
    
    channelCorrelations = zeros(WCorrelation, header.channels);
    for k = 1:WCorrelation
        windowEEG = EEG(correlationOffsets(k):(correlationOffsets(k) + correlationFrames - 1), :);
        correlationMatrix = corrcoef(windowEEG);
        absCorrelation = abs(correlationMatrix - diag(diag(correlationMatrix)));
        channelCorrelations(k, :) = prctile(absCorrelation(:), 98);
    end
    
    badChannelsFromCorrelation = mean(channelCorrelations, 1) < correlationThreshold;
    fractionBadCorrelationWindows = mean(badChannelsFromCorrelation);

    % Combine criteria
    badChannels = badChannelsFromDeviation | badChannelsFromNoise | (fractionBadCorrelationWindows > badTimeThreshold);

    % Ensure badChannels has the correct size
    badChannels = badChannels(:)'; % Ensure it is a row vector
    if length(badChannels) < length(header.channels)
        badChannels = [badChannels, false(1, length(header.channels) - length(badChannels))];
    elseif length(badChannels) > length(header.channels)
        badChannels = badChannels(1:length(header.channels));
    end

    % Update EEG structure
    EEG_no_noisy_ch = EEG;
    % Use find to get indices of non-noisy channels
    EEG_no_noisy_ch.content.ch = find(~badChannels);
    EEG_no_noisy_ch.content.signals = EEG(:, EEG_no_noisy_ch.content.ch);
    EEG_no_noisy_ch.content.ch_num = length(EEG_no_noisy_ch.content.ch);

    % Output summary index
    summary_index = badChannels;
end