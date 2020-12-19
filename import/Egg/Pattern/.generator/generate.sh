#!/bin/sh

PRIMARY_PATH=./primary
SECONDARY_PATH=./secondary
PATTERN_PATH=./patterns
SHAPE_MASK=./shape_mask.png
MAGICK_COMMAND=magick
COLOR_FILE=./colors

for secondary in $(ls $SECONDARY_PATH); do
    for pattern in $(ls $PATTERN_PATH); do

        for primary in $(ls $PRIMARY_PATH); do
            primary_rgb=$(echo $primary | cut -d '.' -f 1 | cut -d '_' -f 2)
            secondary_rgb=$(echo $secondary | cut -d '.' -f 1 | cut -d '_' -f 2)
            pattern_name=$(echo $pattern | cut -d '.' -f 1 | cut -d '_' -f 2)

            output_file=../${primary_rgb}_${secondary_rgb}_${pattern_name}.png
            echo $output_file

            $MAGICK_COMMAND $SECONDARY_PATH/$secondary $PATTERN_PATH/$pattern -alpha off -compose CopyOpacity -composite -format png $output_file
            $MAGICK_COMMAND $PRIMARY_PATH/$primary $output_file -gravity center -composite -format png $output_file
            $MAGICK_COMMAND $output_file $SHAPE_MASK -alpha off -compose CopyOpacity -composite -format png $output_file
        done
    done
done
