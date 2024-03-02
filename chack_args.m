function chack_args(patient,channels,window_size)
    % check patient name
    filePath = strrep(pwd ,"code","dataset");
    folders = dir2(filePath);
    if ~any(strcmp(patient,[folders.name ""]))
        error("Patient name %s is not in dataset folder",patient)
    end
    % check chanels
    channels_names = ["F3","F4","T7","T8","P7","P8","P3","P4"];
    for i = 1:length(channels)
        if ~any(strcmp(channels_names,channels(i)))
            error("Channel name %s is not in EEG 20-10 system",channels(i))
        end
    end
    % check window size
    if window_size > 8000
        error("Window size problem %d > 8000" ,window_size)
    elseif mod(window_size,2)
        error("Window size is Odd number %d",window_size)
    end
end