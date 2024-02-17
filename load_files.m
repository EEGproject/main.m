% load all files in dataset folder
% input none, the function know the path
% output EEG struct contian the data and headers of files

function [EEG] = load_files(patient, channels)
    filePath = strrep(pwd ,"code","dataset");
    path = filePath + '\' + patient;
    files = dir2(path);
    files_idx = 1;
    seizures = parse_summary(path + '\' + '-summary.txt');
    for i = 1:length(files)
        if contains(files(i).name,".seizures")
            file_name = erase(files(i).name,".seizures");
            disp("load file " + file_name)
            [data,header] = ReadEDF(path + '\' + file_name);
            EEG(files_idx).file_name = file_name;
            EEG(files_idx).content = order_content(file_name,data,header,channels,seizures);
            files_idx = files_idx + 1;           
        end
    end
    disp("Finish load files")
end
