function ML = PdPfEavg(real_path, calculate_path)
    %% ������ʼ��
    N = 0; % ʵ���ź�����
    M = 0; % �������źŸ���
    Mt = 0; % M����ʵ�źŸ���������⵽���ź���������źŵĸ���
    Mf = 0; % M����ٵ��źŸ������������źŸ���
    Pd = 0; % ������ Pd = Mt/N
    Pf = 0; % �龯���� Pf = Mf/M
    Eavg = 0; % ��Ϣ����ƽ�����
    ML = []; % �������ո���db�¼��ָ������ľ��� 
    %% ��������ָ��
     % ��ȡһ��ʵ���ı��е�����label��Ϣ
    real_data = load(real_path);
    n = length(real_data(:,1)); % һ��ͼ��ʵ���źŵĸ���
    N = N + n; % �ܹ���ʵ���ź����� = ��ͣ�ÿ��ͼ��ʵ���źŵĸ�����
    calculate_data = load(calculate_path);
    m = length(calculate_data(:,1)); % һ��ͼ�м������źŵĸ���
    M = M + m; % �ܹ��������ź����� = ��ͣ�ÿ��ͼ�м������ź�������
    for ii = 1:m % ����һ��Ԥ��label�ļ��е������ź�
        calculate_signal = calculate_data(ii, :); % һ��Ԥ���ź�
        delect_class = calculate_signal(1); % �õ�Ԥ���źŵ����
         % �ҳ��ļ���һ����ʵ���ź�label�ļ�����calculate_signal��ͬ�����źŵ������к�
        x = find(real_data(:, 1) == delect_class);
        if isempty(x) % ������ʵ���ź��в����ڵ��ź�ʱ
            Mf = Mf + 1; % ����źż�1
        else
            d = []; % ˢ������d�ĳ���
            for iii = 1:length(x) % ���������ҵ�����calculate_signal�����ͬ��ʵ���ź�
                % �������ź����ĵ��ŷ�Ͼ������Сֵ���ҵ���calculate_signalƥ���ʵ���ź�
                x_c = calculate_signal(2); y_c = calculate_signal(3); % calculate_signal��������(x_c,y_c)
                x_r = real_data(x(iii), 2); y_r = real_data(x(iii), 3); % ʵ���ź���������(x_r,y_r)
                d(iii) = (x_c - x_r)^2 + (y_c - y_r)^2;   % ����������ƽ��
            end
            [mmin, note] = min(d); % �õ���Сֵ���ڵ�d���������к�note
            signal_note = x(note); % �õ���Сֵ����Ӧ��ʵ���źŵ��ھ���real_data�е������к�signal_note
            real_signal = real_data(signal_note, :); % �õ���calculate_signalƥ���ʵ���ź�
            cbox = calculate_signal(2: 5); % calculate_signal��box [x, y, w, h]
            rbox = real_signal(2: 5); % real_signal��box [x, y, w, h]
            iou = Box_IOU(cbox, rbox); % ����iou
            if iou > 0.8
                Mt = Mt + 1; % ��ʵ�źŸ�����1
                Fc = real_signal(2); % ʵ���ź�Ƶ��ֵ
                Bw = real_signal(4); % ʵ���źŴ���ֵ
                Ts = real_signal(3) - real_signal(5)/2; % ʵ���źſ�ʼʱ��ֵ
                Te = real_signal(3) + real_signal(5)/2; % ʵ���ź���ֹʱ��ֵ
                fc = calculate_signal(2); % ��ʵ�ź�Ƶ��ֵ
                bw = calculate_signal(4); % ��ʵ�źŴ���ֵ
                ts = calculate_signal(3) - calculate_signal(5)/2; % ��ʵ�źſ�ʼʱ��ֵ
                te = calculate_signal(3) + calculate_signal(5)/2; % ��ʵ�źſ�ʼʱ��ֵ
                T = real_signal(5); % ʵ���ź�ʱ��ֵ
                Eavg = Eavg + abs(Fc-fc)/Bw + abs(Bw-bw)/Bw + abs(Ts-ts)/T...
                    + abs(Te-te)/T;
            else
                Mf = Mf + 1; % ����źż�1
            end
        end
    end
%     disp(['ʵ���ź�������', num2str(N)])
%     disp(['�������ź�������', num2str(M)])
%     disp(['��ʵ�ź�������', num2str(Mt)])
%     disp(['����ź�������', num2str(Mf)])
    ML = [ML; N, M, Mt, Mf, Eavg]; % �������
end