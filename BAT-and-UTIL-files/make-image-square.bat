@Echo OFF

REM validate environment
        call validate-in-path magick.exe

REM get filename to fix
        set           FIRST_PARAMETER_IMAGE_FILENAME=%1
        call validate FIRST_PARAMETER_IMAGE_FILENAME
        set    image=%FIRST_PARAMETER_IMAGE_FILENAME%

REM did we get a filename to fix?
        if not defined image (call error "%0 couldn't figure out a filename to fix" %+ goto :END)

REM get mode?
                           set CROP=0
        if "%2" eq "crop" (set CROP=1)

REM get dimensions of it
        set dimensions=%@EXECSTR[magick.exe identify -format "%%%%wx%%%%h" %IMAGE%]
        set      width=%@EXECSTR[magick.exe identify -format "%%%%w"       %IMAGE%]
        set     height=%@EXECSTR[magick.exe identify -format       "%%%%h" %IMAGE%]
        call unimportant "image: '%image%':: width=%width%, height=%height%, dim=%dimensions%"

REM is it square?
        set smaller_is=
        if %height gt %width (set smaller_is=width)
        if %height lt %width (set smaller_is=height)
        if %height eq %width (goto :no_resize_needed)

REM If we are here, it is not square and needs fixing:
        if %crop ne 1 (
            if "%smaller_is%" eq "width"  (set SQUARE_DIMEN=%height %+ echo "resize  width of %width% to be %height")
            if "%smaller_is%" eq "height" (set SQUARE_DIMEN=%width% %+ echo "resize height of %height to be %width%")
            magick.exe convert %IMAGE% -resize %SQUARE_DIMEN%x%SQUARE_DIMEN% -gravity center -crop %SQUARE_DIMEN%x%SQUARE_DIMEN%+0+0 +repage %IMAGE%
        ) 
        if %crop eq (
            if "%smaller_is%" eq "width"  (set SQUARE_DIMEN=%width% %+ echo "crop to %width% square")
            if "%smaller_is%" eq "height" (set SQUARE_DIMEN=%height %+ echo "crop to %height square")
            magick.exe convert %IMAGE%                                       -gravity center -crop %SQUARE_DIMEN%x%SQUARE_DIMEN%+0+0 +repage %IMAGE%
        )






REM Cleanup/end
        :no_resize_needed
        :END

