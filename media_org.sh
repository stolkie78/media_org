#/bin/bash
# Exiftool Image en Video renamer

ET=/bin/exiftool
#IMGDEST="/volume1/photo/Library" 
#VIDDEST="/volume1/video/HomeVideos" 
IMGDEST="/volume1/scripts/media_org/photo" 
VIDDEST="/volume1/scripts/media_org/movie" 

function help {
	echo "HEEELP" 
	exit 1
}

function move_images { 
	echo "- Location: ${MEDIASOURCE}" 
	echo "- Processing Images - Pass 1: CreateDate" 
	${ET} -r -d ${IMGDEST}/%Y/%Y%m%d/Image-%Y%m%d%H%M%S%%-c.%%e "-filename<CreateDate" -ext JPG "${MEDIASOURCE}"
	echo "- Processing Images - Pass 2: FileModifyDate"
	${ET} -r -d ${IMGDEST}/%Y/%Y%m%d/Image-%Y%m%d%H%M%S%%-c.%%e "-filename<FileModifyDate" -ext JPG "${MEDIASOURCE}"
}

function move_movies { 
	echo "- Location: ${MEDIASOURCE}" 
	echo "- Processing Video"
	${ET} -r -d ${VIDDEST}/Video-%Y%m%d%H%M%S%%-c.%%e "-filename<CreateDate" -ext MP4 "${MEDIASOURCE}" 
}

function fix_perm {
	echo "- Fixing permissions" 
	chown -R giedo:stolkdata "${IMGDEST}" 
	chown -R giedo:stolkdata "${VIDDEST}" 
	chmod -R 777 "${IMGDEST}" 
	chmod -R 777 "${VIDDEST}"
}

function remove_ea {
	find "${MEDIASOURCE}" -name "@eaDir"  -type d -exec rm -rf {} \; 
}


while getopts d: OPT
	do
		case "${OPT}" in
			d) MEDIASOURCE="${OPTARG}"
			;;
			*) help
			;;
		esac
	done

test -z "${MEDIASOURCE}" && help

remove_ea
move_images
move_movies

