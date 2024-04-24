%% ����,·����ʼ��
clear all % ��չ�����
root_path = 'E:\datasets\8-16dB';% ���ݼ���·��
train_label_path = [root_path, '\train\labels\'];% ѵ����label�ı�����·��
if(exist(train_label_path, 'dir')  ~= 7)     % �ж��ļ����Ƿ����
   mkdir(train_label_path);                  % �������򴴽��ļ���
end
train_im_path = [root_path, '\train\images\'];% ѵ����label�ı�����·��
if(exist(train_im_path, 'dir')  ~= 7)     % �ж��ļ����Ƿ����
   mkdir(train_im_path);                  % �������򴴽��ļ���
end
val_label_path = [root_path, '\valid\labels\'];% ��֤��label�ı�����·��
if(exist(val_label_path, 'dir')  ~= 7)     % �ж��ļ����Ƿ����
   mkdir(val_label_path);                  % �������򴴽��ļ���
end
val_im_path = [root_path, '\valid\images\'];% ��֤��label�ı�����·��
if(exist(val_im_path, 'dir')  ~= 7)     % �ж��ļ����Ƿ����
   mkdir(val_im_path);                  % �������򴴽��ļ���
end
im_all_num = 1000; %����ͼƬ������
im_train_num = 0.8 * im_all_num;%ѵ����ͼƬ������
im_val_num = 0.2 * im_all_num;%��֤������ͼƬ������
snr = randi([8, 16]); % ������������
%%
% ׼��ѵ�����ݼ�����֤���ݼ�
% ����yolo��ʽ��label����
for i = 1:im_all_num  
%   ͼƬ�ߴ�:[875,656]
%   ��������Ƶ�ʣ�0-120khz����������ʱ��0-1s
%   box  ��������(x,y)  ��� w  �߶� h
    disp(['��',num2str(i),'��']);
    if i <= im_train_num % ����·��Ϊѵ������·��
        im_save_path = train_im_path;
        label_save_path = train_label_path;
    else   % ����·��Ϊ��֤����·��
        im_save_path = val_im_path;
        label_save_path = val_label_path;
    end
    [~, matrix, random_time] = Signals_STFT(snr); % �õ������ź����͡�f1��f2�ľ���
    saveas(gcf,[im_save_path, num2str(i), '.jpg']); % ����ͼƬ
    close(); %�ر�ͼƬ
    class = matrix(:,1);
    fid = fopen([label_save_path, [num2str(i), '.txt']], 'w'); % ����label�ı��ļ�
    for n = 1:length(matrix(:, 1)) % length(matrix(:, 1))�źŸ���
        signal_class = class(n);
        if signal_class == 2 % 2FSK����Դ�
            x = (matrix(n, 2) + (matrix(n, 3) - matrix(n, 2))/2)/120000;  % ���ĵ������
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
end