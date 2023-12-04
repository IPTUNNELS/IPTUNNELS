**Table of Contents**

- [OpenClash Meta Kernel](#openclash-meta-kernel)
- [Features](#features)
- [Setting Openclash App](#setting-openclash-app)
- [Global Setting](#global-setting)
  - [Operation Mode](#operation-mode)
  - [DNS Setting](#dns-setting)
  - [Kernel Meta](#kernel-meta)
	- [Official](#official)
  - [Meta Setting](#meta-setting)
    - [GEOIP](#geoip)
    - [GEOSITE](#geosite)
- [Setting Config](#setting-config)
  - [Import Fallback.yaml](#import-fallbackyaml)
  - [Import Proxy Provider](#import-proxy-provider)
  - [Import Rule Provider](#import-rule-provider)
- [Test Adblock 99%](#test-adblock-99)

# OpenClash Meta Kernel

OpenClash Config untuk VVIP IPTUNNELS

- [Buy VVIP IPTUNNELS](https://join.iptunnels.com)
- [Join Telegram](https://t.me/+O08-QK6VNXU5NzU1)
- [Requests Rules](https://github.com/IPTUNNELS/IPTUNNELS/issues/new/choose)

# Features

- Support Multi-WAN/Modem
- Menggunakan Custom Geosite!
- Support Pisah Traffic!
- Support GEOSITE Adblock, Privacy & P0rn.
- Support GEOSITE GAME
- Support Filtering Port Games
- Support GEOSITE INDO
- Support GEOSITE STREAMING
- Support GEOSITE SOSMED
- Support Direct/Bypass
- More Security with Block Malicious

# Setting Openclash App

Setelah mengedit config Fallback.yaml dan setiap file pada folder proxy_provider serta rule_direct.yaml pada folder rule_provider maka kita akan setting openclash via luCI. Silahkan Login LuCI dan masuk ke Services > Openclash

# Global Setting

Hasil settingan pada global setting akan meng-overide settingal awal pada file Fallback.yaml.

## Operation Mode

- Operation Mode **SWITCH PAGE TO FAKE IP MODE** terlebih dahulu.
- Ceklist/centang opsi sesuai gambar berikut:

[![Gambar Operation Mode](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/operationmode.jpg "Operation Mode")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/operationmode.jpg)

## DNS Setting

- Ceklist/Centang sesuai gambar:

[![Gambar Setting DNS](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/dnssetting-1.jpg "Setting DNS")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/dnssetting-1.jpg)
[![Gambar Setting DNS](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/dnssetting-2.jpg "Setting DNS")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/dnssetting-2.jpg)


## Kernel Meta

### Official

- Download kernel [Meta Official](https://github.com/MetaCubeX/Clash.Meta/releases/latest)
- Pilih file bernama **Clash.Meta-linux-arm64-v1.xx.x.gz**
- Upload file tersebut sebagai **Upload File Type : [Meta] Core File**

[![Gambar Meta Core](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metacore.jpg "Meta Core")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metacore.jpg)


## Meta Setting

Disini akan menggunakan Meta kernel jadi harus mengatur meta setting.

[![Gambar Setting Meta](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-1.jpg "Setting Meta")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-1.jpg)

[![Gambar Setting Meta](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-2.jpg "Setting Meta")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-2.jpg)

```
force-domain:
#  - '+'
- '+.netflix.com'
- '+.nflxvideo.net'
- '+.amazonaws.com'
- '+.media.dssot.com'
```

```
sniff:
  # TLS default 443
  TLS:
    ports: [443, 182-183, 853, 8443]

  # default 80
  HTTP:
    # Ports to sniff
    ports: [80, 8080-9090]
     # Whether to use sniffing results as actual access
    override-destination: true
```
[![Gambar Setting Meta](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-5.jpg "Setting Meta")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-5.jpg)

```
skip-sni:
  - '+.apple.com'
  - 'Mijia Cloud'
  - '+.jd.com'
```

### GEOIP

Wajib menggunakan GeoIP.dat silahkan setting sesuai gambar

```sh
https://raw.githubusercontent.com/rfxcll/v2ray-rules-dat/release/GeoIP.dat
```

[![Gambar Setting GeoIP](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-3.jpg "Setting GeoIP")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-3.jpg)

Jika belum ada GeoIP pada folder `/etc/openclash/` maka silahkan download terlebih dahulu.

```sh
curl -o /etc/openclash/GeoIP.dat https://raw.githubusercontent.com/rfxcll/v2ray-rules-dat/release/GeoIP.dat
chmod 744 /etc/openclash/GeoIP.dat
```

### GEOSITE

Karena semua rule kami pindahkan ke GeoSite.dat maka perlu setting `Custom GeoSite URL` menggunakan hasil compile custom list yang telah kami sediakan.

```sh
https://raw.githubusercontent.com/rfxcll/v2ray-rules-dat/release/GeoSite.dat
```

Perhatikan gambar berikut.

[![Gambar Setting GeoSite](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-4.jpg "Setting GeoSite")](https://raw.githubusercontent.com/rfxcll/open_meta/main/images/metasetting-4.jpg)

WAJIB menggunakan GeoSite custom kami. Silahkan download terlebih dahulu.

```sh
curl -o /etc/openclash/GeoSite.dat https://raw.githubusercontent.com/rfxcll/v2ray-rules-dat/release/GeoSite.dat
chmod 744 /etc/openclash/GeoSite.dat
```

# Setting Config

Untuk pengaturan config dan proxy_provider silahkan cek repo kami

- [Cara mengisi akun](https://github.com/rfxcll/open_clash#cara-mengisi-akun)
- [Edit Proxy Provider](https://github.com/rfxcll/open_clash#edit-files-proxy-provider)

## Import Fallback.yaml

Setelah melakukan pengeditan Fallback.yaml maka kita import Fallback.yaml via Manage Config dengan memilih **Upload File Type : Config File**. Khusus Fallback.yaml jangan import/edit melalui winscp/sftp.
[![Gambar Upload Config](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/config-upload.jpg "Upload Config")](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/config-upload.jpg)

## Import Proxy Provider

Jika Semua file pada folder proxy_provider yang terdiri dari Akun-ID.yaml, Akun-SG.yaml, Akun-GAME.yaml yang sudah diisi dengan akun maka selanjutnya import file-file tersebut pada **Upload File Type : Proxy Provider File**.
[![Gambar Upload Proxy](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/proxy-upload.jpg "Upload Proxy")](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/proxy-upload.jpg)

## Import Rule Provider

Traffic direct/bypass sudah disikan ke rule_direct.yaml maka bisa langsung import semua files pada folder rule_provider pada **Upload File Type : Rule Provider File**.
[![Gambar Upload Rule](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/rule-upload.jpg "Upload Rule")](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/rule-upload.jpg)

# Test Adblock 99%

Silahkan test rules adblock melalui [https://d3ward.github.io/toolz/adblock.html](https://d3ward.github.io/toolz/adblock.html)

Bypass pada **pagead2(dot)googlesyndication(dot)com** akan mengurangi nilai test.

Hasil test:
[![Gambar Hasil Test d3ward](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/d3ward.jpg "Hasil Test d3ward")](https://raw.githubusercontent.com/rfxcll/open_clash/main/assets/d3ward.jpg)