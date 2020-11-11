% This program reads, denoises, and plots ECG signal data

% Read ECG signal
    load('./dataset_sig/101m.mat')      % input signal data to 'val' variable
    val = (val - 0)/200;                % removing "base" and "gain"
    sig = val(1,1:3600);                % choosing Lead 1 (V1) data and 3600 datapoints (first 10 secs)
    Fs = 360;                           % sampling frequecy
    Fn = Fs/2;                          % Nyquist frequency
    t = (0:length(sig)-1)/Fs;           % time

% Plot signal before processing
    figure(1)
    plot(t, sig, 'LineWidth', 2);
    xlabel("Time (s)")
    ylabel("ECG Amplitude (mV)")
    grid

% 1st denoising with median filter (600 ms sliding window)
    s_win1 = 0:1/Fs:0.06; % 1st sliding window = 600ms
    sig = medfilt1(sig, length(s_win1)-1); % apply median filter
    figure(2);
    plot(t, sig, 'LineWidth', 2)
    xlabel("Time (s)")
    ylabel("ECG Amplitude (mV)")
    grid

% 2nd denoising with median filter (200ms sliding window)
    s_win2 = 0:1/Fs:0.02; %sliding window 2 = 200 ms
    sig = medfilt1(sig, length(s_win2)-1); % apply median filter
    figure(3);
    plot(t, sig, 'LineWidth', 2)
    xlabel("Time (s)")
    ylabel("ECG Amplitude (mV)")
    grid

% 3rd denoising with 12-order FIR filter, 35 Hz cut-off frequency
    fir_filter = fir1(12, (35/Fn));
    sig = filter(fir_filter, 1, sig);
    figure(4)
    freqz(fir_filter, 1, 2^12, Fs)
    figure(5)
    plot(t, sig, 'LineWidth', 3)
    xlabel("Time (s)")
    ylabel("ECG Amplitude (mV)")
    grid
