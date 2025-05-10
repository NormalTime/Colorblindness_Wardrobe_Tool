# Colorblindness Wardrobe Tool Summary Report 

## Abstract
 <!-- a one paragraph "abstract" type overview of what your project consists of.  This should be written for a general programmer audience, something that anyone who has taken up to 211 could understand. Style-wise it should be a scientific abstract. -->
My project consists of finding how close colors match in the context of clothing options. Colorblindness causes a lack of being able to perceive red, green, and blue light. Thus, this project seeked to find some objectivity with how color can be observed and assist people who have colorblindness with fashion choices. This was done by finding the euclidean distance between sets of rgb values of a list of shirts and pants.

## Reflection
 <!-- a one paragraph reflection that summarizes challenges faced and what you learned doing your project, the audience here is your instructors -->
At first, I thought the euclidean distance method would be a surefire way to find matches between colors. However, I mistakenly thought too highly of this method in the sense that there really isn't much of a point in matching colors when a colorblind person wouldn't see colors that aren't very different in terms of rgb values as being much different from each other. In other words, a colorblind person is probably capable of finding matches of clothes on their own outside of extreme cases. The euclidean distance also isn't a good measure for fashion. Color combinations such as black pants and a white shirt have a 0% match or the maximum euclidean distance despite this being clothing options a person would actually wear. During this project, I learned a bit about how math works in bash. It took some effort finding commands to solve for the euclidean distance and turning that into a percentage as variables in bash are a bit different from what I'm used to in languages like python and C++. It also gave me some exposure for the considerations necessary when making tools for people with colorblindness. 

## Artifacts 

<!-- links to other materials required for assessing the project.  This can be a public facing web resource, a private repository, or a shared file on URI google Drive.  -->
- Example clothes.txt input
```
shirt 255 255 255
pants 255 255 255
shirt 0 0 0
pants 0 0 0
pants 93 173 236
shirt 135 206 235
```

- Wardrobe script (takes in clothes.txt)
```
#!/bin/bash

[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"


shirts=()
pants=()

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
                percent=$(awk "BEGIN {printf \"%.2f\", 100 - (($distance / $maxDistance) * 100)}")
                echo "Shirt $item and pants $item2 Match: $percent%"

        done
done
```

- Example output using clothes.txt
```
MATCHES %:
Shirt 255 255 255 and pants 255 255 255 Match: 100.00%
Shirt 255 255 255 and pants 0 0 0 Match: 0.00%
Shirt 255 255 255 and pants 93 173 236 Match: 58.67%
Shirt 0 0 0 and pants 255 255 255 Match: 0.00%
Shirt 0 0 0 and pants 0 0 0 Match: 100.00%
Shirt 0 0 0 and pants 93 173 236 Match: 30.48%
Shirt 135 206 235 and pants 255 255 255 Match: 70.31%
Shirt 135 206 235 and pants 0 0 0 Match: 22.92%
Shirt 135 206 235 and pants 93 173 236 Match: 87.90%

```

# How to use the wardrobe tool

## Making a clothes file
- Any input text file will work, the name isn't important
- Each line in the file must follow the format of either "shirt" or "pants", followed by three numbers indicated rgb values in the order of red, green, and then blue.
  - Ex: a pink shirt with the rgb values of (255, 192, 203) would be inserted into the file as "shirt 255 192 203"
  - Do not include quotation marks while making a clothes file, I just put it there for demonstration purposes.
  - A new line must be denoted for each new item of clothing
 
## Running the tool
- Run it in git bash with ./matcher.sh clothes.txt
- The file names are here for examples, you can name the files whatever you'd like

## What do the results mean?
- The tool will output every possible combination between clothes in the text file and how similar they are based on the euclidean distance between their rgb values
- Higher matches (in terms of %) will be present for similar colors
  - In the example above (3rd to last row) a shirt with the rgb values for sky blue has a 70.31% match with the rgb values for white pants
