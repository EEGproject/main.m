function [T] = generate_dataset(content, ch_index, window_size)
    % Check if seizures are present
    if isempty(content.seizures)
        fprintf("No seizures found for %s\n", content.ch);
        T = table();  % Return an empty table
        return;
    end
    
    count = content.samples * content.ch_num;
    len = floor(count/window_size) - 1;
    
    % Initialize the table
    T = array2table(ones(len, 10) * 2, 'VariableNames', {'Seizure'...
        'Entropy' 'Energy 1' 'Energy 2' 'Energy 3' ...
        'Energy 4' 'Energy 5' 'Energy 6' 'Energy 7' 'Energy 8'});
    
    srate = content.srate;
    Signal = content.signals(ch_index, :);
    Seizure_Signal = [];
    
    for t = 1:content.seizures.amount % Corrected loop condition
        start_seizure = content.seizures.start_seizures(t) * srate;
        end_seizure = content.seizures.end_seizures(t) * srate;
        Seizure_Signal = [Seizure_Signal Signal(start_seizure:end_seizure)];
        Signal(start_seizure:end_seizure) = [];
    end
    
    p = 1;
    
    for p = 1:floor(length(Signal)/window_size) % analyze signal
        index = p;
        Start = 1 + (p - 1) * window_size;
        End = p * window_size;
        signal = Signal(Start:End);
        T.Seizure(index) = false;
        features = extract_features(signal, window_size);
        T.Entropy(index) = features{1};
        T.("Energy 1")(index) = features{2};
        T.("Energy 2")(index) = features{3};
        T.("Energy 3")(index) = features{4};
        T.("Energy 4")(index) = features{5};
        T.("Energy 5")(index) = features{6};
        T.("Energy 6")(index) = features{7};
        T.("Energy 7")(index) = features{8};
        T.("Energy 8")(index) = features{9};
    end
    
    for i = 1:floor(length(Seizure_Signal)/window_size)
        index = p + i;
        Start = 1 + (i - 1) * window_size;
        End = i * window_size;
        signal = Seizure_Signal(Start:End);
        T.Seizure(index) = true;
        features = extract_features(signal, window_size);
        T.Entropy(index) = features{1};
        T.("Energy 1")(index) = features{2};
        T.("Energy 2")(index) = features{3};
        T.("Energy 3")(index) = features{4};
        T.("Energy 4")(index) = features{5};
        T.("Energy 5")(index) = features{6};
        T.("Energy 6")(index) = features{7};
        T.("Energy 7")(index) = features{8};
        T.("Energy 8")(index) = features{9};
    end
    
    % Remove rows with Seizure value 2
    if any(T.Seizure == 2)
        T(T.Seizure == 2, :) = [];
    end
end
