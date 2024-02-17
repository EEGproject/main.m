classdef EEG_data
    properties (SetAccess = private)
        File_name
        Path
        data
        header
        Seizures
    end
    methods
        function self = EEG_data()
            self.File_name = {'a','s','d'};
            self.Path = {'e','w','q'};
        end
    end
end