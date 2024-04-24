%% ·��
tic
clear all % ��չ�����
clc % ���������
real_path = 'E:\det\'; % ��ʵ���ݵ�·��\
calculate_rootpath = 'E:\result\'; % Ԥ������·��
 % my_anchor_samplenum
CIOU_DIOU_NMS_5000_path = [calculate_rootpath, 'samplenum\CIOU+DIOU-NMS_5000\detect_results\']; 
CIOU_DIOU_NMS_10000_path = [calculate_rootpath, 'samplenum\CIOU+DIOU-NMS_10000\detect_results\'];
CIOU_DIOU_NMS_20000_path = [calculate_rootpath, 'samplenum\CIOU+DIOU-NMS_20000\detect_results\'];
 % my_anchor_strategy
CIOU_DIOU_NMS_20000_path = [calculate_rootpath, 'strategy\CIOU+DIOU-NMS_20000\detect_results\']; 
CIOU_IOU_NMS_20000_path = [calculate_rootpath, 'strategy\CIOU+IOU-NMS_20000\detect_results\'];
IOU_NMS_20000_path = [calculate_rootpath, 'strategy\IOU-NMS_20000\detect_results\'];

Frcnn_path = 'E:\result\frcnn\';
%% ������ͬ��������������ָ���ͼ
% ������ռ���õļ�����
num = 1000; % ÿ��db���ı��ļ�������
CIOU_DIOU_NMS_5000 = []; % 5000�����ݼ�[dB, Pd, Pf, Eavg]
CIOU_DIOU_NMS_10000 = []; % 10000�����ݼ�[dB, Pd, Pf, Eavg]
CIOU_DIOU_NMS_20000 = []; % 20000�����ݼ�[dB, Pd, Pf, Eavg]
Frcnn_20000 = []; % ��frcnnѵ�����Ľ��[dB, Pd, Pf, Eavg]
%% CIOU_DIOU_NMS_5000�������
for dB = 0:2:16  % ����ÿ��SNR�µ�label�ļ���
    N3ME_5000 = []; % ������һ��dB��ˢ��
    for i = 1:num % ����ÿ��SNR�µ�label�ļ����µ�һ��num��1000����labels�ı��ļ�������Ԥ���ʵ��
        % �ж��ļ��Ƿ���ڣ����ھͶ�ȡ�ļ���yolov5���һ��ͼ��ⲻ��Ŀ��Ͳ������txt�ļ���
        if(exist([[CIOU_DIOU_NMS_5000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[CIOU_DIOU_NMS_5000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            % N3ME_5000 : [N, M, Mt, Mf, Eavg]
            N3ME_5000 = [N3ME_5000; ML];
        else % �����ھͼ�¼�¶�Ӧ��ʵ���źŵĸ�������ʼ��һ��label�ļ�
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % һ��ͼ��ʵ���źŵĸ���
            N3ME_5000 = [N3ME_5000; N, 0, 0, 0, 0]; % ��¼��Ӧ��ʵ���źŵĸ���N������������
            disp(['Yolov5,���ݼ�5000��', [num2str(dB),'dB�µ�', num2str(i), '��һ����û�м�����']])
            continue;
        end
    end
    N3ME_5000_dB(:, :, dB/2 + 1) = N3ME_5000; % ��������db�µĽ��
    N = sum(N3ME_5000(:, 1)); M = sum(N3ME_5000(:, 2));
    Mt = sum(N3ME_5000(:, 3)); Mf = sum(N3ME_5000(:, 4));
    Eavg = sum(N3ME_5000(:, 5));
%     disp([num2str(dB),'dB��ʵ���ź�������', num2str(N)])
%     disp([num2str(dB),'dB�¼������ź�������', num2str(M)])
%     disp([num2str(dB),'dB����ʵ�ź�������', num2str(Mt)])
%     disp([num2str(dB),'dB������ź�������', num2str(Mf)])
    Pd = Mt/N; % ������
    Pf = Mf/M; % �龯����
    Eavg = Eavg/(4 * Mt); % ��Ϣ����ƽ�����
    CIOU_DIOU_NMS_5000 = [CIOU_DIOU_NMS_5000; dB, Pd, Pf, Eavg];
end
%% CIOU_DIOU_NMS_10000�������
for dB = 0:2:16  % ����ÿ��SNR�µ�label�ļ���
    N3ME_10000 = [];
    for i = 1:num % ����ÿ��SNR�µ�label�ļ����µ�һ��num��1000����labels�ı��ļ�������Ԥ���ʵ��
        % �ж��ļ��Ƿ���ڣ����ھͶ�ȡ�ļ���yolov5���һ��ͼ��ⲻ��Ŀ��Ͳ������txt�ļ���
        if(exist([[CIOU_DIOU_NMS_10000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[CIOU_DIOU_NMS_10000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            % N3ME_10000 : [N, M, Mt, Mf, Eavg]
            N3ME_10000 = [N3ME_10000; ML];
        else % �����ھͼ�¼�¶�Ӧ��ʵ���źŵĸ�������ʼ��һ��label�ļ�
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % һ��ͼ��ʵ���źŵĸ���
            N3ME_10000 = [N3ME_10000; N, 0, 0, 0, 0];   
            disp(['Yolov5,���ݼ�10000��', [num2str(dB),'dB�µ�', num2str(i), '��һ����û�м�����']])
            continue;
        end
    end
    N3ME_10000_dB(:, :, dB/2 + 1) = N3ME_10000; % ��������db�µĽ��
    N = sum(N3ME_10000(:, 1)); M = sum(N3ME_10000(:, 2));
    Mt = sum(N3ME_10000(:, 3)); Mf = sum(N3ME_10000(:, 4));
    Eavg = sum(N3ME_10000(:, 5));
%     disp([num2str(dB),'dB��ʵ���ź�������', num2str(N)])
%     disp([num2str(dB),'dB�¼������ź�������', num2str(M)])
%     disp([num2str(dB),'dB����ʵ�ź�������', num2str(Mt)])
%     disp([num2str(dB),'dB������ź�������', num2str(Mf)])
    Pd = Mt/N; % ������
    Pf = Mf/M; % �龯����
    Eavg = Eavg/(4 * Mt); % ��Ϣ����ƽ�����
    CIOU_DIOU_NMS_10000 = [CIOU_DIOU_NMS_10000; dB, Pd, Pf, Eavg];
end
%% CIOU_DIOU_NMS_20000�������
for dB = 0:2:16  % ����ÿ��SNR�µ�label�ļ���
    N3ME_20000 = [];
    for i = 1:num % ����ÿ��SNR�µ�label�ļ����µ�һ��num��1000����labels�ı��ļ�������Ԥ���ʵ��
        % �ж��ļ��Ƿ���ڣ����ھͶ�ȡ�ļ���yolov5���һ��ͼ��ⲻ��Ŀ��Ͳ������txt�ļ���
        if(exist([[CIOU_DIOU_NMS_20000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[CIOU_DIOU_NMS_20000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N3ME_20000 = [N3ME_20000; ML];
        else % �����ھͼ�¼�¶�Ӧ��ʵ���źŵĸ�������ʼ��һ��label�ļ�
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % һ��ͼ��ʵ���źŵĸ���
            N3ME_20000 = [N3ME_20000; N, 0, 0, 0, 0];
            disp(['Yolov5,���ݼ�20000��', [num2str(dB),'dB�µ�', num2str(i), '��һ����û�м�����']])
            continue;
        end
    end
    N3ME_20000_dB(:, :, dB/2 + 1) = N3ME_20000; % ��������db�µĽ��
    N = sum(N3ME_20000(:, 1)); M = sum(N3ME_20000(:, 2));
    Mt = sum(N3ME_20000(:, 3)); Mf = sum(N3ME_20000(:, 4));
    Eavg = sum(N3ME_20000(:, 5));
%     disp([num2str(dB),'dB��ʵ���ź�������', num2str(N)])
%     disp([num2str(dB),'dB�¼������ź�������', num2str(M)])
%     disp([num2str(dB),'dB����ʵ�ź�������', num2str(Mt)])
%     disp([num2str(dB),'dB������ź�������', num2str(Mf)])
    Pd = Mt/N; % ������
    Pf = Mf/M; % �龯����
    Eavg = Eavg/(4 * Mt); % ��Ϣ����ƽ�����
    CIOU_DIOU_NMS_20000 = [CIOU_DIOU_NMS_20000; dB, Pd, Pf, Eavg];
end
%% Frcnn�������
for dB = 0:2:16  % ����ÿ��SNR�µ�label�ļ���
    N3ME_Frcnn = []; % ������һ��dB��ˢ��
    for i = 1:num % ����ÿ��SNR�µ�label�ļ����µ�һ��num��1000����labels�ı��ļ�������Ԥ���ʵ��
        % �ж��ļ��Ƿ���ڣ����ھͶ�ȡ�ļ���yolov5���һ��ͼ��ⲻ��Ŀ��Ͳ������txt�ļ���
        if(exist([[Frcnn_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[Frcnn_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            % N3ME_5000 : [N, M, Mt, Mf, Eavg]
            N3ME_Frcnn = [N3ME_Frcnn; ML];
        else % �����ھͼ�¼�¶�Ӧ��ʵ���źŵĸ�������ʼ��һ��label�ļ�
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % һ��ͼ��ʵ���źŵĸ���
            N3ME_Frcnn = [N3ME_Frcnn; N, 0, 0, 0, 0]; % ��¼��Ӧ��ʵ���źŵĸ���N������������
            disp(['Frcnn,���ݼ�20000��', [num2str(dB),'dB�µ�', num2str(i), '��һ����û�м�����']])
            continue;
        end
    end
    N3ME_Frcnn_dB(:, :, dB/2 + 1) = N3ME_Frcnn; % ��������db�µĽ��
    N = sum(N3ME_Frcnn(:, 1)); M = sum(N3ME_Frcnn(:, 2));
    Mt = sum(N3ME_Frcnn(:, 3)); Mf = sum(N3ME_Frcnn(:, 4));
    Eavg = sum(N3ME_Frcnn(:, 5));
%     disp([num2str(dB),'dB��ʵ���ź�������', num2str(N)])
%     disp([num2str(dB),'dB�¼������ź�������', num2str(M)])
%     disp([num2str(dB),'dB����ʵ�ź�������', num2str(Mt)])
%     disp([num2str(dB),'dB������ź�������', num2str(Mf)])
    Pd = Mt/N; % ������
    Pf = Mf/M; % �龯����
    Eavg = Eavg/(4 * Mt); % ��Ϣ����ƽ�����
    Frcnn_20000 = [Frcnn_20000; dB, Pd, Pf, Eavg];
end
% CIOU_IOU_NMS_20000 = PdPfEavg(real_path, CIOU_IOU_NMS_20000_path);
% IOU_NMS_20000 = PdPfEavg(real_path, IOU_NMS_20000);
%% Plot
x_axis = 0:2:16;
% CIOU_DIOU_NMS_5000
CIOU_DIOU_NMS_5000_Pd = CIOU_DIOU_NMS_5000(:, 2);
CIOU_DIOU_NMS_5000_Pf = CIOU_DIOU_NMS_5000(:, 3);
CIOU_DIOU_NMS_5000_Eavg = CIOU_DIOU_NMS_5000(:, 4);
% CIOU_DIOU_NMS_10000
CIOU_DIOU_NMS_10000_Pd = CIOU_DIOU_NMS_10000(:, 2);
CIOU_DIOU_NMS_10000_Pf = CIOU_DIOU_NMS_10000(:, 3);
CIOU_DIOU_NMS_10000_Eavg = CIOU_DIOU_NMS_10000(:, 4);
% CIOU_DIOU_NMS_20000
CIOU_DIOU_NMS_20000_Pd = CIOU_DIOU_NMS_20000(:, 2);
CIOU_DIOU_NMS_20000_Pf = CIOU_DIOU_NMS_20000(:, 3);
CIOU_DIOU_NMS_20000_Eavg = CIOU_DIOU_NMS_20000(:, 4);
% Frcnn
Frcnn_20000_Pd = Frcnn_20000(:, 2);
Frcnn_20000_Pf = Frcnn_20000(:, 3);
Frcnn_20000_Eavg = Frcnn_20000(:, 4);

%% yolov5 ��ͬѵ�������ļ������Ա�
% yolov5 Pd
figure(1) % ��������ͼ
subplot(131)
plot(x_axis, CIOU_DIOU_NMS_5000_Pd*100,'-o','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, CIOU_DIOU_NMS_10000_Pd*100, '-x','MarkerIndices',1:length(x_axis));
plot(x_axis, CIOU_DIOU_NMS_20000_Pd*100, '-*','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X���������ʾ��Χ
set(gca, 'XTick', 0:2:16); % ����Ҫ��ʾ�����
title('Pd');
xlabel('����ȣ�dB��');
ylabel('�����ʣ�%��');
legend('ѵ��ʱƵͼ=5000','ѵ��ʱƵͼ=10000', 'ѵ��ʱƵͼ=20000');
grid on % ������
% yolov5 Pf
subplot(132)
plot(x_axis, CIOU_DIOU_NMS_5000_Pf*100, '-o','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, CIOU_DIOU_NMS_10000_Pf*100, '-x','MarkerIndices',1:length(x_axis));
plot(x_axis, CIOU_DIOU_NMS_20000_Pf*100, '-*','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X���������ʾ��Χ
set(gca, 'XTick', 0:2:16); % ����Ҫ��ʾ�����
title('Pf');
xlabel('����ȣ�dB��');
ylabel('�龯���ʣ�%��');
legend('ѵ��ʱƵͼ=5000','ѵ��ʱƵͼ=10000', 'ѵ��ʱƵͼ=20000');
grid on
% yolov5 Eavg
subplot(133)
plot(x_axis, CIOU_DIOU_NMS_5000_Eavg*100, '-o','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, CIOU_DIOU_NMS_10000_Eavg*100, '-x','MarkerIndices',1:length(x_axis));
plot(x_axis, CIOU_DIOU_NMS_20000_Eavg*100, '-*','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X���������ʾ��Χ
set(gca, 'XTick', 0:2:16); % ����Ҫ��ʾ�����
set(gca,'YLim',[0 8]); % Y���������ʾ��Χ
title('Eavg');
xlabel('����ȣ�dB��');
ylabel('��������ƽ����%��');
legend('ѵ��ʱƵͼ=5000','ѵ��ʱƵͼ=10000', 'ѵ��ʱƵͼ=20000');
grid on
%% yolov5��Frcnn �������Ա�
figure(2)
subplot(131) % Pd
plot(x_axis, CIOU_DIOU_NMS_20000_Pd*100, '-*','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, Frcnn_20000_Pd*100, '-x','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X���������ʾ��Χ
set(gca, 'XTick', 0:2:16); % ����Ҫ��ʾ�����
title('Pd');
xlabel('����ȣ�dB��');
ylabel('�����ʣ�%��');
legend('YOLOV5', 'FRCNN');
grid on % ������
subplot(132) % Pf
plot(x_axis, CIOU_DIOU_NMS_20000_Pf*100, '-*','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, Frcnn_20000_Pf*100, '-x','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X���������ʾ��Χ
set(gca, 'XTick', 0:2:16); % ����Ҫ��ʾ�����
title('Pf');
xlabel('����ȣ�dB��');
ylabel('�龯���ʣ�%��');
legend('YOLOV5', 'FRCNN');
grid on
subplot(133) % Eavg
plot(x_axis, CIOU_DIOU_NMS_20000_Eavg*100, '-*','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, Frcnn_20000_Eavg*100, '-x','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X���������ʾ��Χ
set(gca, 'XTick', 0:2:16); % ����Ҫ��ʾ�����
set(gca,'YLim',[0 8]); % Y���������ʾ��Χ
title('Eavg');
xlabel('����ȣ�dB��');
ylabel('��������ƽ����%��');
legend('YOLOV5', 'FRCNN');
grid on
%% ֱ������ͼ
figure(3)
N3ME_5000_dB_Mt = [];
N3ME_10000_dB_Mt = [];
N3ME_20000_dB_Mt = [];
% �������ݼ���ͬdb����ʵ�źŵĸ���
bar_x = 0:2:16;
% ѵ����5000,10000,20000��0-16db�µ���ʵ�ź�
% [N, M, Mt, Mf, Eavg]
for db = 0:2:16
    N3ME_5000_dB_Mt = [N3ME_5000_dB_Mt, sum(N3ME_5000_dB(:,4,db/2 + 1))];
    N3ME_10000_dB_Mt = [N3ME_10000_dB_Mt, sum(N3ME_10000_dB(:,4,db/2 + 1))];
    N3ME_20000_dB_Mt = [N3ME_20000_dB_Mt, sum(N3ME_20000_dB(:,4,db/2 + 1))];
end
bar_y = [N3ME_5000_dB_Mt(1), N3ME_10000_dB_Mt(1), N3ME_20000_dB_Mt(1); % 0dB
         N3ME_5000_dB_Mt(2), N3ME_10000_dB_Mt(2), N3ME_20000_dB_Mt(2); % 2dB
         N3ME_5000_dB_Mt(3), N3ME_10000_dB_Mt(3), N3ME_20000_dB_Mt(3); % 4dB
         N3ME_5000_dB_Mt(4), N3ME_10000_dB_Mt(4), N3ME_20000_dB_Mt(4); % 6dB
         N3ME_5000_dB_Mt(5), N3ME_10000_dB_Mt(5), N3ME_20000_dB_Mt(5); % 8dB
         N3ME_5000_dB_Mt(6), N3ME_10000_dB_Mt(6), N3ME_20000_dB_Mt(6); % 10dB
         N3ME_5000_dB_Mt(7), N3ME_10000_dB_Mt(7), N3ME_20000_dB_Mt(7); % 12dB
         N3ME_5000_dB_Mt(8), N3ME_10000_dB_Mt(8), N3ME_20000_dB_Mt(8); % 14dB
         N3ME_5000_dB_Mt(9), N3ME_10000_dB_Mt(9), N3ME_20000_dB_Mt(9);]; % 16dB
b = bar(bar_x, bar_y, 'FaceColor', 'flat');
for k = 1:size(bar_y,2)
    b(k).CData = k;
end
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips3 = b(3).XEndPoints;
ytips3 = b(3).YEndPoints;
labels3 = string(b(3).YData);
text(xtips3,ytips3,labels3,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('5000','10000', '20000');
toc