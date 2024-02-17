
function [T] = extract_features_table(signal, window_size)
    T = array2table(zeros(1,9));
    T.Properties.VariableNames = {'Entropy','Energy 1','Energy 2','Energy 3',...
            'Energy 4','Energy 5','Energy 6','Energy 7','Energy 8'};
    features = extract_features(signal,window_size);
    T.Entropy = features{1};
    T.("Energy 1") = features{2};
    T.("Energy 2") = features{3};
    T.("Energy 3") = features{4};
    T.("Energy 4") = features{5};
    T.("Energy 5") = features{6};
    T.("Energy 6") = features{7};
    T.("Energy 7") = features{8};
    T.("Energy 8") = features{9};
end
