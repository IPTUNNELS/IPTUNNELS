# Homeproxy Tutorial

Tutorial ini hanya untuk OpenWRT 23.05 atau terbaru dengan firewall4 sebagai default.

Langkah-langkah WAJIB harus ada internet
- Installation sing-box
- Installation Homeproxy
- Patch Homeproxy
- Download GeoIP and GeoSite
- Config Homeproxy

Sebelum restart OpenWRT, Mohon untuk mematikan auto startup Tools inject lainnya seperti OpenClash dkk.

# Installation sing-box

Silahkan lakukan instalasi sing-box melalui opkg
```sh
opkg update;opkg install sing-box
```
Jika tidak bisa, bisa menggunakan alternative download manual, contoh saya menggunakan Raspberry Pi dengan arch arm64.
```sh
cd /tmp
wget -O /tmp/sing-box-1.7.6-linux-arm64.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.7.6/sing-box-1.7.6-linux-arm64.tar.gz
tar -xvf /tmp/sing-box-1.7.6-linux-arm64.tar.gz
cp /tmp/sing-box-1.7.6-linux-arm64/sing-box /usr/bin/sing-box
```

# Installation Homeproxy

Homeproxy untuk sekarang hanya support untuk sing-box sebelum versi 1.8.0 jadi patch dan config yang kami sediakan juga menyesuaikan.
Download luci-app-homeproxy
```sh
wget -O /tmp/luci-app-homeproxy_release-2023122200_all.ipk https://github.com/douglarek/luci-app-homeproxy/releases/download/2023122200/luci-app-homeproxy_release-2023122200_all.ipk
```
Install
```sh
opkg install /tmp/luci-app-homeproxy_release-2023122200_all.ipk
```

**JANGAN BUKA HOMEPROXY DI LUCI TERLEBIH DAHULU**

## Patch Homeproxy

**JANGAN BUKA HOMEPROXY DI LUCI TERLEBIH DAHULU**

Patch ini menggunakan custom geo dari [malikshi](https://t.me/synricha) selaku owner/maintener [IPTUNNELS](https://join.iptunnels.com/).

Install Patch 1
```sh
wget -O /etc/homeproxy/scripts/generate_client.uc https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/main/homeproxy/patch/generate_client.uc && chmod +x /etc/homeproxy/scripts/generate_client.uc
```
Install Patch 2
```sh
wget -O /etc/homeproxy/scripts/update_resources.sh https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/main/homeproxy/patch/update_resources.sh && chmod +x /etc/homeproxy/scripts/update_resources.sh
```

## Download GeoIP and GeoSite

**JANGAN BUKA HOMEPROXY DI LUCI TERLEBIH DAHULU**

Download GEOIP
```sh
./etc/homeproxy/scripts/update_resources.sh geoip
```

Download GEOSITE
```sh
./etc/homeproxy/scripts/update_resources.sh geosite
```

## Config Homeproxy

**JANGAN BUKA HOMEPROXY DI LUCI TERLEBIH DAHULU**

**JANGAN EDIT CONFIG HOMEPROXY MELALUI TERMINAL JIKA TIDAK PAHAM, GUNAKAN LUCI!**

Download config base yang IPTUNNELS sediakan untuk config homeproxy
```sh
wget -O /etc/config/homeproxy https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/main/homeproxy/homeproxy-config
```
Apply Config
```
uci commit homeproxy
```

# Restart OpenWRT Devices

Beberapa kali test mendapati error json ketika akses halaman Services Homeproxy, oleh karena itu sangat disarankan untuk restart devices.

# Node Settings 

Pengaturan Akun Node IPTUNNELS atau server lain pada Node Settings, Silahkan Edit masing-masing node Save, Jika Semua sudah diedit/hapus Node yang terpakai, Silahkan Save & Apply.

Kalian bisa mengecek log melalui Services Status, Namun Saya Lebih rekomendasikan untuk mengecek melalui terminal
```sh
tail -f /var/run/homeproxy/sing-box-c.log
```