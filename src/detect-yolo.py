import sys
sys.path.append("./yolov5repo")

from argparse import Namespace
from detect import detect
from utils.utils import check_img_size

import torch


if __name__ == '__main__':

    print('torch %s %s' % (torch.__version__, torch.cuda.get_device_properties(0) if torch.cuda.is_available() else 'CPU'))

    opt = Namespace() # fake command line args that are used by detect.py
    opt.__setattr__("output", "../inference/output")
    opt.__setattr__("source", "../inference/images")
    opt.__setattr__("weights", "yolov5repo/weights/yolov5s.pt")
    opt.__setattr__("half", True)
    opt.__setattr__("view_img", True)
    opt.__setattr__("save_txt", True)
    opt.__setattr__("img_size", 640)
    opt.__setattr__("device", "")
    opt.__setattr__("augment", True)    # augmented inference
    opt.__setattr__("conf_thres", 0.4)          # object confidence threshold
    opt.__setattr__("iou_thres", 0.5)           # IOU threshold for NMS
    opt.__setattr__('fourcc', 'mp4v')           # output video codec (verify ffmpeg support)
    opt.__setattr__('agnostic_nms', True) # class-agnostic NMS
    opt.__setattr__("classes", "")              # filter by class

    opt.img_size = check_img_size(opt.img_size)

    __builtins__.opt = opt # make the command like args available to detect module

    with torch.no_grad():
       detect()

