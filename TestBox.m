%% 查看画的框是否正确
%% 参数,路径初始化
clear all % 清空工作区
root_path = 'E:\datasets\20000';% 数据集根路径
save_path = 'E:\datamake\textbox\';% 框好的图保存的地址
% train_label_path = [root_path, '\train\labels\']; % 训练集label文本保存路径
% train_im_path = [root_path, '\train\images\']; % 训练集图片保存路径
train_label_path = 'E:\result\frcnn\0dB\labels\'; % 训练集label文本保存路径
train_im_path = 'E:\yolov5\data\images\0dB\'; % 训练集图片保存路径
val_label_path = [root_path, '\valid\labels\']; % 验证集label文本保存路径
val_im_path = [root_path, '\valid\images\']; % 验证集图片保存路径                                                                                                                                                                                                                                                                                                                                  \'];% 验证集label文本保存路径
im_train_num = length(dir([train_im_path, '*.jpg'])); %训练集图片的数量
im_val_num = length(dir([val_im_path, '*.jpg'])); %验证集所有图片的数量
im_all_num = im_train_num + im_val_num; %所有图片的数量
signal_num = 4;%每张图中信号的个数
%% 画框
for i = 1:im_all_num
%   图片尺寸:[875,656]
%   横坐标是频率，0-120hz；纵坐标是时间0-2s
%   box 中心坐标(x,y) 宽度 w 高度 h
    if i <= im_train_num
        im_save_path = train_im_path;
        label_save_path = train_label_path;
    else
        im_save_path = val_im_path;
        label_save_path = val_label_path;
    end
    image = imread([im_save_path, num2str(i), '.jpg']); % 读取图片
    data = load([label_save_path,[num2str(i),'.txt']]); % 读取文本中的label信息
    image_size = size(image);
    for n = 1:length(data(:,1))
% 中心点(x,y), 宽w, 高h
        w = data(n,4) * image_size(2);  
        h = data(n,5) * image_size(1);
        x = data(n,2) * image_size(2);
        y = data(n,3) * image_size(1);
        image(round(y-h/2+1), round(x-w/2+1):round(x+w/2)) = 1; % box上边
        image(round(y+h/2), round(x-w/2+1):round(x+w/2)) = 1; % box下边
        image(round(y-h/2+1):round(y+h/2), round(x-w/2)) = 1; % box左边
        image(round(y-h/2)+1:round(y+h/2), round(x+w/2)) = 1; % box右边 
% 左上角(Xmin,Ymin) 右下角(Xmax,Ymax)
%         xmin = data(n,1);  
%         ymin = data(n,2);
%         xmax = data(n,3);
%         ymax = data(n,4);
%         image(ymin, xmin:xmax) = 1; % box上边
%         image(ymax, xmin:xmax) = 1; % box下边
%         image(ymin:ymax, xmin) = 1; % box左边
%         image(ymin:ymax, xmax) = 1; % box右边 
        imshow(image);
        set(gca,'looseInset', [0 0 0 0]);
        set(gca, 'xtick', [], 'ytick',[],  'xcolor', 'w', 'ycolor', 'w')
    end
    imwrite(image, [save_path, ['box_',num2str(i)], '.jpg']);
    close(); %关闭图片
end