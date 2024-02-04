REM Disable displaying the commands from the script
REM Once your script works, you can remove the REM (Remark/Comment) 
REM @echo off

REM Localize the environment changes in a batch file. 
REM This means any changes to environment variables (like PATH) will only apply within the context of this batch file.
REM The global environment space will not corrupted!
SETLOCAL EnableDelayedExpansion

REM User-configurable variables
set "CONDA_ENV_NAME=thinkston"
set "PROJECT_FOLDER=C:\Users\kgvin\Downloads\streamlit-ml2-main\streamlit-ml2-main"
set "CONDA_PATH=C:\Users\kgvin\anaconda3"
set "PYTHON_VER=3.8"

REM Set the PATH to prioritize Anaconda Python
set "PATH=%CONDA_PATH%;%CONDA_PATH%\Scripts;%PATH%"

REM Check if the Conda environment exists
conda env list | findstr /C:"%CONDA_ENV_NAME%" > nul
if errorlevel 1 (
    echo Conda environment "%CONDA_ENV_NAME%" does not exist.
    set /p UserInput=Do you want to create it? [Y/N]: 
    if /I "!UserInput!"=="Y" (
        echo Creating the Conda environment "%CONDA_ENV_NAME%"...
        %CONDA_PATH%\Scripts\conda create --name "%CONDA_ENV_NAME%" python="%PYTHON_VER%" -y
    ) else (
        echo Environment not created. Exiting...
		pause
        goto :EOF
    )
) 

REM Change to the project directory
cd /d "%PROJECT_FOLDER%"

REM Check if requirements.txt exists
REM Install the required python packages
if exist requirements.txt (
    echo requirements.txt found.
    set /p UserResp=Do you want to install Python packages from requirements.txt within the "%CONDA_ENV_NAME%" environment? [Y/N]: 
    if /I "!UserResp!"=="Y" (
        echo Installing requirements in "%CONDA_ENV_NAME%"...
        %CONDA_PATH%\Scripts\conda run --name "%CONDA_ENV_NAME%" python -m pip install -r requirements.txt
    ) else (
        echo Skipping installation.
    )
)

REM Launch VS Code in the current directory
%CONDA_PATH%\Scripts\activate.bat && conda activate %CONDA_ENV_NAME% && code %PROJECT_FOLDER%

REM Keep the window open (optional, remove this line if not needed)
REM This will help you see the errors if the script fails
pause

REM End the local environment and restore the original environment
ENDLOCAL
