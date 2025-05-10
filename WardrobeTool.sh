#!/bin/bash
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
shirts=()
pants=()
# Makes an array of arrays with three values, each sub-array storing the rgb value of a respective shirt or pair of pants
while IFS= read -r line; do
        fields=($line)
        if [ ${fields[0]} = "shirt" ]; then
                shirts+=( "${fields[1]} ${fields[2]} ${fields[3]}" )
        else
                pants+=( "${fields[1]} ${fields[2]} ${fields[3]}" )
        fi
done < "$input"
maxDistance=441.67
echo "MATCHES %:"
# Finds euclidean distance for each combination between shirts and pants in clothes.txt
for item in "${shirts[@]}"; do
        for item2 in "${pants[@]}"; do
                #calculate euclidean distance
                fields1=($item)
                fields2=($item2)
                x1="${fields1[0]}"
                y1="${fields1[1]}"
                z1="${fields1[2]}"
                x2="${fields2[0]}"
                y2="${fields2[1]}"
                z2="${fields2[2]}"
                dx=$((x1 - x2))
                dy=$((y1 - y2))
                dz=$((z1 - z2))
                dx2=$((dx * dx))
                dy2=$((dy * dy))
                dz2=$((dz * dz))
                sum=$((dx2 + dy2 + dz2))
                distance=$(awk "BEGIN {printf \"%.2f\", sqrt($sum)}")
                percent=$(awk "BEGIN {printf \"%.2f\", ($distance / $maxDistance) * 100}")
                echo "Shirt $item and pants $item2 Match: $percent%"
        done
done
