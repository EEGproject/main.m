function [EEG_no_noisy_ch, summary_index] = Remove_noisy(EEG, header)
    numChannels = header.channels;
    summary_index = zeros(size(EEG, 1), numChannels);
    EEG_no_noisy_ch = EEG;

    for i = 1:size(EEG, 1)
        disp("Remove noisy ch from Record " + num2str(i));
        
        % Calculate SNR for each channel
        signal_power = mean(EEG(i, :).^2);
        
        % Example: Assuming baseline_indices is a vector of indices corresponding to baseline periods
        baseline_indices = findBaselineIndices(EEG(i, :), 0.5); % Set the threshold value as needed

        % Handle the case when baseline_indices is empty
        if ~isempty(baseline_indices)
            noise_power = estimateNoisePower(EEG(i, :), baseline_indices);
        else
            % Set a default noise power value (using the entire signal)
            noise_power = estimateNoisePower(EEG(i, :), 1:length(EEG(i, :)));
        end
        
        % Handle the case when noise_power is zero (optional)
        if noise_power == 0
            snr = 0; % or another suitable value
        else
            snr = 10 * log10(signal_power ./ noise_power);
        end

        % Criteria for noisy channels
        amplitude_threshold = 20;
        snr_threshold = 2;
        noisy_amplitude = abs(EEG(i, :)) < amplitude_threshold;
        noisy_snr = snr < snr_threshold;

        % Combine criteria
        ch_index = false(1, numChannels);
        ch_index(noisy_amplitude & noisy_snr) = true;

        % Display information about noisy channels
        displayNoisyChannels(header, ch_index);

        % Update EEG_no_noisy_ch
        EEG_no_noisy_ch(i, ch_index) = NaN;

        % Update summary_index
        summary_index(i, :) = ch_index;
    end
end

function baseline_indices = findBaselineIndices(signal, threshold)
    % Implement this function based on your criteria
    % Example: find periods where the signal is relatively flat
    baseline_indices = find(abs(diff(signal)) < threshold);
end

function noise_power = estimateNoisePower(data, baseline_indices)
    % Estimate noise power as the variance of the signal during baseline periods
    noise_power = var(data(baseline_indices));
end

function displayNoisyChannels(header, noisy_channels)
    disp('Noisy Channels:');
    disp(header.labels(noisy_channels));
end
