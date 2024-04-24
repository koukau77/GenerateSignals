% ����������֤ģ�͵�ͼƬ�ͱ�ǩ�ļ�
clear all % ��չ�����
num = 1000; %ÿ���������ͼƬ������
for i = 1:num
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
    for ii = 1:signals_num
        random_time(ii, 2) = unifrnd(0.1, 1.0); % �ź�ʱ��0.2-1s���
        random_time(ii, 1) = unifrnd(random_time(ii, 2)/2,...
            1 - random_time(ii, 2)/2); % �ź�����ʱ���ڱ�֤�ź���ͼ�ڵ�ǰ���������
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
    for snr = 0:2:16
        x_signal = awgn(x_signal, 16-snr); % �����˹������
        save_path = ['E:\yolov5\data\images\', num2str(16-snr), 'dB\'];% ���ݼ���·��
        label_path = [save_path, 'labels\'];
        if(exist(label_path, 'dir')  ~= 7)     % �ж��ļ����Ƿ����
           mkdir(label_path);                  % �������򴴽��ļ���
        end
        %% ��ʱ����Ҷ sftf����ͼ
%         gx_signal = gpuArray(x_signal);
        [s, f, t2] = spectrogram(x_signal, window, noverlap, nfft, fs);
        k = 2/(fs*(window'*window));
        imagesc(f, t2,10*log10(abs(s).*abs(s)*k)');
        set(gca,'looseInset', [0 0 0 0]);% ����ͼ��İױ�
        set(gca, 'xtick', [], 'ytick',[],  'xcolor', 'w', 'ycolor', 'w')% ȥ��������
        colorbar('off'); % ȥ��ͼ���ұߵ�ɫ��
        saveas(gcf,[save_path, num2str(i), '.jpg']); % ����ͼƬ
        close(); %�ر�ͼƬ
        class = signals_matrix(:,1);
        fid = fopen([label_path, [num2str(i), '.txt']], 'w'); % ����label�ı��ļ�
        for n = 1:length(signals_matrix(:, 1)) % length(matrix(:, 1))�źŸ���
            signal_class = class(n);
            if signal_class == 2 % 2FSK����Դ�
                x = (signals_matrix(n, 2) + (signals_matrix(n, 3) - signals_matrix(n, 2))/2)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                w = (signals_matrix(n, 3)-signals_matrix(n, 2))/120000 + 14/875;   % ��� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��
            elseif signal_class == 3 % 2PSK����Դ�
                x = signals_matrix(n, 3)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                w = 14/875;   % ��� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��   
            elseif signal_class == 1 % FM����Դ�
                x = signals_matrix(n, 3)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                % �����ź�Ƶ�ʣ�500  ����ָ�� 5 
                w = 2 * (5+1) * 500/120000 + 14/875;   % ��� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��   
            else  % AM��DSB
                x = signals_matrix(n, 3)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                w = 2 * signals_matrix(n, 2) / 120000 + 14/875;   % ��ȼ����� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��
            end
            signal_class = num2str(signal_class); 
            x = num2str(x);
            y = num2str(y);
            w = num2str(w); 
            h = num2str(h); 
            % ascii�� �ո�32 �س�13
            label = strcat(signal_class, 32, x, 32, y, 32, w, 32, h, 13);
            for jj = 1:length(label)
                fprintf(fid, '%s', label(jj));   
            end 
        end
        fclose(fid);
        disp(['�����Ϊ',num2str(16-snr),'dB�µĵ�',num2str(i),'��']);
    end
end