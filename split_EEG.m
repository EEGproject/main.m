function [EEG_train,EEG_test] = split_EEG(EEG)
    EEG_train = EEG;
    EEG_train(end) = []; 
    EEG_test = EEG(end);
end