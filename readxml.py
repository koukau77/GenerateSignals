import os
import sys
import xml.etree.ElementTree as ET
import glob

xml_path = r'E:\faster-rcnn-pytorch-master\VOCdevkit\VOC2007\Annotations'
save_path = r'F:\results'
for xml in os.listdir(xml_path):
    print(xml[:-4])
    f_w = open(os.path.join(save_path, xml[:-4] + '.txt'), 'a')
    # actual parsing
    in_file = open(os.path.join(r'E:\faster-rcnn-pytorch-master\VOCdevkit\VOC2007\Annotations', xml))
    tree = ET.parse(in_file)
    root = tree.getroot()

    for obj in root.iter('object'):
        current = list()
        name = obj.find('name').text

        xmlbox = obj.find('bndbox')
        xmin = xmlbox.find('xmin').text
        ymin = xmlbox.find('ymin').text
        xmax = xmlbox.find('xmax').text
        ymax = xmlbox.find('ymax').text

        # 根据x，y的最大最小值，计算其所在的矩形框的大小 长 宽


        # print xn 输出矩形框的左上角的坐标，及矩形框的长、宽
        f_w.write(xmin + ' ' + ymin + ' ' + xmax + ' ' + ymax + ' \n')
        # f_w.write(name.encode("utf-8")+'\n')