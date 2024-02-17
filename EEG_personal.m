classdef (HandleCompatible) EEG_personal
    properties (SetAccess = private)
        Patient
        Path
        Content
    end
    properties (Dependent)
        Count
    end
    methods
        function self = EEG_personal(Patient)
            addpath('filters','features','tools');
            self.Patient = Patient;
            filePath = strrep(pwd ,"code","dataset");
            self.Path = filePath + "\" + self.Patient;
            self = self.get_Content();
        end
        function self = set.Patient(self,Patient)
            filePath = strrep(pwd ,"code","dataset");
            result = dir2(filePath);
            if contains([result.name],Patient)
                self.Patient = Patient;
            else
                error('Not such pattient name: %s',Patient)
            end
        end
        function result = get.Count(self)
            result  = 0;
            file_list = dir2(self.Path);
            for i = 1:length(file_list)
                if contains(file_list(i).name,".edf")
                    result = result + 1;
                end
            end
        end
        function self = get_Content(self)
            result = [];
            file_list = dir2(self.Path);
            for i = 1:length(file_list)
                names = split(file_list(i).name,'.');
                if char(names(end)) == "edf"
                    result = [result EEG_data(file_list(i).name,self.Path)];
                end
            end
            self.Content = result;
        end
        function self = Readfiles(self)
            [self,list] = self.Importfiles;
            seizures = self.parse_summary;
            for i=1:length(list)
                file = list(i);
                if ~contains(file.name,".edf")
                    continue
                end
                disp("load file " + file.name)
                [data,header] = ReadEDF(file.folder + "\" + file.name);
                self = self.set_data(file.name,data,header,seizures);
            end  
        end
        function result = parse_summary(self)
            file_name = self.Path + "\" + self.Patient + "-summary-new.txt";
            file = fileread(file_name);
            file_split = strsplit(file, newline);
            match = contains(file_split, 'chb');
            start_seizures = [];
            end_seizures = [];
            seiz_idx = 0;
            num_of_seiz_files = 1;
            for num = 1:length(match)
                if match(num)
                    amount = split(file_split(num+1),': ');
                    amount = str2double(cell2mat(amount(2)));
                    if amount == 0
                        continue
                    end
                    file_name = split(file_split(num),': ');
                    file_name = regexprep(cell2mat(file_name(2)),'[\n\r]+','');
                    amount_idx = amount;
                    while (amount_idx)
                        start_time = split(file_split(num+2+seiz_idx),':');
                        start_time = split(start_time(2));
                        start_time = str2double(cell2mat(start_time(2)));
                        start_seizures = [start_seizures start_time];

                        end_time = split(file_split(num+3+seiz_idx),':');
                        end_time = split(end_time(2));
                        end_time = str2double(cell2mat(end_time(2)));
                        end_seizures = [end_seizures end_time];
                        seiz_idx = seiz_idx + 2;
                        amount_idx = amount_idx - 1;
                    end
                    seizures(num_of_seiz_files).filename = file_name;
                    seizures(num_of_seiz_files).start_seizures = start_seizures;
                    seizures(num_of_seiz_files).end_seizures = end_seizures;
                    seizures(num_of_seiz_files).amount = amount;
                    num_of_seiz_files = num_of_seiz_files + 1;
                    seiz_idx = 0;
                    start_seizures = [];
                    end_seizures = [];
                end
            end
            result = seizures;
        end
        function self = set_data(self,filename,data,header,seizures)
            samples = header.records * header.samplerate(1);
            data_z = zeros(length(channels),samples);
            for j=1:length(channels)
                for k=1:header.channels
                    if cell2mat(header.labels(k)) == channels(j)
                        signal = data(k);
                        data_z(j,:)= signal{:}; 
                        break
                    end
                end 
            end
            new_data.ch = channels;
            new_data.signals = data_z;
            new_data.samples = samples;
            new_data.srate = header.samplerate(1);
            new_data.ch_num = length(channels);
        end
        function self = print_status(self)
            fprintf('the satus is, patitnt : %s\n',self.patient)
        end
        
    end
end
            