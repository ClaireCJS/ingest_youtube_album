@echo off


:: Loop through all files in the target directory
for %%f in (.\*) do (
    :: Check if the file size is zero bytes
    if %%~zf==0 (
        :: Delete the zero-byte file
        %COLOR_REMOVAL%
        *del  "%%f"
        :echo * Deleted zero-byte file: %%f
    )
)

%COLOR_SUCCESS%
echo.
echo * All zero-byte files have been deleted, I think.

