#!/bin/bash

# tool 사용 방법
# 1) virtualbox에 리눅스 설치하고, 공유 폴더를 설정 한다.
# 2) 리눅스에 exiftool을 설치 한다. sudo apt-get install exiftool
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

#rm *.jpg -f
#rm *.JPG -f
#cp ./org/* .
#rm -f new/*

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

#######################

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

apply_new_name() {
	local filename=$1
	local new_dir=$2
	local author=$3
	local sec=$4
	local usec=$5

	# 20160903_0520_hyojin_36_0000.jpg
	# 20160903_0819_jiho_22_0000.jpg
	msg="$(${exif_cmd} '-filename<CreateDate' -d %Y%m%d_%H%M_${author}_${sec}_${usec}%%+c.%%le -v -o ./$new_dir $filename)"

	echo "$msg"

	set_modify_time "$msg"
}

rename_pic() {
	local cur_dir=$1
	local new_dir="$1_new"

	# 복사할 대상 디렉토리를 만든다.
	if [ ! -d $new_dir ]; then
		mkdir -p $new_dir
	else
		rm -f $new_dir/*
	fi

	local files=`cd $cur_dir; ls ./*.[jJ]* 2>/dev/null`
	local fcnt=$(cd $cur_dir; ls ./*.[Jj]* 2>/dev/null | wc -l)
	local i
	local cnt=1

	for i in $files
	do
		local f=$(basename $i)
		local ofile="$cur_dir/$f"
		local usec
		local sec

		sec=$(${exif_cmd} -t -s2 -EXIF:CreateDate -d %S $ofile)
		usec=$(${exif_cmd} -t  -n -s2 -EXIF:SubSecTime $ofile)
		usec=$(expr $usec + 0)
		usec=$(printf "%04d" $usec)

		echo -n  "== $cnt/$fcnt =="

		# 새로운 파일 이름으로 복사 한다.
		# 촬영 시간별로 정렬 되고, 중복 되면 촬영자 이름으로 정렬 됨
		# yyyymmdd_hhmm_name_sec_usec.jpg
		# 20150503_1434_jiho_11_0050
		apply_new_name $ofile $new_dir $cur_dir $sec $usec

		let "cnt ++"
	done
}

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

		usec=$(${exif_cmd} -t  -n -s2 -EXIF:SubSecTime ${f})
		if [ -z $usec ]; then
			echo "No usec: ${f}"
		fi
	done
}

# subsec을 설정 한다.
set_subsectime() {
	local cur_dir=$1

	local files=`cd $cur_dir; ls ./*\(0\).[jJ]*`
	local i

	for i in $files
	do
		local f=$(basename $i)
		local ofile="$cur_dir/$f"

		${exif_cmd} -SubSecTime=123 -overwrite_original -v $ofile
	done
}

find_next_usec() {
	local cur_dir=$1
	local file_prefix=$2

	local myusec=0
	while :
	do
		local usec_str=$(printf "%04d" $myusec)
		local fname=${file_prefix}_${usec_str}.jpg

		if [ -e ${cur_dir}/$fname ]; then 
			myusec=$(expr $myusec + 1)
		else
			echo ${myusec}
			return
		fi
	done
}

rename_pic_without_usec() {
	local cur_dir=$1
	local new_dir="$1_new"

	if [ ! -d $new_dir ]; then
		mkdir -p $new_dir
	else
		rm -f $new_dir/*
	fi

	local files=`cd $cur_dir; ls ./*.[jJ]*`
	local i

	for i in $files
	do
		local usec
		local f=$(basename $i)
		local ofile="$cur_dir/$f"
		local cdate=$(${exif_cmd} -t -s2 -EXIF:CreateDate -d %Y%m%d_%H%M%S $ofile)

		usec=$(find_next_usec $new_dir $cdate)
		usec=$(printf "%04d" $usec)

		sec=$(${exif_cmd} -t -s2 -EXIF:CreateDate -d %S $ofile)

		apply_new_name $ofile $new_dir $cur_dir $sec $usec
	done
}

rename_create_date() {
	local pic_dirs="$@"

	# 각 디렉토리의 이미지를 새로운 디렉토리로 이름을 변경하여 복사한다.
	# 이름은 촬영된 시간을 기준으로 한다.
	for d in $pic_dirs
	do
		rename_pic $d
	done
}

apply_author() {
	local cur_dir=$1
	local auth=$2

	cd $cur_dir

	local files=`ls ./*.[jJ]*`
	local i

	for i in $files
	do
		local filename=$(basename $i)
		filename=${filename%%.*}
		newname="${filename}_${auth}.jpg"

		mv $i $newname
	done
}

remove_word() {
	local cur_dir=$1
	local word=$2

	cd $cur_dir

	local files=`ls ./*.[jJ]*`
	local i

	for i in $files
	do
		local filename=$(basename $i)
		orgfile=$filename
		filename=${filename%%.*}
		filename=${filename//$word/}
		newname="${filename}.jpg"

		if [ "$orgfile" != "$newname" ]; then
			mv $i $newname
		fi
	done
}

# 이미지의 생성 시간, 마지막 편집 시간을 수정 한다.
adjust_modify_time()
{
	local filename=$1
	#local adj_time="0:0:0 0:0:3"
	# 15 시간 이동
	local adj_time="0:0:0 15:0:0"

	${exif_cmd} "-FileModifyDate-=$adj_time" "-AllDates-=$adj_time" -overwrite_original  $filename
	#${exif_cmd} "-AllDates-=$adj_time" -overwrite_original  $filename
	#${exif_cmd} "-AllDates-=$adj_time"  -overwrite_original $filename
	#${exif_cmd} "-FileModifyDate<EXIF:DateTimeOriginal" -overwrite_original $filename
}

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

#	1: skip
#	2: skip
#	3: 180
#	4: 180, 셀카
#	5: 90, 셀카
#	6: 90
#	7: 270
#	8: 270

adjust_orient() {
	local cur_dir=$1
	local files=`cd $cur_dir; ls ./*.[jJ]* 2>/dev/null`
	local fcnt=$(cd $cur_dir; ls ./*.[Jj]* 2>/dev/null | wc -l)
	local i
	local cnt=1
	local f

	for i in $files; do
		f=${cur_dir}/$i

		ori=$(show_orient $f)
		case "$ori" in
		3|4)
			rotate=180
			;;
		5|6)
			rotate=90
			;;
		7|8)
			rotate=270
			;;
		*)
			echo "Image Orientation: $f, $ori, skip"
			continue
			;;
		esac

		echo "Modify and reset orientation: $f, $rotate"

		#mogrify -path ./${new_dir}/ -rotate $rotate $f
		mogrify -rotate $rotate $f
		${exif_cmd} -Orientation=1 -n -overwrite_original ./$f
	done
}


########################################
#### main

# 이미지 시간 조정
#adjust_modify_time "tmp_new/1.jpg"
#adjust_modify_time "a6000/DSC030*"
#adjust_modify_time "a6000/DSC031*"
#adjust_modify_time "a6000/DSC032*"
#adjust_modify_time "a6000/DSC0330*"
#adjust_modify_time "a6000/DSC0331*"
#adjust_modify_time "a6000/DSC0332*"
#adjust_modify_time "a6000/DSC03330*"

#check_subsec junho

# 김효진폰은 subsec이 없어서 강제로 설정 한다.
#set_subsectime hyojin
#set_subsectime a6000
#rename_pic_without_usec a6000
#rename_pic_without_usec jiho_mp4
#rename_pic_without_usec junho


#apply_author "d7000_new" "d7000"
#remove_word "d7000_new" "_d700"

# 이미지 파일 이름을 촬영날짜로 변경하여 새로운 디렉토리에 복사한다.
#rename_create_date d7000 jiho jihyun
#rename_create_date d7000 jihyun
#rename_create_date jiho


# 핸드폰 사진 회전이 안 맞을때..
adjust_orient ./202310_newyork
