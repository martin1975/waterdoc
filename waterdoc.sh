#!/bin/bash

# CC0 2021 by Martin KOROLCZUK



###
### Parameters
###
WD_FILENAME_INPUT="$1"
WD_RECIPIENT="$2"



###
### Configuration
###
echo Configuring...

WD_FINAL_WIDTH=1024
WD_FINAL_SIZE=200kb

# Using a high quality intermediate image dimension makes it easier to write
# fixed-size watermarks (see below: WD_WATERMARK_SIDES_HEIGHT and
# WD_WATERMARK_CENTER_HEIGHT).
# If you want to change the intermediate dimension, you have to change the
# values of WD_WATERMARK_SIDES_HEIGHT and WD_WATERMARK_CENTER_HEIGHT
# accordingly (see below).
WD_INTERMEDIATE_WIDTH=3072



# Dates
# These dates do not use the system current locale, since it is often set to
# en_US even in other countries. The below format is intended for fr_FR.
WD_DATE_FULL=$( date +"%d/%m/%Y" )
WD_DATE_MONTH=$( date +"%m/%Y" )
WD_DATE_YEAR=$( date +"%Y" )

# Watermarks
# Change the value of WD_WATERMARK_CENTER_TEXT (see below) to your favorite
# language. (The original value is written in French.)
WD_WATERMARK_FONT="Helvetica"

WD_WATERMARK_SIDES_HEIGHT=90000
WD_WATERMARK_SIDES_TEXT=$( printf "${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH}\n${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT}\n${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH}\n${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT} ${WD_DATE_MONTH} ${WD_RECIPIENT}" )

WD_WATERMARK_CENTER_HEIGHT=190000
WD_WATERMARK_CENTER_TEXT="À l'usage\nEXCLUSIF de :\n\n${WD_RECIPIENT}\n\nDuplicata réalisé le :\n${WD_DATE_FULL}"

# Filenames
WD_FILENAME_TMP_FOLDER="/tmp"
WD_FILENAME_TMP_PREFIX="waterdoc_"
WD_FILENAME_TMP_DOCUMENT="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_document.png"
WD_FILENAME_TMP_WATERMARK_1="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_watermark1.png"
WD_FILENAME_TMP_WATERMARK_2="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_watermark2.png"
WD_FILENAME_TMP_OUTPUT_1="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_output1.png"
WD_FILENAME_TMP_OUTPUT_2="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_output2.png"
WD_FILENAME_TMP_OUTPUT_3="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_output3.png"
WD_FILENAME_TMP_OUTPUT_4="${WD_FILENAME_TMP_FOLDER}/${WD_FILENAME_TMP_PREFIX}_output4.jpg"
WD_FILENAME_OUTPUT=$( echo "${WD_FILENAME_INPUT}" | sed "s/\(.*\)\(\\..*\)/\\1-watermark.jpg/g" )


###
### Processing
###
echo Preprocessing...

# Resize to a high quality intermediate size
convert -resize ${WD_INTERMEDIATE_WIDTH} ${WD_FILENAME_INPUT} ${WD_FILENAME_TMP_DOCUMENT}

# Create watermarks
echo Creating watermarks...

echo Creating watermark 1/2...

convert -background transparent -flatten -fill '#ddd' \
    -gravity center -font "{$WD_WATERMARK_FONT}" \
    pango:"<span size=\"${WD_WATERMARK_SIDES_HEIGHT}\"><b>${WD_WATERMARK_SIDES_TEXT}</b></span>" \
    "${WD_FILENAME_TMP_WATERMARK_1}"

echo Creating watermark 2/2...

convert -background transparent -flatten -fill red \
    -gravity center -font "{$WD_WATERMARK_FONT}" \
    pango:"<span size=\"${WD_WATERMARK_CENTER_HEIGHT}\"><b>${WD_WATERMARK_CENTER_TEXT}</b></span>" \
    "${WD_FILENAME_TMP_WATERMARK_2}"


# Compose the final image
echo Composing image...

echo Composing image 1/3...

composite -gravity North \
    -compose multiply \
    "${WD_FILENAME_TMP_WATERMARK_1}" \
    "${WD_FILENAME_TMP_DOCUMENT}" \
    "${WD_FILENAME_TMP_OUTPUT_1}"

echo Composing image 2/3...

composite -gravity South \
    -compose multiply \
    "${WD_FILENAME_TMP_WATERMARK_1}" \
    "${WD_FILENAME_TMP_OUTPUT_1}" \
    "${WD_FILENAME_TMP_OUTPUT_2}"

echo Composing image 3/3...

composite -gravity Center \
    -dissolve 33%x100% \
    "${WD_FILENAME_TMP_WATERMARK_2}" \
    "${WD_FILENAME_TMP_OUTPUT_2}" \
    "${WD_FILENAME_TMP_OUTPUT_3}"


# Resize to final size
echo Resizing...
convert "${WD_FILENAME_TMP_OUTPUT_3}" \
    -resize "${WD_FINAL_WIDTH}" \
    -define jpeg:extent=${WD_FINAL_SIZE} \
    "${WD_FILENAME_TMP_OUTPUT_4}"



###
### Cleaning
###
echo Cleaning...

rm "${WD_FILENAME_TMP_DOCUMENT}"
rm "${WD_FILENAME_TMP_WATERMARK_1}"
rm "${WD_FILENAME_TMP_WATERMARK_2}"
rm "${WD_FILENAME_TMP_OUTPUT_1}"
rm "${WD_FILENAME_TMP_OUTPUT_2}"
rm "${WD_FILENAME_TMP_OUTPUT_3}"
mv "${WD_FILENAME_TMP_OUTPUT_4}" "${WD_FILENAME_OUTPUT}"

###
### End
###
echo Image \"${WD_FILENAME_OUTPUT}\" ready with watermark.
