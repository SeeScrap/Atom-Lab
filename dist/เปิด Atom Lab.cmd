@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
set "APP=%~dp0Atom Lab.html"
if not exist "!APP!" (
  echo ไม่พบไฟล์ Atom Lab.html ในโฟลเดอร์เดียวกับตัวเปิดนี้
  pause & exit /b 1
)
rem Chrome เปิดโหมดหน้าต่างแอปไม่ได้ ถ้า URL มีอักษรนอก ASCII เช่นชื่อโฟลเดอร์ภาษาไทย
rem จึงใช้ "ชื่อสั้น 8.3" ของ Windows แทน เพราะเป็น ASCII ล้วนและไม่มีช่องว่าง
rem (ทดสอบแล้ว: ไทยดิบ -> ไม่เปิด, ชื่อสั้น 8.3 -> เปิดได้)
for %%F in ("!APP!") do set "SHORT=%%~sF"

rem บางเครื่องปิดชื่อสั้น 8.3 ไว้ จะได้ path เดิมกลับมา กรณีนั้นเปิดแบบธรรมดาแทน
if /i "!SHORT!"=="!APP!" (
  start "" "!APP!"
  exit /b
)
set "URL=!SHORT:\=/!"

rem ใช้โปรไฟล์ของแอปเอง แยกจาก Chrome ที่ผู้ใช้เปิดทำงานอยู่
rem ถ้าไปใช้โปรไฟล์เดียวกัน Chrome ที่รันอยู่แล้วจะรับช่วงคำสั่งต่อ
rem แล้วเปิดเป็นแท็บธรรมดาแทนที่จะเป็นหน้าต่างแอป
set "PROF=%LocalAppData%\AtomLab\profile"

for %%B in (
  "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  "%LocalAppData%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
  "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
) do (
  rem ต้องอยู่บรรทัดเดียว ห้ามใช้ ^ ตัดบรรทัดในบล็อก for ไม่งั้น argument ท้ายจะหลุด
  if exist %%B (
    start "" %%B --user-data-dir="!PROF!" --no-first-run --no-default-browser-check --hide-crash-restore-bubble --disable-session-crashed-bubble --noerrdialogs --window-size=1340,900 "--app=file:///!URL!"
    exit /b
  )
)
rem ไม่เจอ Chrome หรือ Edge — เปิดด้วยเบราว์เซอร์ค่าเริ่มต้นแทน
start "" "!APP!"
