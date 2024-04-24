%% �鿴���Ŀ��Ƿ���ȷ
%% ����,·����ʼ��
clear all % ��չ�����
root_path = 'E:\datasets\20000';% ���ݼ���·��
save_path = 'E:\datamake\textbox\';% ��õ�ͼ����ĵ�ַ
% train_label_path = [root_path, '\train\labels\']; % ѵ����label�ı�����·��
% train_im_path = [root_path, '\train\images\']; % ѵ����ͼƬ����·��
train_label_path = 'E:\result\frcnn\0dB\labels\'; % ѵ����label�ı�����·��
train_im_path = 'E:\yolov5\data\images\0dB\'; % ѵ����ͼƬ����·��
val_label_path = [root_path, '\valid\labels\']; % ��֤��label�ı�����·��
val_im_path = [root_path, '\valid\images\']; % ��֤��ͼƬ����·��                                                                                                                                                                                                                                                                                                                                  \'];% ��֤��label�ı�����·��
im_train_num = length(dir([train_im_path, '*.jpg'])); %ѵ����ͼƬ������
im_val_num = length(dir([val_im_path, '*.jpg'])); %��֤������ͼƬ������
im_all_num = im_train_num + im_val_num; %����ͼƬ������
signal_num = 4;%ÿ��ͼ���źŵĸ���
%% ����
for i = 1:im_all_num
%   ͼƬ�ߴ�:[875,656]
%   ��������Ƶ�ʣ�0-120hz����������ʱ��0-2s
%   box ��������(x,y) ��� w �߶� h
    if i <= im_train_num
        im_save_path = train_im_path;
        label_save_path = train_label_path;
    else
        im_save_path = val_im_path;
        label_save_path = val_label_path;
    end
    image = imread([im_save_path, num2str(i), '.jpg']); % ��ȡͼƬ
    data = load([label_save_path,[num2str(i),'.txt']]); % ��ȡ�ı��е�label��Ϣ
    image_size = size(image);
    for n = 1:length(data(:,1))
% ���ĵ�(x,y), ��w, ��h
        w = data(n,4) * image_size(2);  
        h = data(n,5) * image_size(1);
        x = data(n,2) * image_size(2);
        y = data(n,3) * image_size(1);
        image(round(y-h/2+1), round(x-w/2+1):round(x+w/2)) = 1; % box�ϱ�
        image(round(y+h/2), round(x-w/2+1):round(x+w/2)) = 1; % box�±�
        image(round(y-h/2+1):round(y+h/2), round(x-w/2)) = 1; % box���
        image(round(y-h/2)+1:round(y+h/2), round(x+w/2)) = 1; % box�ұ� 
% ���Ͻ�(Xmin,Ymin) ���½�(Xmax,Ymax)
%         xmin = data(n,1);  
%         ymin = data(n,2);
%         xmax = data(n,3);
%         ymax = data(n,4);
%         image(ymin, xmin:xmax) = 1; % box�ϱ�
%         image(ymax, xmin:xmax) = 1; % box�±�
%         image(ymin:ymax, xmin) = 1; % box���
%         image(ymin:ymax, xmax) = 1; % box�ұ� 
        imshow(image);
        set(gca,'looseInset', [0 0 0 0]);
        set(gca, 'xtick', [], 'ytick',[],  'xcolor', 'w', 'ycolor', 'w')
    end
    imwrite(image, [save_path, ['box_',num2str(i)], '.jpg']);
    close(); %�ر�ͼƬ
end