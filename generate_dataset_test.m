function [T] = generate_dataset_test(content,ch_index,window_size) 
    len = floor(content.samples /window_size);
    T = array2table(ones(len,10)*2,'VariableNames',{'Seizure'... 
            'Entropy' 'Energy 1' 'Energy 2' 'Energy 3' ...
            'Energy 4' 'Energy 5' 'Energy 6' 'Energy 7' 'Energy 8'});
	srate = content.srate;
	Signal = content.signals(ch_index,:);
	Seizure_Signal = [];
	for t = 1:content.seizures.amount % extract seizure signal
        start_seizure = content.seizures.start_seizures(t)* srate;
        end_seizure = content.seizures.end_seizures(t)* srate;
        Seizure_Signal = [Seizure_Signal zeros(1,start_seizure-length(Seizure_Signal))];
        Seizure_Signal = [Seizure_Signal ones(1,end_seizure-length(Seizure_Signal))];
    end 
    if length(Seizure_Signal) ~= content.samples
        Seizure_Signal = [Seizure_Signal zeros(1,content.samples-length(Seizure_Signal))];
    end
    for p = 1 : floor(content.samples/window_size) % analyze signal 
        index = p;
        Start = 1 + (p-1)*window_size;
        End = p*window_size;
        signal = Signal(Start : End);
        if sum(Seizure_Signal(Start:End)) > window_size/2
            T.Seizure(index) = true;
        else
            T.Seizure(index) = false;
        end
        features = extract_features(signal,window_size);
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
    if any(T.Seizure == 2)
        T(T.Seizure == 2,:) = [];
    end
end