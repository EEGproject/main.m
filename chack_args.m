function chack_args(patient,channels,window_size)
    % check patient name
    filePath = strrep(pwd ,"code","dataset");
    folders = dir2(filePath);
    if ~any(strcmp(patient,[folders.name ""]))
        error("Patient name %s is not in dataset folder",patient)
    end
    % check chanels
    channels_names = ["FP1","F3","T7","F7","FP2","F4","T8","F8"];
    for i = 1:length(channels)
        if ~any(strcmp(channels_names,channels(i)))
            error("Channel name %s is not in EEG 20-10 system",channels(i))
        end
    end
    % check window size
    if window_size > 4096
        error("Window size problem %d > 4096" ,window_size)
    elseif mod(window_size,2)
        error("Window size is Odd number %d",window_size)
    end
end