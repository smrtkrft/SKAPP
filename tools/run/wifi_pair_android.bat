@echo off
REM One-time pair phone with PC for wireless ADB debugging.
REM Telefon ve PC ayni Wi-Fi agina bagli olmali.
REM Eslesme telefon yeniden baslatilincaya kadar gecerlidir.

setlocal

set "ADB=%ANDROID_HOME%\platform-tools\adb.exe"
if not exist "%ADB%" set "ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
if not exist "%ADB%" (
    echo [HATA] adb.exe bulunamadi.
    echo Android SDK platform-tools kurulu degil ya da farkli bir yerde.
    pause
    exit /b 1
)

echo === SKAPP Android Wi-Fi Pair ===
echo.
echo Telefonda yapilacaklar:
echo   1. Ayarlar -^> Gelistirici Secenekleri -^> "Kablosuz hata ayiklama" / "Wireless debugging" -^> ACIK
echo   2. Acilan ekranda "Cihazi eslesme koduyla esle" / "Pair device with pairing code"
echo   3. Ekranda IP:port (orn 192.168.1.50:39201) ve 6 hanelik kod gosterilir
echo      (Bu IP:port "eslesme" portudur, asil baglanti portu farklidir!)
echo.

set /p PAIR_ADDR="Eslesme IP:port: "
set /p PAIR_CODE="6 hanelik kod: "
echo.

"%ADB%" pair %PAIR_ADDR% %PAIR_CODE%
echo.
echo ==============================================================
echo Eslesme bitti. Simdi 'wifi_install_android.bat' calistirip
echo telefonun ANA wireless debugging IP:port'u (eslesme degil) ile
echo baglanip APK yukleyebilirsin.
echo ==============================================================
pause
endlocal
