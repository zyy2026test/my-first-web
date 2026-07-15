@echo off
cd /d C:\Users\Administrator\.qclaw\workspace
:loop
python -m http.server 8766
timeout /t 3 >nul
goto loop
