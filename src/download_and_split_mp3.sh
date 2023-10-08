#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <URL> <FILENAME_TO_SAVE> <CHUNK_DURATION>"
    exit 1
fi

URL="$1"
FILE_NAME="$2"
FILENAME_TO_SAVE="$2.mp3"
CHUNK_DURATION="$3"

CHUNKING_DIR="mp3_outputs"
CHUNKING_PATH="$CHUNKING_DIR/$FILE_NAME"
OUTPUT_TEMPLATE="$CHUNKING_PATH/$FILE_NAME-%03d.mp3"



if [ ! -d "$CHUNKING_PATH" ]; then
    echo "Directory does not exist: $CHUNKING_PATH"
    mkdir $CHUNKING_PATH
fi

# Download the audio from the URL and save it to the specified file
curl -L -o "$FILENAME_TO_SAVE" "$URL"


# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Download failed."
    exit 1
fi

# Split the downloaded file into chunks using FFmpeg
ffmpeg -i "$FILENAME_TO_SAVE" -f segment -segment_time "$CHUNK_DURATION" -c copy "$OUTPUT_TEMPLATE"

# Delete the original downloaded file
rm "$FILENAME_TO_SAVE"