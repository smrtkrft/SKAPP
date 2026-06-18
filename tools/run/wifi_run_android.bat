@echo off
REM Run SKAPP on paired Android phone over Wi-Fi WITH HOT RELOAD.
REM Telefon eslestirilmis olmali (ilk sefer wifi_pair_android.bat).
REM
REM Calistirinca terminal acik kalir. Kodu kaydedince:
REM   r = hot reload (telefon 1 sn'de guncellenir, state korunur)
REM   R = hot restart (state sifirlanir)
REM   q = cikis (telefondaki APP donar - tekrar baslat ya da kapat)

setlocal

set "ADB=%ANDROID_HOME%\platform-tools\adb.exe"
if not exist "%ADB%" set "ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
if not exist "%ADB%" (
    echo [HATA] adb.exe bulunamadi.
    pause
    exit /b 1
)

echo === SKAPP Android Wi-Fi Run (Hot Reload) ===
echo.
echo Telefondaki "Kablosuz hata ayiklama" ANA ekranindaki IP:port'u gir
echo (eslesme kodu degil, ana sayfadaki).
echo.
set /p DEV_ADDR="Cihaz IP:port: "
echo.

echo Baglaniyor: %DEV_ADDR%
"%ADB%" connect %DEV_ADDR%
echo.

cd /d "%~dp0\..\..\app"
echo APP baslatiliyor (ilk sefer 1-2 dakika surebilir)...
echo.
echo --- KISAYOLLAR ---
echo  r = hot reload (kod degisikligini telefonda anlik gor)
echo  R = hot restart
echo  q = cikis
echo ------------------
echo.

flutter run -d %DEV_ADDR%

pause
endlocal
