#!/bin/bash

# Displays info about the program
Help () {
    echo "Creates a .m3u playlist of all music files within a directory. By default, the file paths in the playlist will be relative."
    echo
    echo "Basic usage: ./create_playlist.sh --music <directory> --playlist <directory>"
    echo 
    echo "--help      -h               Print this help message."
    echo "--verbose   -v               Print music files as they are added to the playlist."
    echo "--music     -m   <directory> The directory where the music is. Picks up just mp3, ogg, wav, and m4a for now. ONLY in the same directory."
    echo "--playlist  -p   <directory> The directory where the playlist will be."
    echo "--name      -n   <name>      The name of the playlist. If there are spaces, put it between double quotes."
    echo "--absolute  -a               Use absolute paths when creating the playlist. Otherwise, they will be relative."
    echo
    echo "Example: "
    echo "      ./create_playlist.sh -m /home/joemama/Music/ABBA/Voulez-Vous -p /home/joemama/playlists -n my_new_playlist"
    echo
    echo "Creates a playlist that points to all music in -m's directory."
    echo
}

# Actually creates a playlist
CreatePlaylist () {
    musicDir=$1 
    playlistDir=$2 
    playlistName=$3
    beVerbose=$4
    beAbsolute=$5

    echo
    echo "Creating playlist..."
    scriptDir=${pwd}
    cd "$musicDir"

    # Grab all music files
    thankYouForTheMusic=()
    readarray thankYouForTheMusic < <(ls -Q *.{mp3,ogg,wav,m4a})

    echo "Found ${#thankYouForTheMusic[@]} songs..."

    # Create playlist then fill er up
    touch "$playlistDir/$playlistName.m3u"
    for i in "${thankYouForTheMusic[@]}"; do

        if $beAbsolute; then
            echo "$musicDir/$i" >> "$playlistDir/$playlistName.m3u"
        else
            echo "$(realpath --relative-to="$playlistDir" "$i")" >> "$playlistDir/$playlistName.m3u"
        fi

        if $beVerbose; then
            echo "Added $i"
        fi        
    done

    # Delete " in file
    sed -e "s/\"//g" -i "$playlistDir/$playlistName.m3u"

    # Delete any newlines in file
    sed -e "/^[[:space:]]*$/d" -i "$playlistDir/$playlistName.m3u"

    cd "$scriptDir"
    echo "Finished $playlistName.m3u at $playlistDir"
}

# Start of program
# Check that we actually have arguments
if [ $# -eq 0 ]; then
    echo "Not enough arguments. Try ./create_playlist.sh -h"
    exit 1
fi

musicDir=
playlistDir=
playlistName="my_playlist"
beVerbose=false
beAbsolute=false

# Process flags
while [ "$1" != "" ]; do
    case $1 in
    -h | --help)
        Help
        exit 1
        ;;
    -m | --music)
        shift # Remove -m from command feed
        musicDir=$1
        ;;
    -p | --playlist)
        shift
        playlistDir=$1
        ;;
    -v | --verbose)
        beVerbose=true
        ;;
    -a | --absolute)
        beAbsolute=true
        ;;
    -n | --name)
        shift
        playlistName=$1
        ;;
    *) # Default
        Help
        exit 1
        ;;
    esac
    shift
done
        
# Ensure we have input
if [ "$musicDir" == "" ]; then
    echo "You must provide a directory with music, using --music <directory>"
    exit 1
elif [ "$playlistDir" == "" ]; then
    echo "You must provide a directory to store the playlist, using --playlist <directory>"
    exit 1
fi

# Ensure these directories exist
if [[ ! -d $musicDir ]]; then
    echo "$musicDir is not a real directory."
    exit 1
elif [[ ! -d $playlistDir ]]; then
    echo "$playlistDir is not a real directory."
    exit 1
fi

musicDir=$(realpath "$musicDir")
playlistDir=$(realpath "$playlistDir")

echo
echo "Music directory is    $musicDir"
echo "Playlist will be in   $playlistDir"
echo "It will be named      $playlistName.m3u"

if $beAbsolute; then
    echo "Will use absolute file paths in the playlist."
else
    echo "Will use relative file paths in the playlist."
fi

read -p "Okay to continue? (Y/n): " option

if [ "$option" == "" ] || [ "$option" == "Y" ] || [ "$option" == "y" ]; then
    CreatePlaylist "$musicDir" "$playlistDir" "$playlistName" "$beVerbose" "$beAbsolute"
    exit 0
else
    exit 1
fi

