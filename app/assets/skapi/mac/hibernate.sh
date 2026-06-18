#!/bin/bash
# hibernate.sh
# SKAPI MAC Power Management
# macOS'ta Linux/Windows'taki anlamda "explicit hibernate" yok; pmset
# hibernatemode=25 (deep sleep, RAM'i diske yazıp gücü kesme) ile
# yaklaşılır. Bu mod laptop'larda Apple silicon'da varsayılan değil;
# yalnızca ayar değişirse sleep komutuyla disk'e yazma tetiklenir.
#
# Pratik yaklaşım: `pmset sleepnow` ile system'ı uyutuyoruz. Eğer
# kullanıcı hibernatemode'u 25'e set etmişse (manuel ya da `sudo
# pmset hibernatemode 25`), gerçek hibernation davranışı oluşur.
# Aksi halde standard sleep (RAM'de tutar).
#
# `sudo pmset hibernatemode 25` setup'ı bu script tarafından YAPILMAZ —
# kullanıcı şifresi gerektirir, webhook bağlamında uygun değil. Script
# sadece sleep çağırır; gerçek hibernate ayarı bir kerelik kullanıcı
# kurulumudur.

set -u

delay=0

while [ $# -gt 0 ]; do
  case "$1" in
    --delay) delay="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$delay" -gt 0 ]; then
  sleep "$delay"
fi

pmset sleepnow >/dev/null 2>&1

echo "OK"
exit 0
