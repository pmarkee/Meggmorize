#!/bin/sh

BG_PATH=./backgrounds
PATTERN_PATH=./patterns
SHAPE_MASK=./shape_mask.png
MAGICK_COMMAND=magick
COLOR_FILE=./colors

# First create the backgrounds
while IFS= read -r line; do
    rgb=$(echo $line | tr -d '#')
    $MAGICK_COMMAND -size 500x500 xc:${line} $BG_PATH/background_${rgb}.png
done < colors

for secondary in $(ls $BG_PATH); do
    for pattern in $(ls $PATTERN_PATH); do

        for primary in $(ls $BG_PATH); do
            [[ $primary == $secondary ]] && continue
            primary_rgb=$(echo $primary | cut -d '.' -f 1 | cut -d '_' -f 2)
            secondary_rgb=$(echo $secondary | cut -d '.' -f 1 | cut -d '_' -f 2)
            pattern_name=$(echo $pattern | cut -d '.' -f 1 | cut -d '_' -f 2)

            output_file=../${primary_rgb}_${secondary_rgb}_${pattern_name}.png
            echo $output_file

            $MAGICK_COMMAND $BG_PATH/$secondary $PATTERN_PATH/$pattern -alpha off -compose CopyOpacity -composite -format png $output_file
            $MAGICK_COMMAND $BG_PATH/$primary $output_file -gravity center -composite -format png $output_file
            $MAGICK_COMMAND $output_file $SHAPE_MASK -alpha off -compose CopyOpacity -composite -format png $output_file
        done
    done
done
