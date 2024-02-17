function [result] = findNoisyChannels(content)
    data = content.signals';
    %% Method 1: Unusually high or low amplitude (using robust std)
    robustDeviationThreshold = 5;
    channelDeviation = 0.7413 *iqr(data);   % Robust estimate of SD
    channelDeviationSD =  0.7413 * iqr(channelDeviation);
    channelDeviationMedian = nanmedian(channelDeviation);
    robustChannelDeviation = (channelDeviation - channelDeviationMedian) / channelDeviationSD;
    
    badChannelsFromDeviation = abs(robustChannelDeviation) > robustDeviationThreshold;
    %% Method 2: Compute the SNR (based on Christian Kothe's clean_channels)
    % Remove signal content above 50Hz and below 1 Hz
    highFrequencyNoiseThreshold = 5;
    B = firgr(100,[2*[0 45 50]/content.srate 1],[1 1 0 0]);
    X = zeros(content.samples, content.ch_num);
    for k = 1:content.ch_num  % Could be changed to parfor
        X(:,k) = filter(B, 1, data(:, k)); end
    % Determine z-scored level of EM noise-to-signal ratio for each channel
    noisiness = mad(data- X, 1)./mad(X, 1);
    noisinessMedian = nanmedian(noisiness);
    noisinessSD = mad(noisiness, 1)*1.4826;
    zscoreHFNoiseTemp = (noisiness - noisinessMedian) ./ noisinessSD;
    badChannelsFromHFNoise = (zscoreHFNoiseTemp > highFrequencyNoiseThreshold);
    %% Method 3: Global correlation criteria (from Nima Bigdely-Shamlo)
    correlationThreshold = 0.4;
    badTimeThreshold = 0.01;
    correlationWindowSeconds = 1;
    correlationFrames = correlationWindowSeconds * content.srate;
    correlationWindow = 0:(correlationFrames - 1);
    correlationOffsets = 1:correlationFrames:(content.samples-correlationFrames);
    WCorrelation = length(correlationOffsets);
    channelCorrelations = ones(WCorrelation, content.ch_num);
    noiseLevels = zeros(WCorrelation, content.ch_num);
    channelDeviations = zeros(WCorrelation, content.ch_num);
    n = length(correlationWindow);
    xWin = reshape(X(1:n*WCorrelation, :)', content.ch_num, n, WCorrelation);
    dataWin = reshape(data(1:n*WCorrelation, :)', content.ch_num, n, WCorrelation);
    for k = 1:WCorrelation 
        eegPortion = squeeze(xWin(:, :, k))';
        dataPortion = squeeze(dataWin(:, :, k))';
        windowCorrelation = corrcoef(eegPortion);
        abs_corr = abs(windowCorrelation - diag(diag(windowCorrelation)));
        channelCorrelations(k, :)  = quantile(abs_corr, 0.98);
        noiseLevels(k, :) = mad(dataPortion - eegPortion, 1)./mad(eegPortion, 1);
        channelDeviations(k, :) =  0.7413 *iqr(dataPortion);
    end
    thresholdedCorrelations = ...
        channelCorrelations' < correlationThreshold;
    fractionBadCorrelationWindows = mean(thresholdedCorrelations, 2);
    
    badChannelsFromCorrelation = (fractionBadCorrelationWindows > badTimeThreshold)';
    
    %% result
    result = badChannelsFromDeviation | badChannelsFromHFNoise | badChannelsFromCorrelation;
end