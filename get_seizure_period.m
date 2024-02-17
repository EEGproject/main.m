
function [seizure] = get_seizure_period(filename)
    if isfile(filename)
        file_descriptor = fopen(filename);
        byte_array = fread(file_descriptor);
        seizure.start_time = bin2dec(strcat(dec2bin(byte_array(39)),dec2bin(byte_array(42))));
        seizure.length = byte_array(50);
    else
        seizure.start_time = nan;
        seizure.length = nan;
    end 
end