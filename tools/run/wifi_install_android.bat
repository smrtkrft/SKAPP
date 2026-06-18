@echo off
REM Connect to paired phone over Wi-Fi and install latest release APK.
REM On telefon ile esletirilmis olmali (ilk sefer wifi_pair_android.bat calistir).
REM APK yoksa once build_android_apk.bat calistir.

setlocal

set "ADB=%ANDROID_HOME%\platform-tools\adb.exe"
if not exist "%ADB%" set "ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
if not exist "%ADB%" (
    echo [HATA] adb.exe bulunamadi.
    pause
    exit /b 1
)

set "APK=%~dp0..\..\app\build\app\outputs\flutter-apk\app-release.apk"
if not exist "%APK%" (
    echo [HATA] APK bulunamadi:
    echo   %APK%
    echo.
    echo Once 'build_android_apk.bat' calistirip APK uret.
    pause
    exit /b 1
)

echo === SKAPP Android Wi-Fi Install ===
echo.
echo Telefondaki "Kablosuz hata ayiklama" ana ekranindaki IP:port'u gir
echo (eslesme kodu ekranindaki degil, ana sayfadaki).
echo.
set /p DEV_ADDR="Cihaz IP:port: "
echo.

echo Baglaniyor: %DEV_ADDR%
"%ADB%" connect %DEV_ADDR%
echo.

echo APK yukleniyor (-r: varsa uzerine yaz)...
"%ADB%" -s %DEV_ADDR% install -r "%APK%"
echo.
echo ==============================================================
echo Tamam. Telefonda SKAPP'i ac.
echo Sonraki buildlerde sadece:
echo   1. build_android_apk.bat
echo   2. wifi_install_android.bat (ayni IP:port ile)
echo ==============================================================
pause
endlocal
