# Collection of Useful Scripts - Overview & Categorization

## Overview
This repository is a diverse library of scripts for **System Administration**, **Network Auditing**, **Task Automation**, and **Programming Education**. It includes tools spanning multiple languages (Python, PowerShell, Bash, and Batch) designed for both Windows and Unix environments.

## Project Details
- **Languages**: Python (`.py`), PowerShell (`.ps1`), Batch (`.bat`), Bash (`.sh`).
- **Primary Use Cases**: IT Administration, Security Auditing, Web Scraping, and Learning.

## Categorized Tools

### 1. System Administration & Windows Utilities
- **Active Directory Audit.ps1**: Comprehensive script for auditing users and groups in AD.
- **Gather lots of sys info.bat**: A thorough system information collector.
- **Disable Windows Defender on Windows 10.bat**: A utility for bypassing or disabling Defender (likely for lab/testing environments).
- **Remove all printers and unused drivers.bat**: Maintenance script for cleaning up Windows print spoolers.
- **OS_Info.ps1**: Detailed OS and hardware reporting via PowerShell.

### 2. Networking & Security
- **wifipassword.py / A script to view wireless SSIDs...bat**: Tools for recovering stored Wi-Fi credentials.
- **Script to Block any IP.sh**: Firewall automation for Unix systems.
- **Cross-platform netstat output.ps1**: Normalized networking diagnostics.
- **Microsoft Network Policy Server (NPS) Policy Order Script.ps1**: Specialized tool for managing RADIUS/NPS policy orders.

### 3. Web & Automation
- **4chan_Image Grabber.py**: Scraper for downloading image threads.
- **Download microsoft patents.py**: Automates the retrieval of patent documents from Microsoft's public archives.
- **Script for taking a screenshot and uploading.sh**: A productivity tool for quick screen sharing.
- **PDF_Editor.py**: Basic Python-based PDF manipulation.

### 4. Educational Resources (PowerShell Lab)
A significant portion of the repository is dedicated to learning PowerShell core concepts:
- `Understand-PowerShell-Objects.ps1`
- `Control-the-Flow-of-PowerShell.ps1`
- `Parameters-Attributes-for-Scripts.ps1`
- `Working-with-JSON-Objects.ps1`

### 5. Miscellaneous / Fun
- **pigeons.ps1**: (Unknown, likely a joke or simulation script).
- **planecrash.py**: (Unknown, possibly data analysis related to aviation).
- **Crash test.bat**: A high-intensity script for testing system stability under load.

## Key Technical Insights
- **Polyglot Approach**: The collection demonstrates how similar administrative tasks can be solved using different scripting paradigms.
- **CLI GUI Integration**: Some Batch scripts (e.g., `A small pop-up window...bat`) show how to use Windows built-ins to create simple UI elements for shell scripts.
- **Automation**: The Python scripts leverage libraries like `requests` and `selenium` for web tasks.

## How to Use
- **Individual Script Use**: Review the internal comments of each script before execution. Many require Administrator/Root privileges.
- **Learning**: The PowerShell scripts are organized sequentially to teach the language from basics to modules.
