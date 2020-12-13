#!/bin/sh

TMP_PATH=./tmp
BG_PATH=./backgrounds
PATTERN_PATH=./patterns
SHAPE_MASK=./shape_mask.png
MAGICK_COMMAND=magick

[[ -e $TMP_PATH ]] && rm -rf $TMP_PATH
mkdir $TMP_PATH

# # Create pattern from secondary color and pattern mask
# convert background_2b2d42.png mask_spilled_paint.png -alpha off -compose CopyOpacity -composite -format png $TMP_PATH/asd.png
# # Add the primary color
# convert background_d90429.png $TMP_PATH/asd.png -gravity center -composite -format png $TMP_PATH/asd2.png
# # Mask the pattern with the egg shape to create the final image
# convert $TMP_PATH/asd2.png shape_mask.png -alpha off -compose CopyOpacity -composite -format png $TMP_PATH/asd3.png

for secondary in $(ls $BG_PATH); do
    for pattern in $(ls $PATTERN_PATH); do

        for primary in $(ls $BG_PATH); do
            [[ $primary == $secondary ]] && continue
            primary_rgb=$(echo $primary | cut -d '.' -f 1 | cut -d '_' -f 2)
            secondary_rgb=$(echo $secondary | cut -d '.' -f 1 | cut -d '_' -f 2)
            pattern_name=$(echo $pattern | cut -d '.' -f 1 | cut -d '_' -f 2)

            output_file=../${primary_rgb}_${secondary_rgb}_${pattern_name}.png

            $MAGICK_COMMAND $BG_PATH/$secondary $PATTERN_PATH/$pattern -alpha off -compose CopyOpacity -composite -format png $output_file
            $MAGICK_COMMAND $BG_PATH/$primary $output_file -gravity center -composite -format png $output_file
            $MAGICK_COMMAND $output_file $SHAPE_MASK -alpha off -compose CopyOpacity -composite -format png $output_file
        done
    done
done
