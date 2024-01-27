function plotAmplitudeOverTimeFromFile(edfFilePath)
   % Load data and header
 
    try
        [EEG, header] = ReadEDF(edfFilePath);
    catch
        disp('Error reading EDF file. Please make sure the file is valid.');
        return;
    end

    % Check if annotation field exists in the header
    if isfield(header, 'annotation') && isfield(header.annotation, 'event')
        % Exclude annotation channels
        annotationChannels = cellfun(@(x) find(strcmp(header.labels, x)), header.annotation.event);
        EEG(annotationChannels) = [];
    end

    % Get the number of channels - Subtraction 3 reference channels 
    numChannels = header.channels-3;

    % Get the sampling rate
    fs = header.samplerate(1);

    % Generate time vector
    time = (0:(header.records * header.duration * header.samplerate(1) - 1)) / header.samplerate(1);

    % Plot amplitude over time for each channel
    for channelIdx = 1:numChannels
        figure;
        plot(time, EEG{channelIdx}); 

        % Set plot title and labels
        title(['Amplitude over Time - Channel ' num2str(channelIdx)]);
        xlabel('Time (seconds)');
        ylabel('Amplitude');

        % Display channel information as a text box
        text(0.1, 0.9, sprintf('Label: %s\nTransducer: %s\nUnits: %s\nSample Rate: %d Hz', ...
            header.labels{channelIdx}, header.transducer{channelIdx}, ...
            header.units{channelIdx}, header.samplerate(channelIdx)), ...
            'Units', 'normalized', 'FontSize', 10);

        % Adjust figure properties
        grid on;
        grid minor;
        xlim([0, time(end)]);
    end
end
