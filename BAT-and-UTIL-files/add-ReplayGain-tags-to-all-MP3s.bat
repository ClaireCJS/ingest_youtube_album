@echo off 

if not exist *.mp3 (%COLOR_IMPORTANT_LESS% %+ echo * No mp3s exist here. %+ goto :END)

::::: metamp3.exe doesn't properly process *.mp3 if the mp3's base filename also ends in a dot / there are 2 dots before mp3 (example: W.T.F..mp3). So we have to use *.* not *.mp3
::::: but if we use *.*, it totally bludgeons and corrupts every non-mp3 file -- even rendering cover.jpg files into corrupt jpgs.   So we have to sequester.

set                                SEQ_DIR=ohhhhhhhhhhhhhhhhhhhhhhhhh
md                                %SEQ_DIR%
call validate-environment-variable SEQ_DIR
cd                                %SEQ_DIR%


%COLOR_UNIMPORTANT% %+ mv ..\*.mp3
call randfg         %+ metamp3 --replay-gain *.*
%COLOR_UNIMPORTANT% %+ mv * ..
                       cd ..
                       rd %SEQ_DIR%



:END
color bright red on black

