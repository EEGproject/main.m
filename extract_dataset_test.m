function [result,len] = extract_dataset_test(EEG,channels,window_size)
    len = floor(EEG.content.samples/window_size);
    folder_name = "test_datasets";
	for k = 1:length(channels)
        dataset = [];
        ch_name = channels(k);
        for i=1:length(EEG)
            ch_index = contains(EEG(i).content.ch,ch_name);
            file = split(EEG(i).file_name,'.');
            mat_file_name = sprintf("%s/%s_%s_%d.mat",folder_name,string(file(1)),ch_name,window_size);
            if exist(mat_file_name,'file') == 2
                fprintf("Load from %s\n",mat_file_name)
                load(mat_file_name,'T')
            else
                fprintf("Generate dataset from %s channel %s\n",EEG(i).file_name,ch_name)
                T = generate_dataset_test(EEG(i).content,ch_index,window_size);
                save(mat_file_name,'T')
            end
            dataset = [dataset;T];
        end
        result(k).ch_name = ch_name;
        result(k).dataset = dataset;
     end
end