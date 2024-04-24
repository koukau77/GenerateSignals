function ML = PdPfEavg(real_path, calculate_path)
    %% 参数初始化
    N = 0; % 实际信号总数
    M = 0; % 检测出的信号个数
    Mt = 0; % M中真实信号个数，即检测到的信号中真的是信号的个数
    Mf = 0; % M中虚假的信号个数，即误测的信号个数
    Pd = 0; % 检测概率 Pd = Mt/N
    Pf = 0; % 虚警概率 Pf = Mf/M
    Eavg = 0; % 信息参数平均误差
    ML = []; % 用来接收各个db下检测指标参数的矩阵 
    %% 计算三个指标
     % 读取一个实际文本中的所有label信息
    real_data = load(real_path);
    n = length(real_data(:,1)); % 一张图中实际信号的个数
    N = N + n; % 总共的实际信号数量 = 求和（每张图中实际信号的个数）
    calculate_data = load(calculate_path);
    m = length(calculate_data(:,1)); % 一张图中检测出的信号的个数
    M = M + m; % 总共检测出的信号数量 = 求和（每张图中检测出的信号数量）
    for ii = 1:m % 遍历一个预测label文件中的所有信号
        calculate_signal = calculate_data(ii, :); % 一个预测信号
        delect_class = calculate_signal(1); % 得到预测信号的类别
         % 找出文件名一样的实际信号label文件中与calculate_signal相同类别的信号的行序列号
        x = find(real_data(:, 1) == delect_class);
        if isempty(x) % 检测出了实际信号中不存在的信号时
            Mf = Mf + 1; % 虚假信号加1
        else
            d = []; % 刷新数组d的长度
            for iii = 1:length(x) % 遍历所有找到的与calculate_signal类别相同的实际信号
                % 用俩个信号中心点的欧氏距离的最小值来找到与calculate_signal匹配的实际信号
                x_c = calculate_signal(2); y_c = calculate_signal(3); % calculate_signal中心坐标(x_c,y_c)
                x_r = real_data(x(iii), 2); y_r = real_data(x(iii), 3); % 实际信号中心坐标(x_r,y_r)
                d(iii) = (x_c - x_r)^2 + (y_c - y_r)^2;   % 算俩点距离的平方
            end
            [mmin, note] = min(d); % 得到最小值所在的d向量的序列号note
            signal_note = x(note); % 得到最小值所对应的实际信号的在矩阵real_data中的行序列号signal_note
            real_signal = real_data(signal_note, :); % 得到与calculate_signal匹配的实际信号
            cbox = calculate_signal(2: 5); % calculate_signal的box [x, y, w, h]
            rbox = real_signal(2: 5); % real_signal的box [x, y, w, h]
            iou = Box_IOU(cbox, rbox); % 计算iou
            if iou > 0.8
                Mt = Mt + 1; % 真实信号个数加1
                Fc = real_signal(2); % 实际信号频率值
                Bw = real_signal(4); % 实际信号带宽值
                Ts = real_signal(3) - real_signal(5)/2; % 实际信号开始时间值
                Te = real_signal(3) + real_signal(5)/2; % 实际信号终止时间值
                fc = calculate_signal(2); % 真实信号频率值
                bw = calculate_signal(4); % 真实信号带宽值
                ts = calculate_signal(3) - calculate_signal(5)/2; % 真实信号开始时间值
                te = calculate_signal(3) + calculate_signal(5)/2; % 真实信号开始时间值
                T = real_signal(5); % 实际信号时长值
                Eavg = Eavg + abs(Fc-fc)/Bw + abs(Bw-bw)/Bw + abs(Ts-ts)/T...
                    + abs(Te-te)/T;
            else
                Mf = Mf + 1; % 虚假信号加1
            end
        end
    end
%     disp(['实际信号数量：', num2str(N)])
%     disp(['检测出的信号数量：', num2str(M)])
%     disp(['真实信号数量：', num2str(Mt)])
%     disp(['虚假信号数量：', num2str(Mf)])
    ML = [ML; N, M, Mt, Mf, Eavg]; % 保存参数
end