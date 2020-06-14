#!/bin/sh

# --device "0" for GPU 0, or "cpu"

# Validation set
#python ./yolov5repo/test.py --weights ./yolov5repo/weights/yolov5s.pt --data ./coco-data.yaml --batch-size 32 --task val --device 0 --save-json --verbose

# Test set
python ./yolov5repo/test.py --weights ./yolov5repo/weights/yolov5s.pt --data ./coco-data.yaml --batch-size 32 --task test --device 0 --save-json --verbose

#rmdir -rf ./results
#mkdir -p ./results
#python ./yolov5repo/detect.py --weights ./yolov5repo/weights/yolov5s.pt --source ../data/coco/images/test2017-100 --output ./results --device 0 --save-txt