function visualizeFrequencyDomain(EEG, samplerates, header)
    for channelIdx = 1:8
        figure;
        
        % Compute FFT and frequency axis for the original signal
        [frequencies_orig, power_orig] = calculateFFT(EEG(:, channelIdx), samplerates(channelIdx));

        % Plot power spectral density for the original signal
        subplot(2, 1, 1);
        plot(frequencies_orig, 10 * log10(power_orig));
        title(['Power Spectral Density - ' header.labels{channelIdx} ' (Original)']);
        xlabel('Frequency (Hz)');
        ylabel('Power/Frequency (dB/Hz)');
        xlim([0 30]);
        grid on;
        grid minor;

        % Apply FIR filters to different frequency bands
        delta_band = applyFIRFilter(EEG(:, channelIdx), samplerates(channelIdx), [0.5 4]);
        theta_band = applyFIRFilter(EEG(:, channelIdx), samplerates(channelIdx), [4 8]);
        alpha_band = applyFIRFilter(EEG(:, channelIdx), samplerates(channelIdx), [8 13]);
        beta_band = applyFIRFilter(EEG(:, channelIdx), samplerates(channelIdx), [13 30]);

        % Combine filtered signals for display
        filteredSignal = delta_band + theta_band + alpha_band + beta_band;

        % Compute FFT and frequency axis for the combined filtered signal
        [frequencies_filt, power_filt] = calculateFFT(filteredSignal, samplerates(channelIdx));

        % Plot power spectral density for the combined filtered signal
        subplot(2, 1, 2);
        plot(frequencies_filt, 10 * log10(power_filt));
        title(['Power Spectral Density - ' header.labels{channelIdx} ' (Filtered)']);
        xlabel('Frequency (Hz)');
        ylabel('Power/Frequency (dB/Hz)');
        xlim([0 30]);
        grid on;
        grid minor;

        % Add vertical lines to indicate frequency bands
        hold on;
        delta_freq = 4;
        theta_freq = 8;
        alpha_freq = 13;
        beta_freq = 30;

        line([delta_freq delta_freq], ylim, 'Color', 'r', 'LineStyle', '--');
        line([theta_freq theta_freq], ylim, 'Color', 'r', 'LineStyle', '--');
        line([alpha_freq alpha_freq], ylim, 'Color', 'r', 'LineStyle', '--');
        line([beta_freq beta_freq], ylim, 'Color', 'r', 'LineStyle', '--');

        legend('Filtered Signal', 'Delta Band', 'Theta Band', 'Alpha Band', 'Beta Band');
    end
end

function filteredSignal = applyFIRFilter(signal, samplerate, freq_band)
    % Design a bandpass FIR filter
    nyquist = samplerate / 2;
    normalizedFreq = freq_band / nyquist;
    filterOrder = 64; % You can adjust the filter order as needed

    % Design the FIR filter using fir1
    firFilter = fir1(filterOrder, normalizedFreq, 'bandpass');

    % Apply the FIR filter to the signal
    filteredSignal = filter(firFilter, 1, signal);
end

function [frequencies, power] = calculateFFT(signal, samplerate)
    % Compute FFT
    N = length(signal);
    fft_result = fft(signal);
    power = abs(fft_result(1:N/2 + 1)).^2 / (N * samplerate);
    
    % Create frequency axis
    frequencies = (0:(N/2)) * samplerate / N;
end

%{
function visualizeFrequencyDomain(EEG, samplerates, channelNames)
    for channelIdx = 1:8
        figure;
        % Compute FFT and frequency axis
        [frequencies, power] = calculateFFT(EEG(:, channelIdx), samplerates(channelIdx));

        % Plot power spectral density
        plot(frequencies, 10 * log10(power));

        % Get the channel name
        channelName = channelNames{channelIdx};

        % Set plot title and labels
        title(['Power Spectral Density - ' channelName]);
        xlabel('Frequency (Hz)');
        ylabel('Power/Frequency (dB/Hz)');

        % Limit x-axis to a frequency of 30 Hz
        xlim([0 30]);

        % Adjust figure properties
        grid on;
        grid minor;
    end
end

function [frequencies, power] = calculateFFT(signal, samplerate)
    % Compute FFT
    N = length(signal);
    fft_result = fft(signal);
    power = abs(fft_result(1:N/2 + 1)).^2 / (N * samplerate);
    
    % Create frequency axis
    frequencies = (0:(N/2)) * samplerate / N;
end
%}
