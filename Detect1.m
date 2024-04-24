% ����������֤ģ�͵�ͼƬ�ͱ�ǩ�ļ�
clear all % ��չ�����
num = 1000; %ÿ���������ͼƬ������
for snr = 0:2:16
    save_path = ['E:\yolov5\data\images\', num2str(snr), 'dB\'];% ���ݼ���·��
    label_path = [save_path, 'labels\'];
    if(exist(label_path, 'dir')  ~= 7)     % �ж��ļ����Ƿ����
       mkdir(label_path);                  % �������򴴽��ļ���
    end
    for i = 1:num
        [~, matrix, random_time] = Signals_STFT(snr); % �õ������ź����͡�f1��f2�ľ���
        saveas(gcf,[save_path, num2str(i), '.jpg']); % ����ͼƬ
        close(); %�ر�ͼƬ
        class = matrix(:,1);
        fid = fopen([label_path, [num2str(i), '.txt']], 'w'); % ����label�ı��ļ�
        for n = 1:length(matrix(:, 1)) % length(matrix(:, 1))�źŸ���
            signal_class = class(n);
            if signal_class == 2 % 2FSK����Դ�
                x = (matrix(n, 2) + (matrix(n, 3) - matrix(n, 2))/2)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                w = (matrix(n, 3)-matrix(n, 2))/120000 + 14/875;   % ��� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��
            elseif signal_class == 3 % 2PSK����Դ�
                x = matrix(n, 3)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                w = 14/875;   % ��� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��   
            elseif signal_class == 1 % FM����Դ�
                x = matrix(n, 3)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                % �����ź�Ƶ�ʣ�500  ����ָ�� 5 
                w = 2 * (5+1) * 500/120000 + 14/875;   % ��� Ϊ�˻����Ŀ���԰����źŶ��������ص�
                h = random_time(n, 2);  % �߶ȼ��ź�ʱ��   
            else  % AM��DSB
                x = matrix(n, 3)/120000;  % ���ĵ�����꼰����Ƶ��
                y = random_time(n, 1); % ���ĵ������꼰����ʱ��λ��
                w = 2 * matrix(n, 2) / 120000 + 14/875;   % ��ȼ����� Ϊ�˻����Ŀ���԰����źŶ��������ص�
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
        disp(['�����Ϊ',num2str(snr),'dB�µĵ�',num2str(i),'��']);
    end
end