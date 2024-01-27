function [EEG, header] = load_files(edfFilePath)

    %%% Read data
    try
        [EEG, header] = ReadEDF(edfFilePath);
    catch
        disp('Error reading EDF file. Please make sure the file is valid.');
        return;
    end

    %{
    %%% Display header information
    disp('Header Information:');
    disp([' Patient ID: ' header.patientID]);
    disp([' Record ID: ' header.recordID]);
    disp([' Start Date: ' header.startdate]);
    disp([' Start Time: ' header.starttime]);
    disp([' Length: ' num2str(header.length)]);
    disp([' Records: ' num2str(header.records)]);
    disp([' Duration: ' num2str(header.duration)]);
    disp([' Channels: ' num2str(header.channels)]);

    % Display channel-specific information
    disp('Channel Information:');
     for i = 1:header.channels
      disp([' Channel ' num2str(i) ' - Label: ' header.labels{i}]);
      disp([' Transducer: ' header.transducer{i}]);
      disp([' Units: ' header.units{i}]);
      disp([' PhysMin: ' num2str(header.physmin(i))]);
      disp([' PhysMax: ' num2str(header.physmax(i))]);
      disp([' DigMin: ' num2str(header.digmin(i))]);
      disp([' DigMax: ' num2str(header.digmax(i))]);
      disp([' Prefilt: ' header.prefilt{i}]);
      disp([' Sample Rate: ' num2str(header.samplerate(i))]);
      disp(' ');
     end
    %}

    %%% Select and convert data
    fs = header.samplerate(1);
    selChIdx = header.samplerate == fs;
    EEG = [EEG{selChIdx}];
    ELabel = header.labels(selChIdx);

    %%% Use data
    % Assuming scanEEGviewer is a valid function, uncomment the line below
    % scanEEGviewer(EEG, fs, ELabel);

    %%% Save EEG data and header to MAT file
    matFilePath = fullfile(fileparts(edfFilePath), 'output_data.mat');
    try
        save(matFilePath, 'EEG', 'header');
        disp(['Data saved as MAT file: ' matFilePath]);
    catch
        disp('Error saving data to MAT file.');
    end
end
