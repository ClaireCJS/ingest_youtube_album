@Echo OFF



:PUBLISH:
:DESCRIPTION:  Download a "youtube album" (album posted as a youtube video) to separate mp3s (per chapter in the youtube video, if there are any), tagged, renamed, ReplayGain'ed, and moved to proper folder structure.  It can also do single songs, but that wasn't its original purpose.
:USAGE:        download-youtube-video-as-mp3-album https://www.youtube.com/watch?v=6w8dVVf6UnY
:REQUIRES:     metaflac.exe (to add ReplayGain tags to FLAC files), metaflac.mp3 (to add ReplayGain tags to MP3 files), yt-dlp.exe (to download YouTube videos), our messaging system & validator scripts
:DEPENDENCIES: set-latestfilename.bat (to determine latest/youngest file), delete-largest-file.bat (to delete full-album after splitting into chapters), set-task (but only to set the TASK and window title)


REM DEBUGGY stuff
        set URL="%*"
        :eset URL
        echo. %+ echo.
        call warning        "About to download a youtube video of a song, or chapter-separated album, to mp3 format!"
        call print-if-debug "URL is:         %URL%"
        call print-if-debug "Parameters are: %*"
        call set-task "downloading youtube albums"

REM check parameters & environment
        if "%URL%" eq "" (call error "Need URL!" %+ goto :END)
        call validate-in-path               ingest_youtube_album.py delete-zero-byte-files important important_less errorlevel delete-largest-file warning error print-if-debug set-task metamp3 metaflac yt-dlp set-latest-filename openimage get-image-dimensions askyn crop-center-square-of-image make-image-square celebration change-into-temp-folder
        call validate-environment-variables ANSI_BRIGHT_CYAN faint_on faint_off italics_on italics_off underline_on underline_off filemask_image %+ REM most of these are set by set-colors.bat:


REM Extensions that we may be downloading:
        set EXTENSIONS_WE_ARE_POSSIBLY_DOWNLOADING=*.opus;*.webm;*.mp3;*.flac


REM secret command line options
        if "%1" eq "already"                          (goto :Already_Downloaded)
        if "%1" eq        "ingest"                    (goto :befor_ingest      )
        if "%1" eq  "befor_ingest"                    (goto :befor_ingest      )
        if "%1" eq "before_ingest"                    (goto :befor_ingest      )
        if "%1" eq "before"   .and. "%2" eq "ingest"  (goto :befor_ingest      )
        if "%1" eq "after"    .and. "%2" eq "ingest"  (goto :after_ingest      )
        if "%1" eq "after_ingest"                     (goto :after_ingest      )
        if "%1" eq "replaygain"                       (goto :after_ingest      )
        if "%1" eq "rename"                           (goto :rename_files      )
        if "%1" eq "rename_files"                     (goto :rename_files      )
        if "%1" eq "rename"   .and. "%2" eq   "files" (goto :rename_files      )
        if "%1" eq "fix_image" .or. "%1" eq "fix_img" (goto :fix_image         )
        if "%1" eq  "fiximage" .or. "%1" eq  "fiximg" (goto :fix_image         )
        if "%1" eq     "image" .or. "%1" eq     "img" (goto :fix_image         )
       :if "%1" != ""                                 (goto :%1                )                     %+ REM goto a specific label

REM Ask where to place our downloads...
        pushd 
        set            NAME_OF_FOLDER_TO_PUT_THIS_DOWNLOAD_IN=.
        REM eset       NAME_OF_FOLDER_TO_PUT_THIS_DOWNLOAD_IN
        if not isdir "%NAME_OF_FOLDER_TO_PUT_THIS_DOWNLOAD_IN%" (md "%NAME_OF_FOLDER_TO_PUT_THIS_DOWNLOAD_IN%")
        if not isdir "%NAME_OF_FOLDER_TO_PUT_THIS_DOWNLOAD_IN%" (call error "wtf couldn't make dir" %+ goto :END)
        cd           "%NAME_OF_FOLDER_TO_PUT_THIS_DOWNLOAD_IN%" 







REM do everything in a temp folder!
        call change-into-temp-folder youtube-music-download










    REM ***************** Download each chapter as a separate file in the best audio format and write thumbnail ***************** 

    REM -o '%(id)s.%(ext)s' To save as the video title change to '%(title)s.%(ext)s' to save. 
    REM For a custom filename songname.%(ext)s.

    REM would like these i think --compat-options embed-metadata 
    call warning "ytl-dlp %URL% (with extra steps)" %+ pause %+ %COLOR_RUN% 
    %COLOR_RUN%
    @echo on
    yt-dlp --verbose --write-info-json --write-description --extractor-args   "youtube:player_client=android" --split-chapters %URL% -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-metadata   --write-thumbnail  --embed-thumbnail 
    @echo off

    REM -o "%%(album_artist,artist,creator,uploader|)s/%%(release_year,release_date,upload_date|)s%%(release_year,release_date,upload_date& - |)s%%(album,title|)s/%%{id&FULL ALBUM|}s%%{title|}s
    REM GOLD: "%%(album_artist,artist,creator,uploader|)s/%%(release_year,release_date,upload_date|)s%%(release_year,release_date,upload_date& - |)s%%(album,title|)s"

    REM template won't affect chapters, may as well make it "full album"
    REM --parse-metadata "album:goat"
    rem --postprocessor-args "-metadata album='%%(title)s'" definitely set it! to the string %(title)s haha
    rem --postprocessor-args "-metadata album=%(title)s"  did not work with 1-4,8 slashes - and isn't even supported (chatgpt hallucination)
    REM --replace-in-metadata FIELDS REGEX REPLACE
    rem one % = "0s" two % = "%(title)s"  three % = "0s" four % = 0s eight %=
    REM bad for chapter splitting, no way to get chapter number or title -o "chapter:%%(autonumber)s_%%(title)s.%%(ext)s"  
    REM yt-dlp -x --audio-format mp3 " "https://www.youtube.com/watch?v=..."


    REM -O  %(name[.keys][addition][>strf][,alternate][&replacement][|default])[flags][width][.precision][length]type

            REM default: %(title)s-%(id)s.%(ext)s
            REM wanted!: %(album_artist|uploader)s/%(release_year|release_date)s - %(title)s/%(chapter_number)s_%(chapter)s

    REM # Prefix playlist index with " - " separator, but only if it is available
    REM $ yt-dlp -o '%(playlist_index|)s%(playlist_index& - |)s%(title)s.%(ext)s' BaW_jenozKc "https://www.youtube.com/user/TheLinuxFoundation/playlists"

    REM (chapters&has chapters|no chapters)s, %(title&TITLE={:>20}|NO TITLE)s
    REM --parse-metadata "description:Artist: (?P<artist>.*?)\nAlbum: (?P<album>.*)"
    REM try in a minute --parse-metadata "title:%(artist)s - %(album)s
    REM removed: --embed-info-json             only for video files
    REM removed: --embed-subs --sub-langs en   [EmbedSubtitle] Subtitles can only be embedded in mp4, mov, m4a, webm, mkv, mka files



    REM        :: %(title)s: The video title.
    REM        :: %(id)s: The video identifier.
    REM        :: %(uploader)s: The uploader's name.
    REM        :: %(uploader_id)s: The uploader's identifier.
    REM        :: %(uploader_url)s: The URL to the uploader's YouTube channel.
    REM        :: %(channel)s: The full name of the channel.
    REM        :: %(channel_id)s: The channel identifier.
    REM        :: %(upload_date)s: The date when the video was uploaded in the format YYYYMMDD.
    REM        :: %(extractor)s: The extractor key (youtube, vimeo, etc.)
    REM        :: %(playlist)s: The playlist title.
    REM        :: %(playlist_id)s: The playlist identifier.
    REM        :: %(playlist_index)s: The index of the video in the playlist padded with zeros.
    REM        :: %(age_limit)s: The age restriction of the video (usually 0 or 18).
    REM        :: %(autonumber)s: An automatically incremented number that is unique for every video (starts at 00000).
    REM        :: %(epoch)s: Unix timestamp when creating the file.
    REM        :: %(duration)s: Length of the video in seconds.
    REM        :: %(format)s: A human-readable description of the format.
    REM        :: %(format_id)s: The unique id of the format.
    REM        :: %(view_count)s: The number of views of the video.
    REM        :: %(like_count)s: Number of likes.
    REM        :: %(dislike_count)s: Number of dislikes.
    REM        :: %(average_rating)s: Average rating (likes vs dislikes).
    REM        :: %(comment_count)s: Number of comments.
    REM        :: %(category)s: Category or genre of the video.
    REM        :: %(ext)s: The file extension.
    REM        :: %(filesize)s: The file size.
    REM        :: %(format)s: The name of the format.
    REM        :: %(height)s and %(width)s: The resolution of the video.
    REM        :: %(resolution)s: The video resolution.
    REM        :: %(fps)s: The frame rate.





REM Chapters are split, so we can delete the unsplit, which will be the largest file
        set NUM_DOWNLOADED=%@FILES[%EXTENSIONS_WE_ARE_POSSIBLY_DOWNLOADING]
        if %NUM_DOWNLOADED% GT 1 (call delete-largest-file)


REM rename files to the filenames we like
        :rename_files
        set TEXT_INFO=README.txt
        set JSON_INFO=info.json
        echo. %+ echo. %+ echo. %+ echo. 
        call important_less "Successfully downloaded %NUM_DOWNLOADED% files matching extensions '%EXTENSIONS_WE_ARE_POSSIBLY_DOWNLOADING%'"
        if %NUM_DOWNLOADED% GT 1 (
            set DOWNLOADS=many
            if exist *.description (ren *.description    %TEXT_INFO%)           %+ REM typically README.txt
            if exist *.json        (ren *.json           %JSON_INFO%)           %+ REM typically info.json
            for %%G in (%filemask_image%) do (if exist "*%%G" set COVER_ART=cover.%@LOWER[%@EXT[%%G]] %+ %COLOR_RUN %+ ren "%%G" "%COVER_ART%" %+ %COLOR_IMPORTANT %+ call less_important "Cover art renamed to '%COVER_ART%'" )
            call validate-environment-variables TEXT_INFO JSON_INFO COVER_ART
        )
        if %NUM_DOWNLOADED% EQ 1 (
            set DOWNLOADS=one
            call set-latestfilename %EXTENSIONS_WE_ARE_POSSIBLY_DOWNLOADING%
            set LATESTFILENAME_BASE=%@NAME[%LATEST_FILENAME]
            call unimportant "Latest filename is: %LATESTFILENAME_BASE%"
            %COLOR_SUCCESS% 
            if exist *.description (ren *.description "%LATESTFILENAME_BASE%.txt" )
            if exist *.json        (ren *.json        "%LATESTFILENAME_BASE%.json")
            for %file in (%FILEMASK_IMAGE%) do echo if exist "%file%" ren "%file%" "%LATESTFILENAME_BASE%.%@EXT[%FILE]"
            for %file in (%FILEMASK_IMAGE%) do      if exist "%file%" ren "%file%" "%LATESTFILENAME_BASE%.%@EXT[%FILE]"
        )


REM Tag and move the files with our assistant python script:
        set AUTOMATIC_UNICODE_CLEANING=1 %+ echo. %+ echo. %+ echo. %+ echo. %+ echo. %+ echo. %+ REM \_____the environment variable didn't seem to work 
        :Redo_fuf
        call fix-unicode-filenames auto  %+ call errorlevel "uh oh spaghettios!!!!!!" %+ echo. %+ REM /     so we used the "auto" parameter instead
        if %REDO eq 1 goto :Redo_fuf
        set AUTOMATIC_UNICODE_CLEANING=0 %+ echo. %+ echo. %+ echo. %+ echo. %+ echo. 
        call important "About to run youtube-album ingest script (ingest_youtube_album.py)..."
        :ingest
        :befor_ingest
        :before_ingest
        REM tag our files, move them into a properly-named folder, fix their filenames
            ingest_youtube_album.py
            call errorlevel "youtube ingest failed in folder %_CWD [called by %0]"
            if %redo eq 1 goto :ingest
        :after_ingest


REM Add replaygain tags
        call warning "About to add ReplayGain tags..."
        REM pause
        :add_replaygain_tags
        pushd 
            REM ingest-youtube-album.py creates go-to-album.bat as a return value to change into the folder it created to moves the album into   
            if "%DOWNLOADS%" eq "many" (
                set                                INGEST_RETURN_SCRIPT=go-to-album.bat
                call validate-environment-variable INGEST_RETURN_SCRIPT "ingest return script not found in %0"
                call                              %INGEST_RETURN_SCRIPT%
            )               
            echo. %+ echo. %+ echo. %+ echo. %+ echo. %+ echo.          
            call warning "About to add replaygain tags in %_CWD..." %+ call pause-if-debug "force" 
            call add-ReplayGain-tags  
        popd  
        if exist go-to-album.bat (*del go-to-album.bat)             %+ REM now that we've used it, we don't need it  [TODO maybe change to *del]
        *del /q _ingest.log >nul                                    %+ REM the log is actually copied into our target folder but a copy remains here, which we do not want


REM Allow us to manually adjust the filename 
        call delete-zero-byte-files
        echo. %+ echo. %+ echo. %+ echo. %+ echo. 
        call set-latest-filename
        call rn "%latest_file%"




REM Change out of temp folder and move things back to where we started
        cd ..
        call validate-env-var TEMP_FOLDER WHERE_WE_STARTED
        echo. %+ echo. %+ echo. 
        %COLOR_IMPORTANT_LESS% %+ echo * Current folder = %_CWD %+ echo. 
        %COLOR_WARNING%        %+ echos * About to move everything out of our TEMP_FOLDER``
        %COLOR_WARNING_SOFT%   %+ echos  (%TEMP_FOLDER) ``
        %COLOR_NORMAL%         %+ echo. 
        %COLOR_NORMAL%         %+ echos   ``
        %COLOR_WARNING%        %+ echos and back to: %WHERE_WE_STARTED%
        %COLOR_NORMAL%         %+ echo.
                                  pause
        %COLOR_SUCCESS%        %+ mv /ds "%TEMP_FOLDER%" .


REM Fix cover image -
REM                 \-- it may need cropping of just-the-center-square (720x720 square image  centered across a 1280x720 canvas with black sidebars)
REM                 \-- it may need resized  in order to become square (720x720 square image stretched across a 1280x720 canvas)
        :fix_image
        REM get image name
            call   set-latest-filename %filemask_image%
            set image=%latest_filename%

        REM display image
            call openimage "%image%"
        REM prompt/correct image
            set action_taken=
            set image_changed=0
            set         Q1="Does this need the center square cropped out?"
            set         Q2="Does this need to be reshaped to square? (i.e. it is currently very obviously in the wrong aspect ratio)" 
            call askyn %Q1% no %+ if %do_it   eq 1 (set do_it_1=1)
            call askyn %Q2% no %+ if %do_it   eq 1 (set do_it_2=1)
            if                       %do_it_1 eq 1 (set image_changed=1 %+ set action_taken="cropped" %+ call crop-center-square-of-image "%image%")
            if                       %do_it_2 eq 1 (set image_changed=1 %+ set action_taken="resized" %+ call make-image-square           "%image%")

        REM report new situation
            if %image_changed eq 1 (
                call get-image-dimensions "%image%"
                echo %ANSI_BRIGHT_CYAN%*** Image %faint_on%%image%%faint_off% has been %italics_on%%action_taken%%italics_off% to %underline_on%%dimensions%%underline_off%
            )




:END
        echo. %+ echo. %+ echo. 
        call celebration "Youtube album download complete!!!!!"
        REM  celebration.bat->print-message.bat does titles automatically now so we don't need to do this anymore: title Completed:  Youtube album download

        dir


