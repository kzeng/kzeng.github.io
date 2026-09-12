@echo off
setlocal enabledelayedexpansion

REM Create new post: auto-number as pYYYY-MM-DD-NNN.md with front matter
REM Usage: scripts\new.bat [optional title]

set "DIR=content\posts"
if not exist "%DIR%" mkdir "%DIR%"

REM Get today's date as YYYY-MM-DD
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set "DT=%%I"
set "TODAY=%DT:~0,4%-%DT:~4,2%-%DT:~6,2%"

REM Default title
set "TITLE=Untitled"
if not "%~1"=="" set "TITLE=%~1"

REM Find highest existing number for today
set "MAX=0"
for %%F in ("%DIR%\p%TODAY%-*.md") do (
    set "FNAME=%%~nxF"
    set "NUM=!FNAME:p%TODAY%-=!"
    set "NUM=!NUM:.md=!"
    if !NUM! gtr !MAX! set "MAX=!NUM!"
)

set /a "N=MAX+1"

REM Zero-pad to 3 digits
set "NUM3=00%N%"
set "NUM3=!NUM3:~-3!"

set "FILE=%DIR%\p%TODAY%-%NUM3%.md"

REM Collect existing tags from all posts (first-seen order)
set "TAGFILE=%TEMP%\kzeng_tags_%RANDOM%.txt"
type nul > "%TAGFILE%"
for %%F in ("%DIR%\*.md") do (
    for /f "usebackq delims=" %%L in ("%%F") do (
        set "LINE=%%L"
        if "!LINE:~0,5!"=="tags:" (
            set "BODY=!LINE:*[=!"
            for /f "delims=]" %%B in ("!BODY!") do set "BODY=%%B"
            for %%X in (!BODY!) do (
                set "T=%%~X"
                if not "!T!"=="" echo !T!>> "%TAGFILE%"
            )
        )
    )
)

REM Dedupe using sort, then join with 、
set "TAGS="
set "PREV="
if exist "%TAGFILE%" (
    sort "%TAGFILE%" > "%TAGFILE%.srt" 2>nul
    for /f "usebackq delims=" %%G in ("%TAGFILE%.srt") do (
        if not "%%G"=="!PREV!" (
            if defined TAGS (
                set "TAGS=!TAGS!、%%G"
            ) else (
                set "TAGS=%%G"
            )
        )
        set "PREV=%%G"
    )
    del "%TAGFILE%" "%TAGFILE%.srt" >nul 2>&1
)

REM Write front matter
(
echo ---
echo title: "%TITLE%"
echo date: %TODAY%
echo draft: false
echo tags: []
echo # Existing tags: !TAGS!
echo ---
echo.
) > "%FILE%"

echo Created: %FILE%

endlocal
