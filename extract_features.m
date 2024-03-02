
function [T] = extract_features(data,window_size) 
    
    % for 40 HZ offset is 640
    % for 50 HZ offset is 800
    % (window_size/fs)*40Hz
    fs = 500; 
    start_offset = (window_size/fs);
    end_offset = (window_size/fs)*50;
    Energys = 8;
    
    energy = zeros(1,Energys);
    %entrop = entropy(norm_data);
    entrop = ApEn(2,0.8,data,1);
    Y = abs(fft(data))/window_size;
    P = 2*Y(1:window_size/2+1);
    P(2:end-1) = 2*P(2:end-1);
    
    %f = 256*(0:(window_size/2))/window_size;
    %f = f(1:640);
    range = round(exp(linspace(log(start_offset),log(end_offset),Energys +1)));
    for f = 1:length(range) - 1
        energy(f) = sum(abs(P(range(f):range(f+1))).^2)/(range(f+1) - range(f));
    end
    T = {entrop,energy(1),energy(2),energy(3),energy(4),...
        energy(5),energy(6),energy(7),energy(8)};   
end
