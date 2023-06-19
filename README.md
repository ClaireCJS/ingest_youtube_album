# ingest_youtube_album

You ever sit there after downloading an album from a chapter-split youtube video and wonder, what do I do next?

Step 1: Download a youtube album with split-chapters into individual files:
``` 
    set URL=http://www.youtube.com/watch?v=EtapU5nI6G4
    yt-dlp --verbose --write-info-json --write-description --extractor-args   "youtube:player_client=android" --split-chapters %URL% -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-metadata   --write-thumbnail  --embed-thumbnail 
```
This also works if the video is a single song!

I've also included my personal download-youtube-album.bat, but it's written for TCC command-line so it may not be for you.

[Optional Step 1.5: Run my fix_unicode_filenames script to clean up any filenames ;) ]

Step 2: Run this script! 


## Why?

It will ask you who the original artist is, let you review some tags, it will tag the files using info from the youtube metadata, it will convert unicode to keep the tags compliant, it will strip unnecesary leading 0s off the filename, it will move the audio files into an "Artst\Year - Album" subfolder automatically. 

And there will be rainbows.


## Installation: Python

Install the required packages:

```bash
pip install -r requirements.txt
```

And also get my fix_unicode_filenames project somewhere importable


## Contributing: Modification

Feel free to make your own version with neato changes, if you are so inspired.

## Those wacky BAT files?

I use TCC -- Take Command Command Line.
Technically, my .BAT files are .BTM files.
If you want to get the ones I have working, contact me, I can help.

## License

[The Unlicense](https://choosealicense.com/licenses/unlicense/)

