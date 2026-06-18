SmartKraft APP sürecinde uyulmasi gereken kurallar. Bu kurallar kesin bir sekilde uyulmali.

### 1- Bu app Linux, Windows , Mac , ios ve android uyumlu olacak.

### 2- Bu progragram esp32c6 chipi ile haberlesecek bluethoot üzerinden ve gerekli durumda hem BLE hem Wifi birlikte kullanilabilinir.

### 3- Birden fazla farkli gelistiridigim SmartKraft cihazlari ile uyumlu olacak. 

    yani 3 farkli islevde ve donanimlari farkli kompanentleri farkli adlari farkli SmartKraft ürünü ayni app ile arayüzlerine erisilebilecek ve yapilandirilabilecek.

### 4- APP uzaktan güncellenebilecek.
github üzerinden yada website üzerinden, versiyon kontrolü ile güncellenebilecek.

### 5- ESP32 C6 tarafi cli + ble (gerekeirse + wifi) seklinde olacak. 

    bu yüzden app farkli cihazlarin arayüzlerini icermeli, bluethoot cihazi gördügünde hangi cihaz oldugunu algilamali ve o cihaz icin olusturulan icerik acilarak cihaz yapilandirilmali


### 6- APP ana iskelet ve modular yapiya sahip olmali. 

    örnegin ana sistemi degistirmeden ek kütüphane ekler gibi yeni cihaz icin gereken arayüz sistemi ve kontrol ayarlamalari modüler sekilde sisteme eklenebilmeli ve bu ek eklenti sistemde bug olusturmamali.

### 7- Protokol versiyonlama disiplin gerektiriyor: 

Yeni firmware → yeni komut. Eski APP → yeni komutu bilmiyor. APP mağazada güncel olsa bile kullanıcı otomatik güncellemeyi kapatmışsa patlar. Çözüm: her komut versiyonlu, list_commands ile APP runtime'da neyi destekleyemeyeceğini bilip o ekranları gri yapar. Disiplin şart — atlanırsa kullanıcıya "komut bulunamadı" hataları çıkar. 

### Geriye dönük uyumluluk icin gerekli

### 8- Zorunlu komut seti

    her cihaz device_info, list_commands, version, status, factory_reset, reboot, wifi_*, logs_get, ota_*, time_set implement etmeli. APP bağlandığı her cihazda kesin bu komutların var olduğunu varsayabilmeli.



    