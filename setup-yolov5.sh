#!/bin/sh

echo "#################################################################"
echo "Installing Python 3.7.7 with pyenv"
# There is a dependency on Numpy==1.17, and that version of Numpy supports up to Python 3.7 (not necessarily 3.8)
pyenv install 3.7.7
pyenv global 3.7.7
python --version

echo "#################################################################"
echo "Creating Python .venv virtual environment"
python -m venv .venv
ln -s ./.venv/bin/activate ./activate
source ./activate

echo "#################################################################"
echo "Cloning YOLOv5 repo"
mkdir -p ./src/yolov5repo
git clone https://github.com/channeladam/yolov5.git ./src/yolov5repo

echo "#################################################################"
echo "Installing Python dependencies"
pip install --upgrade pip
# There is a bug in the dependencies of pycocotools - Cython and numpy need to be installed in a different execution before pycocotools...
pip install Cython
pip install numpy==1.17
pip install -U -r ./src/yolov5repo/requirements.txt

echo "#################################################################"
echo "Downloading YOLOv5 model weights"
pushd ./src/yolov5repo
chmod +x ./weights/download_weights.sh
./weights/download_weights.sh
popd


#echo "#################################################################"
#echo "Downloading COCO2017 dataset"
#./src/yolov5repo/data/get_coco2017.sh

echo "#################################################################"
echo "Downloading ~50MB COCO2017 labels only"
mkdir -p ../data
pushd ../data
filename="coco2017labels.zip"
fileid="1cXZR_ckHki6nddOmcysCuuJFM--T-Q6L"
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}
rm ./cookie
echo "Unzipping"
unzip -q ${filename}  # for coco.zip
popd

echo "#################################################################"
pushd ../data/coco/images
echo "Downloading ~7GB COCO2017 test images"
f="test2017.zip" && curl http://images.cocodataset.org/zips/$f -o $f && unzip -q $f && rm $f  # 7G,  41k images
echo "Downloading ~7GB COCO2017 validation images"
f="val2017.zip" && curl http://images.cocodataset.org/zips/$f -o $f && unzip -q $f && rm $f  # 1G, 5k images
popd

echo "#################################################################"
echo "Creating link to coco data folder - needed for test.py to evaluate validation data results"
ln -s ../data/coco coco

#echo "Downloading original COCO test set JSON annotations"
#pushd ./data/coco
#curl http://images.cocodataset.org/annotations/image_info_test2017.zip -o coco-test2017-annotations.zip
#unzip -q coco-test2017-annotations.zip -d coco
#popd