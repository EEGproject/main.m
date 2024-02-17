
function test_accurecy(EEG,window_size,SVMMdl)
    for i=1:length(EEG)
        signal = EEG(i).data.signals(2,:);
        srate = EEG(i).data.srate;
        start_seizure = EEG(i).seizures.start_seizures*srate;
        end_seizure = EEG(i).seizures.end_seizures*srate;
        error = 0;
        known_arr = [];
        predict_arr = [];
        result_line = [];
        tseizure = [];
        arr = ["non_seizure","seizure"];
        for k=1:floor(EEG(i).data.samples/window_size)
            start = 1+(k-1)*window_size;
            if sum(start_seizure<start) - sum(end_seizure<start) == 0
                known_arr = [known_arr "non_seizure"];
            else
                known_arr = [known_arr "seizure"];
            end
            chunk = signal(start:k*window_size);
            temp = removevars(extract_features(chunk,NaN),{'Seizure'});
            [result,~] = predict(SVMMdl,temp);
            result_line = [result_line ones(1,window_size)*result];
            predict_arr = [predict_arr arr(result+1)];
        end
        srate = EEG(i).data.srate;
        samples = EEG(i).data.samples ;
        sstart = EEG(i).seizures.start_seizures*srate;
        send = EEG(i).seizures.end_seizures*srate;
        tseizure = [tseizure zeros(1,sstart)];
        tseizure = [tseizure ones(1,send-sstart)];
        tseizure = [tseizure zeros(1,samples - send)];
        t = 0:1/srate:samples/srate -1/srate;
        figure()
        hold on
        plot(t,signal/max(signal))
        plot(t,tseizure,'LineWidth',2)
        plot(t,(result_line),'LineWidth',2)
        legend("signal","Known Seizures", "predict Seizures")
        xlim([0 3600])
        ylim([0 1.5])
        title("chb1 Record 1") 
        figure()
        confusionchart(known_arr,predict_arr);
    end
end
