function [x_signal, signals_matrix, random_time] = Signals_STFT(snr)
    tic
    %% stft��������
    wlen = 1024;% ���ô��ڳ���
    window = hamming(wlen);% ���ú������Ĵ���
    hop = 1;% ÿ��ƽ�ƵĲ���
    noverlap = wlen - hop; % �ص�����
%     f = 0:117.1875:120000;% ����Ƶ�ʿ̶�hz,��ͼ����,����
    nfft = 2^nextpow2(length(window)); % nfft����
    fs = 240000;    % ����Ƶ�� Ƶ��������Ϊ����Ƶ�ʵ�һ��
    %% �źŲ�������
    dt = 1/fs;    % ʱ�侫��
    times_tart = 0; % ��ʼʱ��
    time_end = 1;   % ����ʱ��
    t = times_tart:dt:time_end - dt; % ����ʱ����������ֹʱ��
    signals_matrix = []; % ���������ź����ͺ�Ƶ�ʵľ��� ��ʽΪ class f1 f2
    random_time = []; % ���������ź�����ʱ�̺�ʱ���ľ��� ��ʽΪ ʱ�� ����ʱ��
    x_signal = 0; % ������ϵ��ź�
    class = [0, 1, 2, 3]; % �����ź�����(��0��ʼͬpython)
                          % 0 AM 1 FM 2 2FSK 3 2PSK 4 DSB
    signals_num = randi([2, 8]); % ÿ��ͼ�źŵ�������2��8���
    for i = 1:signals_num
        random_time(i, 2) = unifrnd(0.2, 1.0); % �ź�ʱ��0.2-1s���
        random_time(i, 1) = unifrnd(random_time(i, 2)/2,...
            1 - random_time(i, 2)/2); % �ź�����ʱ���ڱ�֤�ź���ͼ�ڵ�ǰ���������
    end
    %% �����ź�
    for nnum = 1:signals_num % ÿ��ͼһ��signals_num���ź�
        % �����ѡclass�е�һ���ź�����
        signal_class = class(randi([1, length(class)]));
        % �����ź�
        [x, f1, f2] = CreateSignal(signal_class, t);
        % ��������signals_num���źŷ����źž�����
        signals_matrix = [signals_matrix; signal_class, f1, f2];
        % signals_matrix�ߴ�Ϊ signals_num * 3
        x_signal = x_signal + x.*(t > (random_time(nnum, 1) - random_time(nnum, 2)/2) ...
        & t < (random_time(nnum, 1) + random_time(nnum, 2)/2));
    end
    x_signal = x_signal .* Z_Rayleigh(8,100,t); % ��������˥���ŵ�
    x_signal = real(x_signal); % ȡʵ��
    x_signal = awgn(x_signal, snr); % �����˹������
    %% ��ʱ����Ҷ sftf����ͼ
    [s, f, t2] = spectrogram(x_signal, window, noverlap, nfft, fs);
    k = 2/(fs*(window'*window));
    imagesc(f, t2,10*log10(abs(s).*abs(s)*k)');
    set(gca,'looseInset', [0 0 0 0]);% ����ͼ��İױ�
    set(gca, 'xtick', [], 'ytick',[],  'xcolor', 'w', 'ycolor', 'w')% ȥ��������
    colorbar('off'); % ȥ��ͼ���ұߵ�ɫ��
    toc
end