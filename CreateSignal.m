function [x, f1, f2]= CreateSignal(class, t)
    switch class 
        case 0 %      AM  带宽：2倍的调制信号频率
            [x, f1, f2] = AM(t);
        case 1 %      FM  
            [x, f1, f2] = FM(t);
        case 2 %      2FSK  带宽：|f2 - f1| + 2 * fs fs是码元速率DSB
            [x, f1, f2] = FSK2(t);
        case 3 %      2PSK  带宽= 2 *（△f + fm）= 2*(mf+1)*fm
            [x, f1, f2] = PSK2(t);
        case 4 %      带宽：2倍的调制信号频率
            [x, f1, f2] = DSB(t);
    end

end  