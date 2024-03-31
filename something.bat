@echo off
setlocal enabledelayedexpansion

rem Define input and output files
set "input=flame_scores.csv"
set "output=sorted.csv"

rem Read the header and write it to the output file
(for /F "usebackq tokens=*" %%A in ("%input%") do (
    echo %%A
    goto :BreakLoop
)) > "%output%"
:BreakLoop

rem Read the data, sort by the third column, and write to temporary file
(for /F "usebackq skip=1 tokens=*" %%A in ("%input%") do (
    set "line=%%A"
    for /F "tokens=1-3 delims=," %%B in ("!line!") do (
        echo %%D,%%A
    )
)) > unsorted.tmp

rem Read the temporary file and process each line
for /F "tokens=1-5 delims=," %%s in (unsorted.tmp) do (
    rem Patch the four numbers as two-digit values
    set /A "a=100000000+%%s"
    echo !a:~1!
    echo %%s
    rem Check if the array element already exists
    if defined line[!a:~1!] (
        set /A "a+=1"
        rem If the element already exists, append the new line to it
        set "line[!a:~1!]=%%t,%%u,%%v,%%w"
    ) else (
        rem If the element doesn't exist, create a new one
        set "line[!a:~1!]=%%t,%%u,%%v,%%w"
    )
)

rem Loop through each array element and echo its index and value
for /F "tokens=2,1 delims==" %%x in ('set line[') do (
    echo Index: %%y, Value: %%x
)

rem Show the array elements
(for /F "tokens=2 delims==" %%s in ('set line[') do (
    echo %%s
)) >> "%output%"

rem Clean up temporary files
