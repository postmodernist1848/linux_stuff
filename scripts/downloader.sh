#! /bin/bash

IMAGE_VIEWER=sxiv

DONE=false

function download {
    #don't do anything if input is nothing
    [ -z $1 ] && continue
    # download a picture with this name
    filename=$(wget -nv $1 2>&1 | cut -d\" -f2)

    # file extension is added automatically from the original filename
    case "$filename" in
        *.png*)
            ext=.png
            ;;
        *.jpg*)
            ext=.jpg
            ;;
        *.jpeg*)
            ext=.jpeg
            ;;
        *)
            ext=''
            echo "------------------ ERROR ---------------------------"
            echo "Unknown file extension for $filename."
            echo "Got from: $1"
            echo "------------------ ERROR ---------------------------"
            ;;
    esac
    # open the downloaded picture with image viewer defined above
    # and ask the user for the name they'd like to give this picture
    $IMAGE_VIEWER $filename && echo -n "Choose a filename: " && read -r
    # rename to the given name
    while [ -e "$REPLY$ext" ]
    do
        echo "ERROR: file '$REPLY$ext' already exists."
        echo "Choose another name: " && read -r
    done
    mv $filename "$REPLY$ext" && echo "Saved as $REPLY$ext"
}

if [ "$1" == "-f" ]; then
    file=$(cat $2)
    for line in $file
    do
        download $line
    done
else
    while read -r
    do
    download $REPLY 
    done
fi
