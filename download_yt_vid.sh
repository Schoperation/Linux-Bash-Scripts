#!/bin/bash

Help () {
    echo "Downloads a youtube video using either a provided URL or a URL in the user's clipboard, for maximum convenience!"
    echo
    echo "Basic Usage: ./download_yt_vid.sh --url <url> --yt-dl-location <path> --output-directory <path>"
    echo
    echo "--help                -h  Prints this help message."
    echo "--url                 -u  The URL of the video to download."
    echo "--yt-dl-directory     -y  The path to where the youtube-dl program is located."
    echo "--output-directory    -o  The path to where the video will be downloaded."
    echo
}

Download () {
    url=$1
    ytDlDir=$(realpath "$2")
    outputDir=$(realpath "$3")

    cd $ytDlDir
    ./youtube-dl -f mp4 -o "$outputDir/%(title)s.%(ext)s" $url 
}

if [ $# -eq 0 ]; then
    echo "Not enough arguments. Try ./download_yt_vid.sh -h"
    exit 1
fi

url=
ytDlDir=/usr/bin
outputDir=

while [ "$1" != "" ]; do
    case $1 in
    -h | --help)
        Help
        exit 1
        ;;
    -u | --url)
        shift
        url=$1
        ;;
    -y | --yt-dl-directory)
        shift
        ytDlDir=$1
        ;;
    -o | --output-directory)
        shift
        outputDir=$1
        ;;
    *) # Default
        Help
        exit 1
        ;;
    esac
    shift
done

if [ "$ytDlDir" == "" ]; then
    echo "You must provide a directory with youtube-dl, using --yt-dl-directory <directory>"
    exit 1
elif [ "$outputDir" == "" ]; then
    echo "You must provide a directory to store the video, using --output-directory <directory>"
    exit 1
fi

if [[ ! -d $ytDlDir ]]; then
    echo "$ytDlDir is not a real directory."
    exit 1
elif [[ ! -d $outputDir ]]; then
    echo "$outputDir is not a real directory."
    exit 1
fi

# Grab URL from clipboard if we aren't supplied one
if [ "$url" == "" ]; then
    if [[ $(xclip -o) == "" ]]; then
        echo "Nothing detected on your clipboard..."
        url="https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    else
        url=$(xclip -o)
    fi
fi

Download "$url" "$ytDlDir" "$outputDir"

exit 0

