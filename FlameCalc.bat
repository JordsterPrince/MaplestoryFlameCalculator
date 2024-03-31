@echo off
setlocal enabledelayedexpansion
if exist C:\Users\jords\OneDrive\Documents\Development\FlameCalc\flame_scores.csv (
    del flame_scores.csv
)
rem -----------------------------------------Set the directory where Snipping Tool saves screenshots
set "snip_directory=%~dp0\Screenshots"

rem Check if the directory exists
if not exist "%snip_directory%" (
    echo Directory "%snip_directory%" does not exist.
    exit /b
)

rem Print the directory path for debugging
echo Directory path: %snip_directory%

rem -----------------------------------------Iterate over each image file in the directory
for %%F in ("%snip_directory%\*.*") do (
    rem Get the path of the current image file
    set "IMAGE_PATH=%%~fF"
    echo !IMAGE_PATH!

    rem -----------------------------------------Use Tesseract to extract text from the image
    rem Use Tesseract to extract text from the current image
    start /B /WAIT "" "Tesseract" "!IMAGE_PATH!" stdout > temp.txt

    rem Wait for Tesseract to complete
    timeout /t 1 /nobreak > nul

    rem -----------------------------------------Read the name of the Item
    rem Initialize the variable to store the name of the item
    set "nameOfItem="

    rem Read the first line from the text file
    set /p "nameOfItem=" < "temp.txt"

    rem Remove anything before the word "Arcane" if it exists
    for /f "tokens=1,*" %%a in ("!nameOfItem!") do (
        if /i "%%a"=="Arcane" (
            set "nameOfItem=%%b"
        )
    )

    rem Output the name of the item
    echo Name of Item: !nameOfItem!

    rem -----------------------------------------Search the text file for LUK
    rem Search for the line containing "LUK"
    set "LUK="
    for /f "delims=" %%a in (temp.txt) do (
        set "line=%%a"
        echo !line! | findstr /i "LUK" >nul
        if not errorlevel 1 (
            set "LUK=!line!"
        )
    )

    rem Output the extracted line with "LUK"
    echo Extracted line with "LUK": !LUK!

    rem -----------------------------------------Search the text file for Attack Power
    rem Search for the line containing "Power"
    set "Att="
    for /f "delims=" %%a in (temp.txt) do (
        set "line=%%a"
        echo !line! | findstr /i "Power" >nul
        if not errorlevel 1 (
            set "Att=!line!"
        )
    )

    rem Output the extracted line with "Att"
    echo Extracted line with "Att": !Att!

    rem -----------------------------------------Search the text file for All Stat
    rem Search for the line containing "Stats"
    set "AS="
    for /f "delims=" %%a in (temp.txt) do (
        set "line=%%a"
        echo !line! | findstr /i "Stats" >nul
        if not errorlevel 1 (
            set "AS=!line!"
        )
    )

    rem Output the extracted line with "All Stat"
    echo Extracted line with "All Stats": !AS!

    rem -----------------------------------------Only get the flame score of LUK
    rem Extract the numbers within parentheses
    for /f "tokens=2 delims=()" %%a in ("!LUK!") do (
        set "numbers1=%%a"
    )

    rem Count the number of numbers within parentheses
    set "count=0"
    for %%n in (!numbers1!) do (
        set /a count+=1
    )
    echo ****************************
    rem If there are three numbers, extract the third one
    if !count! equ 3 (
        rem Extract the number between the second and third "+" occurrences
        for /f "tokens=2 delims=+" %%a in ("!numbers1!") do (
            set "justLUK=%%a"
        )

        rem Remove leading and trailing spaces
        set "justLUK=!justLUK: =!"

        echo Extracted LUK: !justLUK!
    ) else (
            echo There are not exactly three numbers in LUK parentheses.
        set "justLUK=0"
    )

    rem -----------------------------------------Only get the flame score of Att
    rem Extract the numbers within parentheses
    for /f "tokens=2 delims=()" %%a in ("!Att!") do (
        set "numbers2=%%a"
    )

    rem Count the number of numbers within parentheses
    set "count=0"
    for %%n in (!numbers2!) do (
        set /a count+=1
    )

    rem If there are three numbers, extract the third one
    if !count! equ 3 (
        rem Extract the number between the second and third "+" occurrences
        for /f "tokens=2 delims=+" %%a in ("!numbers2!") do (
            set "justAtt=%%a"
        )

        rem Remove leading and trailing spaces
        set "justAtt=!justAtt: =!"

        echo Extracted Att: !justAtt!
    ) else (
            echo There are not exactly three numbers in Att parentheses.
        set "justAtt=0"
    )

    rem -----------------------------------------Only get the flame score of All Stats
    rem Extract the numbers within parentheses
    for /f "tokens=2 delims=()" %%a in ("!AS!") do (
        set "numbers3=%%a"
    )

    rem Count the number of numbers within parentheses
    set "count=0"
    for %%n in (!numbers3!) do (
        set /a count+=1
    )

    rem If there are two numbers, extract the second one
    if !count! equ 2 (
        rem Extract the number between the first and second "+" occurrences
        for /f "tokens=2 delims=+" %%a in ("!numbers3!") do (
            set "justAllStats=%%a"
        )

        rem Remove leading and trailing spaces
        set "justAllStats=!justAllStats: =!"

        rem Convert justAllStats to an integer for comparison
        set /a justAllStatsInt=justAllStats

        if !justAllStatsInt! equ 69 (
            set "justAllStats=6"
        ) else if !justAllStatsInt! equ 695 (
            set "justAllStats=6"
        ) else if !justAllStatsInt! equ 59 (
            set "justAllStats=5"
        ) else if !justAllStatsInt! equ 595 (
            set "justAllStats=5"
        ) else if !justAllStatsInt! equ 49 (
            set "justAllStats=4"
        ) else if !justAllStatsInt! equ 495 (
            set "justAllStats=4"
        ) else if !justAllStatsInt! equ 39 (
            set "justAllStats=3"
        ) else if !justAllStatsInt! equ 395 (
            set "justAllStats=3"
        )

        echo Extracted All Stats: !justAllStats!
    ) else (
            echo There are not exactly two numbers in All Stat parentheses.
        set "justAllStats=0"
    )
    
    rem -----------------------------------------Add values to Cypress File
    rem Set the path to the Cypress test file
    set "test_file=C:\Users\jords\OneDrive\Documents\Development\FlameCalc\cypress\e2e\FlameCalc.cy.js"

    rem Clear the contents of the Cypress test file
    echo. > "!test_file!"

    rem Edit the test file
    >> "!test_file!" echo describe^('Flame Calculator', ^(^) ^=^> {
    >> "!test_file!" echo   it^('Checks the flames score of an item', ^(^) ^=^> {
    >> "!test_file!" echo     // Visit the website
    >> "!test_file!" echo     cy.visit^('https://brendonmay.github.io/flameCalculator/'^);
    >> "!test_file!" echo     // Wait for the checkbox to be visible and clickable
    >> "!test_file!" echo     cy.get^('input[id^="flamescorecheck"]'^).click^(^);
    >> "!test_file!" echo     cy.wait^(2000^);
    >> "!test_file!" echo     cy.get^('.ml-2 ^> span'^).click^(^);
    >> "!test_file!" echo     cy.get^('#main_flame'^).click^(^).clear^(^).type^('!justLUK!'^);
    >> "!test_file!" echo     cy.get^('#att_flame'^).click^(^).clear^(^).type^('!justAtt!'^);
    >> "!test_file!" echo     cy.get^('#all_flame'^).click^(^).clear^(^).type^('!justAllStats!'^);
    >> "!test_file!" echo     cy.get^('#flameButton'^).click^(^);
    >> "!test_file!" echo     cy.wait^(500^);
    >> "!test_file!" echo     // Capture text from an element and save it to a file
    >> "!test_file!" echo     cy.get^('#flamescore_div'^).invoke^('text'^).then^(text ^=^> {
    >> "!test_file!" echo     cy.writeFile^('result.txt', text.trim^(^)^);
    >> "!test_file!" echo     }^);
    >> "!test_file!" echo   }^);
    >> "!test_file!" echo }^);

    rem ------------------------------------------Run Cypress test to generate result.txt which has your items flame score
    rem Set the path to the Cypress executable (replace with your actual path)
    set "cypress_executable=cypress"

    rem Set the path to the directory containing Cypress tests
    set "tests_directory=cypress\e2e"

    rem Set the name of the Cypress spec file you want to run
    set "spec_file=FlameCalc.cy.js"

    rem Run Cypress tests
    start "" cmd /c "npx cypress run --spec "!tests_directory!\!spec_file!" && taskkill"

    rem Wait for result.txt to be generated by Cypress
    if not exist "result.txt" (
        timeout /t 20 >nul
    )
    rem Set the path to the result file generated by Cypress
    set "result_file=result.txt"
    rem Read the content of the result file and extract the numeric part
    for /f "usebackq delims=" %%a in ("!result_file!") do (
        set "line=%%a"
    )
    rem Extract the numeric part using string manipulation
    for /f "tokens=6" %%b in ("!line!") do (
        set "extracted_number=%%b"
    )
    rem Remove any non-numeric characters from the extracted number
    set "extracted_number=!extracted_number:*:=!"
    set "extracted_number=!extracted_number: =!"
    echo Your Items Flame Score is: !extracted_number!
    set /a result=!extracted_number! + 10
    set "justAllStats=0"

    del result.txt
    rem -----------------------------------------Use Flame score to check cost
    rem Set the path to the Cypress test file
    set test_file1=C:\Users\jords\OneDrive\Documents\Development\FlameCalc\cypress\e2e\FlameCost.cy.js

    rem Clear the contents of the Cypress test file
    echo. > "!test_file1!"

    rem Edit the test file
    >> "!test_file1!" echo describe^('Flame Calculator Cost', ^(^) ^=^> {
    >> "!test_file1!" echo   it^('Checks the cost if you want to improve flame score by 10', ^(^) ^=^> {
    >> "!test_file1!" echo     // Visit the website
    >> "!test_file1!" echo     cy.visit^('https://brendonmay.github.io/flameCalculator/'^);
    >> "!test_file1!" echo     // Wait for the checkbox to be visible and clickable
    >> "!test_file1!" echo     cy.get^('input[id^="flamescorecheck"]'^).click^(^);
    >> "!test_file1!" echo     cy.wait^(2000^);
    >> "!test_file1!" echo     cy.get^('.ml-2 ^> span'^).click^(^);
    >> "!test_file1!" echo     cy.get^('#desired_stat_armor'^).click^(^).clear^(^).type^('!result!'^);
    >> "!test_file1!" echo     cy.get^('#calculateButton'^).click^(^);
    >> "!test_file1!" echo     cy.wait^(500^);
    >> "!test_file1!" echo     // Capture text from an element and save it to a file
    >> "!test_file1!" echo     cy.get^('#result'^).invoke^('text'^).then^(text ^=^> {
    >> "!test_file1!" echo     cy.writeFile^('cost.txt', text.trim^(^)^);
    >> "!test_file1!" echo     }^);
    >> "!test_file1!" echo   }^);
    >> "!test_file1!" echo }^);

    rem ------------------------------------------Run Cypress test to generate cost.txt which has your cost to get 10 more flame score
    rem Set the path to the Cypress executable (replace with your actual path)
    set "cypress_executable=cypress"

    rem Set the path to the directory containing Cypress tests
    set "tests_directory=cypress\e2e"

    rem Set the name of the Cypress spec file you want to run
    set "spec_file=FlameCost.cy.js"

    rem Run Cypress tests
    start "" cmd /c "npx cypress run --spec "!tests_directory!\!spec_file!" && taskkill"

    rem Wait for cost.txt to be generated by Cypress
    if not exist "cost.txt" (
        timeout /t 15 >nul
    )
    rem Set the path to the cost file
    set "cost_file=cost.txt"

    rem Initialize medianValue variable
    set "medianValue="
    rem Extract the average value from the cost file
    rem Search for lines containing "Median cost:" in cost.txt
    for /f "tokens=3" %%a in ('findstr /C:"Median cost:" "!cost_file!"') do (
        set "medianValue=%%a"
        echo ****************************
        rem Output the extracted median value
        echo Median value: !medianValue!
        rem Remove commas from the extracted median value
        set "medianValue=!medianValue:,=!"
        echo another thing
        rem Initialize the variable to store the average value
        set "averageValue="
        rem Extract the average value from the cost file
        for /f "tokens=3" %%b in ('findstr /C:"Average cost:" "!cost_file!"') do (
            set "averageValue=%%b"
            rem Output the formatted average value
            echo Average value: !averageValue!
            echo ************************************************************************************************
            rem Remove commas from the extracted average value
            set "averageValue=!averageValue:,=!"

            rem -----------------------------------------Add values to CSV file with headers
            rem Set the path to the CSV file
            set "csv_file=C:\Users\jords\OneDrive\Documents\Development\FlameCalc\flame_scores.csv"
            if not exist "!csv_file!" (
                echo ItemName,FlameScore,Median for 10 FS in Millions,Average for 10 FS in Millions> "!csv_file!"
            )
            echo !averageValue!
            rem Round the median and average values using PowerShell
            for /F %%h in ('powershell -C "[math]::Round(!medianValue! / 1000000, 0)"') do (set "roundedMedian=%%h")
            for /F %%i in ('powershell -C "[math]::Round(!averageValue! / 1000000, 0)"') do (set "roundedAverage=%%i")
            echo !roundedAverage!
            rem Append data to the CSV file
            echo !nameOfItem!,!extracted_number!,!roundedMedian!,!roundedAverage!>> "!csv_file!"
            del temp.txt
            del cost.txt
        )
    )
)

rem ---------------------------------------------Takes flame_scores.csv and sorts it based off of the median value--Outputs sorted.csv
rem Define input and output files
set "input=flame_scores.csv"
set "output=sorted.csv"

rem Read the data, sort by the third column, and write to temporary file
(for /F "usebackq skip=1 tokens=*" %%A in ("%input%") do (
    set "line=%%A"
    for /F "tokens=1-3 delims=," %%B in ("!line!") do (
        echo %%D,%%A
    )
)) > unsorted.tmp

set "line="
rem Read the temporary file and process each line
for /F "tokens=1-5 delims=," %%s in (unsorted.tmp) do (
    rem Make the first number way bigger to be able to compare them
    set /A "s=100000000+%%s"
    rem Check if the array element already exists
    if defined line[!s:~1!] (
        set /A "s+=1"
        rem If the element already exists, append the new line to it
        set "line[!s:~1!]=%%t,%%u,%%v,%%w,different"
    ) else (
        rem If the element doesn't exist, create a new one
        set "line[!s:~1!]=%%t,%%u,%%v,%%w,something"
    )
)

echo ItemName,FlameScore,Median for 10 FS in Millions,Average for 10 FS in Millions > "%output%"

rem Show the array elements
(for /F "tokens=2 delims==" %%x in ('set line[') do (
    echo %%x
)) >> "%output%"

rem Clean up temporary files

endlocal