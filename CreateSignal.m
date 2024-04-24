function [x, f1, f2]= CreateSignal(class, t)
    switch class 
        case 0 %      AM  ����2���ĵ����ź�Ƶ��
            [x, f1, f2] = AM(t);
        case 1 %      FM  
            [x, f1, f2] = FM(t);
        case 2 %      2FSK  ����|f2 - f1| + 2 * fs fs����Ԫ����DSB
            [x, f1, f2] = FSK2(t);
        case 3 %      2PSK  ����= 2 *����f + fm��= 2*(mf+1)*fm
            [x, f1, f2] = PSK2(t);
        case 4 %      ����2���ĵ����ź�Ƶ��
            [x, f1, f2] = DSB(t);
    end

end  