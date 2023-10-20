#!/bin/bash
#set -x

conv_avchd_mp4() {
    # Converts MTS files to MP4 and retains date metadata.

    author="a6000"
    mts=$*

    for srcfile  in $mts; do
        c_time=$(./exiftool -T -DateTimeOriginal -d "%Y%m%d %H:%M:%S%z" $srcfile)
        ffmpegcreatetime=$(date -d "$c_time"  +"%FT%T")
        # 20231004-1120-jiho-42-612.mp4
        filecreatetime=$(date -d "$c_time" +"%Y%m%d-%H%M-$author-%S-000")

        #echo "$c_time, $ffmpegcreatetime, $filecreatetime"

        echo "conv $srcfile -> ${filecreatetime}.mp4"
        ffmpeg -y -hide_banner -loglevel error -i $srcfile -c copy -metadata creation_time=${ffmpegcreatetime}Z ${filecreatetime}.mp4

    done
}

conv_avchd_mp4 AVCHD/BDMV/STREAM/*.MTS
#conv_avchd_mp4 AVCHD/BDMV/STREAM/00007.MTS
