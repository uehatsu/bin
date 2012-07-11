#!/bin/bash

if [ -z "$1" -a -z "$2" ]; then
    echo "Error: prease input two argument. image_size_convert.sh <folder_path> <image max size>";
    exit;
fi

IMAGE_PATH=$1;
IMAGE_SIZE=$2;
OUTPUT_PATH="${IMAGE_PATH}/../output/";

if [ ! -d $1 ]; then
    echo "Error: your seting folder_path is not found.";
    exit;
fi

if [ ! -d ${OUTPUT_PATH} ]; then
    mkdir -p ${OUTPUT_PATH};
fi

echo "Folder pathe   : " ${IMAGE_PATH};
echo "Image Max Size : " ${IMAGE_SIZE};
echo "Output path    : " ${OUTPUT_PATH};

for FILE in `find ${IMAGE_PATH} -name *.jpg`
do
    WIDTH=`identify -format "%w" ${FILE}`;
    HEIGHT=`identify -format "%h" ${FILE}`;
    BASENAME=`basename ${FILE}`;
    THMB=`echo ${BASENAME} | sed 's/_main/_thmb/'`;
    if [ ${WIDTH} -lt ${HEIGHT} ]; then
        echo "H : " ${WIDTH} " x " ${HEIGHT};
        convert -define jpeg:size=${WIDTH}x${HEIGHT} -resize x${IMAGE_SIZE} -unsharp 2x1.4+0.5+0 -quality 100 -verbose ${FILE} ${OUTPUT_PATH}/${BASENAME};
        if [[ "${BASENAME}" =~ main.jpg$ ]]; then
            convert -define jpeg:size=${WIDTH}x${HEIGHT} -resize x109 -unsharp 2x1.4+0.5+0 -quality 100 -verbose ${FILE} ${OUTPUT_PATH}/${THMB};
        fi
    else
        echo "W : " ${WIDTH} " x " ${HEIGHT};
        convert -define jpeg:size=${WIDTH}x${HEIGHT} -resize ${IMAGE_SIZE}x -unsharp 2x1.4+0.5+0 -quality 100 -verbose ${FILE} ${OUTPUT_PATH}/${BASENAME};
        if [[ "${BASENAME}" =~ main.jpg$ ]]; then
            convert -define jpeg:size=${WIDTH}x${HEIGHT} -resize 109x -unsharp 2x1.4+0.5+0 -quality 100 -verbose ${FILE} ${OUTPUT_PATH}/${THMB};
        fi
    fi
done
