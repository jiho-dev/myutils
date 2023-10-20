#!/bin/bash

# tool 사용 방법
# 1) virtualbox에 리눅스 설치하고, 공유 폴더를 설정 한다.
# 2) 툴 설치
#  exiftool: 
#  imagemagick
# 3) 공유 폴더 하위에 이미지 폴더 이 스크립트 복사
: '
#  예) 
# [jjh@devme ~/img]$ tree
# ├── pic_rename.sh
# ├── tmp
# │   ├── 20150508_201552.jpg
# │   ├── DSC_1427.JPG
# │   ├── DSC_1428.JPG
# │   ├── DSC_1429.JPG
# │   ├── DSC_1430.JPG
# │   └── DSC_1441.JPG
'

exif_cmd=/home/jiho.jung/img/exiftool

#${exif_cmd} '-filename<CreateDate' -d %y%m%d_%H%M%S%%-c.%%le -r -ext cr2 -ext mrw /media/ingest/test
#${exif_cmd} '-filename<CreateDate' -d %Y%m%d_%H%M%S%%-c.%%le -ext jpg . 

#${exif_cmd} -v '-filename<CreateDate' -d %Y%m%d_%H%M%S%%+c.%%le -ext jpg . 

#${exif_cmd} -v -ext jpg "-filename<${datetimeoriginal}${SubSecCreateDate}0.%e" -d %Y%m%d_%H%M%S  .

#${exif_cmd} 20150513_194948.jpg -EXIF:SubSecTime
#${exif_cmd} -ext jpg -t  -n -s2 -EXIF:SubSecTime ./DSC_3034_2.JPG
#${exif_cmd} -t  -n -s2 -EXIF:SubSecTime ./1441061910693.jpg
#${exif_cmd} "-DateTimeOriginal-=0:0:0 1:0:0"
#${exif_cmd} "-filemodifydate<${datetimeoriginal;s/(\d{4}):00:00/$1:01:01/}"
#${exif_cmd} -AllDates+=1:30 -if '$make eq "Canon"' dir
#${exif_cmd} -modifydate+=3 a.jpg b.jpg
# exiftool "-Filename<${datetimeoriginal}00%+3c.%le"" "-Filename<${datetimeoriginal}${SubSecTimeOriginal}%+3c.%le" ...

#######################

# subdir에 있는 파일의 subsectime이 있는지 검사 한다.
# 없는 파일은 화면에 표시한다.
check_subsec() {
	local cur_dir=$1
	local files=`cd $cur_dir; ls ./*.[jJ]*`
	local i

	for i in $files
	do
		local f=${cur_dir}/$(basename $i)
		local usec

		usec=$(${exif_cmd} -t  -n -s2 -EXIF:SubSecTimeOriginal ${f})
		if [ -z $usec ]; then
			echo "No usec: ${f}"
		fi
	done
}

# subsec을 설정 한다.
set_subsectime() {
	local cur_dir=$1

	#local files=`cd $cur_dir; ls ./*\(0\).[jJ]*`
	local files=`cd $cur_dir; ls ./*.[jJ]*`
	local i

	for i in $files
	do
		local f=$(basename $i)
		local ofile="$cur_dir/$f"

		local usec=$(${exif_cmd} -t  -n -s2 -EXIF:SubSecTimeOriginal ${ofile})
		if [ -z $usec ]; then
			${exif_cmd} -SubSecTimeOriginal=000 -overwrite_original -v $ofile
		fi
	done
}

# 마지막 수정시간을 촬영 시간으로 맞춘다.
set_modify_time() {
	local msg=$1
	local f=$(echo "$msg" | awk 'NR==3' | awk '{print $3}')
	local filename=${f//\'/} # remove ' mark in the string

	if [ -e $filename ]; then
		${exif_cmd} '-filemodifydate<DateTimeOriginal' -d %Y%m%d_%H%M%S $filename
	else
		echo "no file: $filename"
	fi
}

# 이미지의 생성 시간, 마지막 편집 시간을 수정 한다.
adjust_modify_time()
{
	local filename=$1
	#local adj_time="0:0:0 0:0:3"
	# 15 시간 이동
	local adj_time="0:0:0 15:0:0"

	${exif_cmd} "-FileModifyDate-=$adj_time" "-AllDates-=$adj_time" -overwrite_original  $filename
}

# 이미지의 회전 방향을 출력
show_orient() {
	#${exif_cmd}  -p '$Filename $orientation' -n ./*.JPG
	${exif_cmd}  -p '$orientation' -n $1
}

collect_orient() {
	out_fname=orient_junho.txt
	out_fname1=orient_junho_sort.txt
	${exif_cmd}  -p '$Filename $orientation' -n ./junho/*.JPG > ./$out_fname
	sort -k2 $out_fname  | uniq -c -f 1 > ${out_fname1}
}

# 이미지의 회전 방향을 자동으로 조정한다.
adjust_orient() {
#	From exiftool documentation
#	https://sirv.com/help/articles/rotate-photos-to-be-upright/
#
#	1 = Horizontal (normal)
#	2 = Mirror horizontal
#	3 = Rotate 180
#	4 = Mirror vertical
#	5 = Mirror horizontal and rotate 270 CW
#	6 = Rotate 90 CW
#	7 = Mirror horizontal and rotate 90 CW
#	8 = Rotate 270 CW
	 mogrify -verbose -auto-orient $1
}

# author을 설정 한다.
set_author() {
	local dir_name=$1
	local author=$2

	echo "Set Author: $dir_name, $author"
	#$${exif_cmd} -overwrite_original -author=$author $dir_name/*.[Jj]*
	${exif_cmd} -overwrite_original -author=$author $dir_name
}

show_author() {
	local dir_name=$1

	echo "Show Author: $dir_name"
	#${exif_cmd} -p '$filename $author' $dir_name/*.[Jj]*
	${exif_cmd} -p '$filename $author' $dir_name
}

# 촬영시간, author을 사용해서 파일명 변경해서 _new 디렉토리에 복사한다.
rename_image_file() {
	local cur_dir=$1
	local new_dir="$1_new"

	if [ ! -d $new_dir ]; then
		mkdir -p $new_dir
	else
		rm -f $new_dir/*
	fi

	# https://exiftool.org/forum/index.php?topic=7336.0
	# You can assign multiple values to any tag on the command line.  
	# The last valid assignment takes precedence.  So the command looks something like this:
	# SubSecTimeOriginal 없는 경우 000으로 채운다.
	${exif_cmd} -d %Y%m%d-%H%M \
		'-filename<$createdate-$author-${createdate#;DateFmt("%S")}-000%+c.%le' \
		'-filename<$createdate-$author-${createdate#;DateFmt("%S")}-$SubSecTimeOriginal%+c.%le' \
		-v -o $new_dir $cur_dir
}

#############################
# 사진 수정 단계

# 핸드폰 사진의 방향을 수정 한다.
#adjust_orient ./tmp

# 개별 디렉토리의 이미지 시간 조정
#adjust_modify_time "a6000/DSC030*"

# author
#set_author ./jiho jiho
#set_author ./a6000 a6000
#show_author ./a6000 a6000
#set_author ./junho junho

# 촬영시간, author을 사용해서 파일명 변경해서 _new 디렉토리에 복사한다.
#rename_image_file ./junho


