# Multi-Device Network Backup Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![Batch](https://img.shields.io/badge/Language-Batch-green.svg)](https://en.wikipedia.org/wiki/Batch_file)

A powerful Windows batch script that automates backup operations across multiple network devices. This script creates timestamped backups, compresses them automatically, and provides comprehensive logging for enterprise and home network environments.

## 🚀 Features

- **Multi-Device Support**: Backup from up to 4+ network devices simultaneously
- **Automatic Compression**: Creates ZIP archives to save storage space
- **Comprehensive Logging**: Detailed logs with timestamps for audit trails
- **Network Connectivity Check**: Pings devices before attempting backup
- **Error Handling**: Robust error detection and reporting
- **Administrative Share Support**: Uses Windows admin shares (C$, D$, E$)
- **Customizable Paths**: Easy configuration for different network topologies
- **Space Optimization**: Automatic cleanup of uncompressed folders after archiving

## 📋 Prerequisites

### System Requirements
- Windows 10/11 or Windows Server 2016+
- PowerShell 5.0+ (for compression functionality)
- Administrative privileges on the backup source machine
- Network connectivity to target devices

### Network Requirements
- All target devices must be accessible via network
- Administrative shares must be enabled on target devices
- Appropriate network permissions for file access
- Stable network connection for large file transfers

## 🛠️ Installation

1. **Download the Script**
   ```bash
   git clone https://github.com/valley4techs/multi-device-network-backup-script.git
   cd multi-device-network-backup-script
   ```

2. **Configure Target Devices**
   - Enable administrative shares on target machines
   - Ensure Windows File and Printer Sharing is enabled
   - Configure appropriate user permissions

3. **Test Network Connectivity**
   ```cmd
   ping 192.168.1.1
   ping 192.168.1.203
   ping 192.168.1.11
   ping 192.168.1.80
   ```

## ⚙️ Configuration

### Default Configuration
The script is pre-configured to backup from these devices:

| Device IP | Source Path | Description |
|-----------|-------------|-------------|
| 192.168.1.1 | D:\medlab\medlab | Medical lab data |
| 192.168.1.203 | E:\Work | Work documents |
| 192.168.1.11 | D:\Work | Work files |
| 192.168.1.80 | D:\Work | Additional work data |

### Adding New Devices

To add a new device (e.g., 192.168.1.100 with folder C:\Documents):

1. Locate the last backup section in the script
2. Add the following code block:

```batch
REM ---- Backup 5: Device 192.168.1.100, Folder C:\Documents ----
set "device5_ip=192.168.1.100"
set "source5=\\%device5_ip%\C$\Documents"
set "dest5=%baseBackupDir%\192.168.1.100_C_Documents"

echo.
echo Backing up %source5% to %dest5%
echo -------------------------------------------------- >> "%logFile%"
echo [%timestamp%] Starting backup for %source5% >> "%logFile%"

ping -n 1 %device5_ip% >nul
if errorlevel 1 (
    echo [%timestamp%] ERROR: Cannot reach %device5_ip%. Skipping backup for %source5%. >> "%logFile%"
) else (
    mkdir "%dest5%"
    robocopy "%source5%" "%dest5%" /E
    if errorlevel 8 (
        echo [%timestamp%] ERROR: Backup for %source5% failed with ROBOCOPY error code %errorlevel%. >> "%logFile%"
    ) else (
        echo [%timestamp%] SUCCESS: Backup for %source5% completed successfully. >> "%logFile%"
    )
)
```

### Customizing Backup Location
Change the backup destination by modifying:
```batch
set "localBackupDir=D:\Backup"
```

## 📖 Usage

### Basic Usage
1. **Run as Administrator** (Required for network access)
   ```cmd
   Right-click on backup_script.bat → "Run as administrator"
   ```

2. **Monitor Progress**
   - Watch console output for real-time status
   - Check log files in `D:\Backup\logs\` for detailed information

3. **Verify Backups**
   - Compressed backups are stored in `D:\Backup\`
   - Format: `Backup_YYYY-MM-DD_HH-MM-SS.zip`

### Advanced Usage

#### Scheduling with Task Scheduler
1. Open Windows Task Scheduler
2. Create Basic Task
3. Set trigger (daily, weekly, etc.)
4. Set action to start the batch file
5. Configure to run with highest privileges

#### Command Line Parameters
The script currently runs with default parameters. For custom ROBOCOPY options, modify the robocopy commands in the script.

## 📊 Output Structure

```
D:\Backup\
├── Backup_2024-01-15_14-30-25.zip    # Compressed backup archive
├── Backup_2024-01-16_14-30-25.zip    # Daily backups
└── logs\
    ├── backup_log_2024-01-15_14-30-25.txt
    └── backup_log_2024-01-16_14-30-25.txt
```

### Log File Format
```
[2024-01-15_14:30:25] Starting backup for \\192.168.1.1\D$\medlab\medlab
[2024-01-15_14:31:45] SUCCESS: Backup for \\192.168.1.1\D$\medlab\medlab completed successfully.
[2024-01-15_14:31:46] Starting compression of D:\Backup\Backup_2024-01-15_14-30-25
[2024-01-15_14:35:12] SUCCESS: Compression completed successfully.
```

## 🔧 Troubleshooting

### Common Issues

#### "Cannot reach device" Error
**Cause**: Network connectivity issues
**Solution**: 
- Verify IP addresses are correct
- Check network cables and switches
- Ensure target devices are powered on

#### "Access Denied" Error
**Cause**: Insufficient permissions
**Solution**:
- Run script as Administrator
- Verify administrative shares are enabled
- Check user account permissions on target devices

#### "ROBOCOPY Error Code 8+" 
**Cause**: File access or disk space issues
**Solution**:
- Check available disk space on backup drive
- Verify source paths exist and are accessible
- Review file permissions on source directories

#### Compression Fails
**Cause**: PowerShell or disk space issues
**Solution**:
- Ensure PowerShell 5.0+ is installed
- Check available disk space
- Verify PowerShell execution policy allows script execution

### Performance Optimization

#### For Large Files
Add these ROBOCOPY parameters for better performance:
```batch
robocopy "%source%" "%dest%" /E /R:3 /W:10 /MT:8
```
- `/R:3` - Retry 3 times on failed copies
- `/W:10` - Wait 10 seconds between retries
- `/MT:8` - Use 8 parallel threads

#### For Network Stability
```batch
robocopy "%source%" "%dest%" /E /R:5 /W:30 /TBD
```
- `/R:5` - More retries for unstable networks
- `/W:30` - Longer wait between retries
- `/TBD` - Wait for share names to be defined

## 📺 Video Tutorial

🎥 **Watch the complete setup and usage guide**: [YouTube Tutorial Link](#)

The video covers:
- Step-by-step installation
- Adding new devices
- Troubleshooting common issues
- Best practices for network backups

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 

### Development Guidelines
1. Test all changes on a virtual network environment
2. Update documentation for any new features
3. Maintain backward compatibility when possible
4. Add appropriate error handling for new functionality

### Reporting Issues
Please use the GitHub Issues tab to report:
- Bugs or unexpected behavior
- Feature requests
- Documentation improvements
- Performance issues

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Valley4Techs**
- YouTube: [Valley4Techs](https://www.youtube.com/c/Valley4Tech)
- GitHub:  [Valley4Techs](https://github.com/valley4techs)

## 🙏 Acknowledgments

- Thanks to the Windows ROBOCOPY team for the robust file copying utility
- Community feedback and contributions
- All users who provided testing and feedback

## 📈 Changelog

### v1.0.0 (2024-01-15)
- Initial release
- Support for 4 network devices
- Automatic compression and logging
- Basic error handling and connectivity checks

---

⭐ **If this script helped you, please consider giving it a star!** ⭐
