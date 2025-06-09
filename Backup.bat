@echo off
REM --------------------------------------------------------------------
REM Multi-Device Backup Script
REM Backs up folders from multiple network devices to a local backup folder.
REM 1. From 192.168.1.1: D:\medlab
REM 2. From 192.168.1.203: E:\Work
REM 3. From 192.168.1.11: D:\Work
REM 4. From 192.168.1.80: D:\Work
REM Backups are stored in D:\Backup\Backup_<timestamp>
REM Logs are written to D:\Backup\logs\backup_log_<timestamp>.txt
REM Author: Valley4Techs
REM Date: %date%
REM --------------------------------------------------------------------

REM -----------------------------
REM Define local directories
set "localBackupDir=D:\Backup"
set "logDir=D:\Backup\logs"

REM -----------------------------
REM Generate a timestamp for folder and log file names (YYYY-MM-DD_HH-MM-SS)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value ^| find "="') do set "dt=%%I"
set "year=%dt:~0,4%"
set "month=%dt:~4,2%"
set "day=%dt:~6,2%"
set "hour=%dt:~8,2%"
set "min=%dt:~10,2%"
set "sec=%dt:~12,2%"
set "timestamp=%year%-%month%-%day%_%hour%-%min%-%sec%"

REM -----------------------------
REM Ensure the local backup and log directories exist
if not exist "%localBackupDir%" (
    echo Creating local backup directory: %localBackupDir%
    mkdir "%localBackupDir%"
)
if not exist "%logDir%" (
    echo Creating log directory: %logDir%
    mkdir "%logDir%"
)

REM Create a base backup folder with the current timestamp.
set "baseBackupDir=%localBackupDir%\Backup_%timestamp%"
echo Creating base backup folder: %baseBackupDir%
mkdir "%baseBackupDir%"

REM Define a common log file for all backup operations.
set "logFile=%logDir%\backup_log_%timestamp%.txt"

REM -----------------------------
REM Backup Operation Functionality
REM The following section performs backup operations:
REM 1. Check connectivity by pinging the device.
REM 2. Create a destination subfolder.
REM 3. Use ROBOCOPY to copy files.
REM 4. Log the outcome.
REM -----------------------------

REM ---- Backup 1: Device 192.168.1.1, Folder D:\medlab ----
set "device1_ip=192.168.1.1"
REM Using admin share for drive D: for medlab
set "source1=\\%device1_ip%\D$\medlab\medlab"
set "dest1=%baseBackupDir%\192.168.1.1_D_medlab"

echo.
echo Backing up %source1% to %dest1%
echo -------------------------------------------------- >> "%logFile%"
echo [%timestamp%] Starting backup for %source1% >> "%logFile%"

REM Check connectivity to device1
ping -n 1 %device1_ip% >nul
if errorlevel 1 (
    echo [%timestamp%] ERROR: Cannot reach %device1_ip%. Skipping backup for %source1%. >> "%logFile%"
) else (
    REM Create destination folder for backup 1
    mkdir "%dest1%"
    REM Perform the backup using ROBOCOPY (/E copies subdirectories, including empty ones)
    robocopy "%source1%" "%dest1%" /E
    REM ROBOCOPY exit codes 0-7 are considered success.
    if errorlevel 8 (
        echo [%timestamp%] ERROR: Backup for %source1% failed with ROBOCOPY error code %errorlevel%. >> "%logFile%"
    ) else (
        echo [%timestamp%] SUCCESS: Backup for %source1% completed successfully. >> "%logFile%"
    )
)

REM ---- Backup 2: Device 192.168.1.203, Folder E:\Work ----
set "device2_ip=192.168.1.203"
REM Using admin share for drive E:
set "source2=\\%device2_ip%\E$\Work"
set "dest2=%baseBackupDir%\192.168.1.203_E_Work"

echo.
echo Backing up %source2% to %dest2%
echo -------------------------------------------------- >> "%logFile%"
echo [%timestamp%] Starting backup for %source2% >> "%logFile%"

ping -n 1 %device2_ip% >nul
if errorlevel 1 (
    echo [%timestamp%] ERROR: Cannot reach %device2_ip%. Skipping backup for %source2%. >> "%logFile%"
) else (
    mkdir "%dest2%"
    robocopy "%source2%" "%dest2%" /E
    if errorlevel 8 (
        echo [%timestamp%] ERROR: Backup for %source2% failed with ROBOCOPY error code %errorlevel%. >> "%logFile%"
    ) else (
        echo [%timestamp%] SUCCESS: Backup for %source2% completed successfully. >> "%logFile%"
    )
)

REM ---- Backup 3: Device 192.168.1.11, Folder D:\Work ----
set "device3_ip=192.168.1.11"
REM Using admin share for drive D:
set "source3=\\%device3_ip%\D$\Work"
set "dest3=%baseBackupDir%\192.168.1.11_D_Work"

echo.
echo Backing up %source3% to %dest3%
echo -------------------------------------------------- >> "%logFile%"
echo [%timestamp%] Starting backup for %source3% >> "%logFile%"

ping -n 1 %device3_ip% >nul
if errorlevel 1 (
    echo [%timestamp%] ERROR: Cannot reach %device3_ip%. Skipping backup for %source3%. >> "%logFile%"
) else (
    mkdir "%dest3%"
    robocopy "%source3%" "%dest3%" /E
    if errorlevel 8 (
        echo [%timestamp%] ERROR: Backup for %source3% failed with ROBOCOPY error code %errorlevel%. >> "%logFile%"
    ) else (
        echo [%timestamp%] SUCCESS: Backup for %source3% completed successfully. >> "%logFile%"
    )
)

REM ---- Backup 4: Device 192.168.1.80, Folder D:\Work ----
set "device4_ip=192.168.1.80"
REM Using admin share for drive D:
set "source4=\\%device4_ip%\D$\Work"
set "dest4=%baseBackupDir%\192.168.1.80_D_Work"

echo.
echo Backing up %source4% to %dest4%
echo -------------------------------------------------- >> "%logFile%"
echo [%timestamp%] Starting backup for %source4% >> "%logFile%"

ping -n 1 %device4_ip% >nul
if errorlevel 1 (
    echo [%timestamp%] ERROR: Cannot reach %device4_ip%. Skipping backup for %source4%. >> "%logFile%"
) else (
    mkdir "%dest4%"
    robocopy "%source4%" "%dest4%" /E
    if errorlevel 8 (
        echo [%timestamp%] ERROR: Backup for %source4% failed with ROBOCOPY error code %errorlevel%. >> "%logFile%"
    ) else (
        echo [%timestamp%] SUCCESS: Backup for %source4% completed successfully. >> "%logFile%"
    )
)

REM --------------------------------------------------------------------
REM Compress the base backup folder and delete it to free up space.
REM All files inside %baseBackupDir% will be compressed to a ZIP file.
REM Then delete the original folder to save space.
REM --------------------------------------------------------------------
echo.
echo Compressing backup folder %baseBackupDir% into a zip archive...
echo -------------------------------------------------- >> "%logFile%"
echo [%timestamp%] Starting compression of %baseBackupDir% >> "%logFile%"

REM Use PowerShell to compress the folder; make sure PowerShell is available on the system (available in Windows 10 and later)
powershell -command "Compress-Archive -Path '%baseBackupDir%\*' -DestinationPath '%baseBackupDir%.zip'" 

if errorlevel 1 (
    echo [%timestamp%] ERROR: Compression of backup folder failed. >> "%logFile%"
) else (
    echo [%timestamp%] SUCCESS: Compression completed successfully. >> "%logFile%"
    REM Delete the original folder after compression.
    rmdir /s /q "%baseBackupDir%"
    echo [%timestamp%] SUCCESS: Original backup folder deleted after compression. >> "%logFile%"
)

echo.
echo All backup operations and compression completed. Please check the log file at "%logFile%" for details.
