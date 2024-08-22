@Echo off
 if "%COMMAND_SEPARATOR%" eq "CARET" (goto :AlreadySetThisWay)


        :   setdos /c%=^        %+ REM Don't want "^" to be the last character of the line because in bug situations where it is erroneously the command separator, having it be the last character of the line will cause the next line to be a continuation of this line, resulting in weird buggy output           
            setdos /c^  >>& nul %+ REM but the above will fail if the escape character has been undefined, so we should do this too
            set COMMAND_SEPARATOR=CARET

        if "%1" ne "silent" (call less_important "The escape key has ben set back to the caret key.")


:AlreadySetThisWay










