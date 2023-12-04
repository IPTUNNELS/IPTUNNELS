![OpenClash](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/openclash.png "OpenClash")
**Table of Contents**

- [OpenClash Meta Kernel](#openclash-meta-kernel)
- [Features](#features)
- [Setting Openclash App](#setting-openclash-app)
- [Overwrite Settings](#overwrite-settings)
- [Plugin Settings](#)
  - [Operation Mode](#operation-mode)
  - [DNS Setting](#dns-setting)
	- [Preselease-Alpha](#preselease-alpha)
  - [IPv6 Setting](#ipv6-settings)
  - [GEO Update](#geo-update)
  - [Version Update](#version-update)
- [Setting Config](#setting-config)
  - [Edit config-metacubeX.yaml](#edit-config-metacubexyaml)
  - [Import config-metacubeX.yaml](#import-config-metacubexyaml)
  - [Import Proxy Provider](#import-proxy-provider)
  - [Import Rule Provider](#import-rule-provider)

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

Setelah mengedit config config-metacubeX.yaml dan setiap file pada folder proxy_provider serta rule_direct.yaml pada folder rule_provider maka kita akan setting openclash via luCI. Silahkan Login LuCI dan masuk ke Services > Openclash

# Overwrite Settings

Jangan Rubah apapun pada settingan ini, Jika pernah dirubah maka lakukan restore terlebih dahulu.

![Overwrite Settings](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/config-metacubeX.png "Overwrite Settings")

## Operation Mode

- Operation Mode **SWITCH PAGE TO FAKE IP MODE** terlebih dahulu.
- Ceklist/centang opsi sesuai gambar berikut:

![Gambar Operation Mode](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/switch-fake-ip.png "Operation Mode")

## DNS Setting

- Ceklist/Centang sesuai gambar:

![Gambar Setting DNS](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/dns-settings.png "Setting DNS")

## Preselease-Alpha

- Download kernel [MetacubeX](https://github.com/MetaCubeX/mihomo/releases/tag/Prerelease-Alpha)
- Pilih file bernama **mihomo-linux-arm64-alpha-abcdef.gz**
- Upload file tersebut sebagai **Upload File Type : [Meta] Core File**

![Gambar Meta Core](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/kernel-metacubex.png "Meta Core")

## IPv6 Settings

Mengaktifkan IPv6 Koneksi, sangat membantu untuk menghindari Captcha dan traffic yang rendah membuat lebih cepat.

![Gambar IPv6 Settings](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/ipv6-settings.png "IPv6 Settings")


## GEO Update

Pengaturan GeoIP dan GeoSite untuk penggunaan routing rules.

![Gambar Setting GEO Update](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/geo-update.png "Setting GEO Update")

Wajib menggunakan GeoIP.dat silahkan setting sesuai gambar

```sh
https://github.com/malikshi/v2ray-rules-dat/releases/latest/download/geoip.dat
```

Jika belum ada GeoIP pada folder `/etc/openclash/` maka silahkan download terlebih dahulu.

```sh
curl -o /etc/openclash/GeoIP.dat https://github.com/malikshi/v2ray-rules-dat/releases/latest/download/geoip.dat
chmod 744 /etc/openclash/GeoIP.dat
```

Karena semua rule kami pindahkan ke GeoSite.dat maka perlu setting `Custom GeoSite URL` menggunakan hasil compile custom list yang telah kami sediakan.

```sh
https://github.com/malikshi/v2ray-rules-dat/releases/latest/download/geosite.dat
```

WAJIB menggunakan GeoSite custom kami. Silahkan download terlebih dahulu.

```sh
curl -o /etc/openclash/GeoSite.dat https://github.com/malikshi/v2ray-rules-dat/releases/latest/download/geosite.dat
chmod 744 /etc/openclash/GeoSite.dat
```

## Version Update

Silahkan Gunakan Versi Developer alias Alpha untuk penggunaan clash, clash_tun, clash_meta dan versi dari OpenClash.

![Gambar Setting Version Update](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/version-update.png "Setting Version Update")

# Setting Config

Untuk pengaturan config dan proxy_provider silahkan cek repo kami

- [Cara mengisi akun](https://github.com/IPTUNNELS/IPTUNNELS/tree/main/clash.meta)

## Edit config-metacubeX.yaml

Melakukan edit pada config-metacubeX.yaml sebelum import ke OpenClash. Perubahan yang harus dilakukan untuk menyesuaikan Devices Interfaces modem anda.

Update Device Interface Modem, [Lihat baris 70-79](https://github.com/IPTUNNELS/IPTUNNELS/blob/e10c743b555b78926c9040e0f8278461060137d8/OpenClash/config-metacubeX.yaml#L70-L79)
```yaml
- name: Direct WAN A
  type: select
  interface-name: INTERFACE-WAN-A
  proxies:
  - DIRECT
- name: Direct WAN B
  type: select
  interface-name: INTERFACE-WAN-B
  proxies:
  - DIRECT
```

Update Interface Name pada `- DNS#INTERFACE-WAN` pada [baris 263-265](https://github.com/IPTUNNELS/IPTUNNELS/blob/e10c743b555b78926c9040e0f8278461060137d8/OpenClash/config-metacubeX.yaml#L263-L265).
```yaml
  default-nameserver:
  - 9.9.9.9#INTERFACE-WAN
  - 1.1.1.1#INTERFACE-WAN
```
Update juga `- DNS#INTERFACE-WAN` pada bagian nameserver dan fallback. Hanya lakukan perubahan pada DNS yang ada kata **#INTERFACE-WAN**

## Import config-metacubeX.yaml

Setelah melakukan pengeditan config-metacubeX.yaml maka kita import config-metacubeX.yaml via Manage Config dengan memilih **Upload File Type : Config File**. Khusus config-metacubeX.yaml jangan import/edit melalui winscp/sftp.
![Gambar Upload Config](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/config-metacubeX.png "Upload Config")

## Import Proxy Provider

Jika Semua file pada folder proxy_provider yang terdiri dari Akun-ID.yaml, Akun-SG.yaml, Akun-GAME.yaml yang sudah diisi dengan akun maka selanjutnya import file-file tersebut pada **Upload File Type : Proxy Provider File**.
![Gambar Upload Proxy](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/proxy-provider.png "Upload Proxy")

## Import Rule Provider

Traffic direct/bypass sudah disikan ke rule_direct.yaml maka bisa langsung import semua files pada folder rule_provider pada **Upload File Type : Rule Provider File**.
![Gambar Upload Rule](https://raw.githubusercontent.com/IPTUNNELS/IPTUNNELS/images/rule-provider.png "Upload Rule")