function iou = Box_IOU(box1, box2)
    % box1��box2 ��ʽΪ  xywh
    % box1���Ͻ�����(b1_x1,b1_y1)
    b1_x1 = box1(1) - box1(3) / 2;
    b1_y1 = box1(2) - box1(4) / 2;
    % box1���½�����(b1_x2,b1_y2)
    b1_x2 = box1(1) + box1(3) / 2;
    b1_y2 = box1(2) + box1(4) / 2;
    % box2���Ͻ�����(b2_x1,b2_y1)
    b2_x1 = box2(1) - box2(3) / 2;
    b2_y1 = box2(2) - box2(4) / 2;
    % box2���½�����(b2_x2,b2_y2)
    b2_x2 = box2(1) + box2(3) / 2;
    b2_y2 = box2(2) + box2(4) / 2;
    % box1��box2���ཻ���
    inter = (min(b1_x2, b2_x2) - max(b1_x1, b2_x1)) *... % �õ��ཻ���ֵĿ�
            (min(b1_y2, b2_y2) - max(b1_y1, b2_y1)); % �õ��ཻ���ֵĸ�
    % box1��box2�Ĳ����
    w1 = b1_x2 - b1_x1;
    h1 = b1_y2 - b1_y1;
    w2 = b2_x2 - b2_x1; 
    h2 = b2_y2 - b2_y1;
    union = w1 * h1 + w2 * h2 - inter;
    iou = inter / union;
end