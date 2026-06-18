help / rastgele birsey girildiginde "help" komutuna yönlendirme yazisi olmali."


## System

### device
device.info
device.restart
device.factory-reset
device.confirm-token

### wifi
wifi.status
wifi.scan
wifi.list
wifi.connect
  Usage:  wifi connect <ssid> [password] [<ip>[/cidr]] [primary|backup]
  Basit: wifi connect HomeWiFi pass1234
  Static IP: wifi connect HomeWiFi pass1234 192.168.1.50/24
  Backup slot: wifi connect Office pass5678 backup
  Açık ağ (şifresiz): wifi connect Cafe
  Not: credentials NVS'e kaydedilir, reboot sonrası otomatik bağlanır. İki slot (primary + backup).
wifi.disconnect
wifi.forget

### ble 
alt komutlarda gerekli aciklama var mi ?
ble.status 
ble.unpair

### ota 
alt komutlarda gerekli aciklama var mi ? kullanici örnegin help ota.rollback yaptiginda bir aciklama yazisi cikiyor mu ?
ota.status
ota.check
ota.update
ota.rollback

### logs
logs icerigimiz ne ? cihazlarda ortak bir logs yapisi olusturmaliyiz. cihazda olusan sorunlarin ortak bir logs kayit yapisi olmali , hangi sorunlar logs olarak gösterilecek ? %80 ortak tüm cihazlarda ayni olacak sorunlar %20 cihaza özgü log eklenmeli , peki bu tüm cihazlarda ortak karisilasilacak sorunlar neler olacak ? hangileri loglara eklenecek ?
logs.get


# SKAPP

### pairing
alt komutlarda gerekli aciklama var mi ?
pairing.status
pairing.start
pairing.stop

### auth
alt komutlarda gerekli aciklama var mi ?
auth.passphrase.status
auth.passphrase.set
auth.passphrase.change
auth.passphrase.clear
auth.passphrase.mode.set

### bond
alt komutlarda gerekli aciklama var mi ?
bond.list
bond.remove

### api.system
alt komutlarda gerekli aciklama var mi ?
api.system.add
api.system.remove
api.system.purge
api.system.list
