@Echo OFF

REM     I actually do all my development for this in my personal live command line environment,
REM     so for me, these files actually "live" in "c:\bat\" and just need to be refreshed to my 
REM     local GIT repo beore doing anything significant.  Or really, before doing anything ever.


rem CONFIGURATION:
        SET MANIFEST_FILES=ingest_youtube_album.py download-youtube-album.bat split-mp3-by-inputted-chapter-info-helper.py split-mp3-by-inputted-chapter-info.bat 

        set SECONDARY_BAT_FILES=download-youtube-album.bat validate-in-path.bat validate-environment-variables.bat validate-environment-variable.bat white-noise.bat unimportant.bat print-message.bat randcolor.bat randfg.bat randbg.bat colors.bat colortool.bat settmpfile.bat important.bat important_less.bat error.bat fatalerror.bat fatal_error.bat car.bat nocar.bat errorlevel.bat print-if-debug.bat advice.bat warning.bat celebration.bat change-escape-character-to-tilde.bat change-escape-character-to-carrot.bat change-escape-character-to-normal.bat delete-zero-byte-files.bat set-latestfilename.bat delete-largest-file.bat add-ReplayGain-tags.bat add-ReplayGain-tags-to-all-FLACs.bat add-ReplayGain-tags-to-all-MP3s.bat change-into-temp-folder.bat set-largestfilename.bat set-colors.bat make-image-square.bat crop-center-square-of-image.bat openimage.bat get-image-dimensions.bat print-if-debug.bat set-task.bat fix-unicode-filenames.bat askyn.bat

        set SECONDARY_UTIL_FILES=metamp3.exe metaflac.exe yt-dlp.exe 
        

call update-from-BAT-via-manifest.bat



