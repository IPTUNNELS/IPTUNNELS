# IPTUNNELS
Unleash Unlimited Internet with Our Universal Proxy Service! Experience fast and secure internet access anywhere with our Universal Proxy Service powered by sing-box. Connect to servers worldwide for the best internet speeds. Choose the perfect protocol (Trojan, Vmess, Vless) for your needs. Enjoy seamless connectivity with various transport options (Websocket, gRPC, HttpUpgrade). Select the ideal subscription length for you (monthly to yearly). Rest assured your data is secure with strong encryption

## Features
- Powered By sing-box
- Support SNI dan CDN Cloudflare
- Support Port HTTPS/TLS 443,2053,2083,2087,2096,8443
- Support Port HTTP/Non TLS 80,8080,8880,2052,2082,2086,2095
- Support Layanan Video On Demand (VOD) Region Indo dan berbagai negara.
- Requests Routing Traffic Layanan Tertentu.
- Compatible dengan aplikasi client seperti Clash/Clash.Meta, V2ray-core, Xray-core.
- Support Wildcard subdomain server.
- Transport Websocket support Wildcard URI Path, contoh */put-any-path-here/buy-vless-ws-pm-telegram-at-synricha* menjadi  */kuota-habis/buy-vless-ws-pm-telegram-at-synricha* atau  */kuota-habis/admin-ganteng-banget/buy-vless-ws-pm-telegram-at-synricha*
- Support cek status akun secara berkala.

# Coba Gratis Trial VVIP IPTUNNELS

Coba GRATIS Akun Trial IPTUNNELS & Rasakan Sensasi Internet Ngebut Tanpa Batas!

- [x] **[Akses Trial Disini](https://www.iptunnels.com/buy/)**

🔥 Penasaran dengan performa layanan IPTUNNELS? Jangan cuma dengar dari orang lain, buktikan sendiri! Kami menyediakan akun trial GRATIS untuk kamu coba sebelum memutuskan untuk berlangganan. 🔥

**💨 Pilih Protokol Favoritmu:**

- [x] Trojan Websocket
- [x] Trojan HTTPupgrade
- [x] Trojan gRPC
- [x] Vmess Websocket
- [x] Vmess HTTPupgrade
- [x] Vmess gRPC
- [x] Vless Websocket
- [x] Vless HTTPupgrade
- [x] Vless gRPC
- [x] Vless Reality
- [x] Hysteria2

**🎁 Nikmati Kemudahan & Kebebasan:**

- **Tanpa Biaya:** Coba semua protokol secara gratis tanpa perlu keluar uang sepeser pun.
- **Update Otomatis:** Akun trial akan diperbarui setiap 5 menit setelah penggunaan mencapai 1GB, jadi kamu bisa terus mencoba tanpa batas!
- **Mudah Digunakan:** Tinggal salin konfigurasi, lalu import ke aplikasi VPN pilihanmu.

**💡 Tips: 💡**

- Akun trial akan otomatis diperbarui setiap 5 menit setelah penggunaan mencapai 1GB.
- Jika akun trial tidak dapat digunakan, coba akun trial lainnya atau tunggu beberapa saat hingga akun diperbarui.
- Jika mengalami kesulitan, jangan ragu untuk menghubungi kami melalui [@synricha](https://t.me/synricha), atau melalui grup kami [@iptunnelschat](https://t.me/iptunnelschat)


- [x] **[Akses Trial Disini](https://www.iptunnels.com/buy/)**

## Support Wildcard Subdomain
### How to Use Wildcard
list wildcard = **zoom.us**

bug = *support*.**zoom.us**

domain server = **abcd.iptunnels.com**

Bug Wildcard = *support.zoom.us*.**abcd.iptunnels.com**

Maka cara mengatur akun jadi begini:

- Server Address    : support.zoom.us
- Request Host      : support.zoom.us.abcd.iptunnels.com
- SNI/Servername    : support.zoom.us.abcd.iptunnels.com

Contoh wildcard trojan ws vvip iptunnels di clash/meta/mihomo

```yaml
- name: Trojan-WS-HTTPS-CDN
  type: trojan
  server: support.zoom.us
  port: 443
  password: IPTUNNELS-PASSWORD
  network: ws
  sni: support.zoom.us.abcd.iptunnels.com
  skip-cert-verify: true
  udp: true
  ws-opts:
    path: /buy-trojan-ws-pm-telegram-at-synricha
    headers:
      Host: support.zoom.us.abcd.iptunnels.com
```

Contoh wildcard vmess ws vvip iptunnels di clash/meta/mihomo

```yaml
- name: Vmess-WS-HTTPS-CDN
  type: vmess
  server: support.zoom.us
  port: 443
  uuid: IPTUNNELS-UUID
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  skip-cert-verify: true
  servername: support.zoom.us.abcd.iptunnels.com
  network: ws
  ws-opts:
    path: /buy-vmess-ws-pm-telegram-at-synricha
    headers:
      Host: support.zoom.us.abcd.iptunnels.com
```

Contoh wildcard vless ws vvip iptunnels di clash/meta/mihomo

```yaml
- name: Vless-WS-HTTPS-CDN
  type: vless
  server: support.zoom.us
  port: 443
  uuid: IPTUNNELS-UUID
  network: ws
  servername: support.zoom.us.abcd.iptunnels.com
  skip-cert-verify: true
  udp: true
  tls: true
  ws-opts:
    path: /buy-vless-ws-pm-telegram-at-synricha
    headers:
      Host: support.zoom.us.abcd.iptunnels.com
```

Jika Mode HTTPS 443 tidak work maka gunakan mode HTTP 80
### Wildcard Proxied CDN Cloudflare
- game.naver.com
- int.vidio.com
- staging.vidio.com
- vidio.com
- brevo.com
- email1.vidio.com
- email2.vidio.com
- email3.vidio.com
- zoom.us
- zoominfo.com
- zoomgov.com
- lipcon.com
- ruangguru.com
- data.mt
- spotify.com
- fb.com
- q4inc.com
- clova.line.me
- shopeemobile.com
- appsflyer.com
- customlinks.appsflyer.com
- netflix.com
- tickets.netflix.com
- midtrans.com
- medallia.com
- gopay.co.id
- byu.id
- viu.com
- duniagames.co.id
- udemy.com
- skillacademy.com
- webex.com
- duolingo.com
- cloudflare.com
- cloudflare.net
- pacloudflare.com
- api.letsencrypt.org
- cdnjs.com
- jsdelivr.com
- jsdelivr.net
- skul.id
- tiktokv.com
- vuclip.com
- cvs.freefiremobile.com
- onetrust.com
- grabtaxi.com
- klikindomaret.com
- cdn
- com
- net
- org
- co
- us
- ac.id
- go.id
- co.id
- id
- edu
- gov
- io
- ai
- gg
- me
- uk
- de
- br
- jp
- it
- fr

### Wildcard Non-Proxied CDN Cloudflare
- sni
- instagram.com
- scorecardresearch.com
- iflix.com
- pubgmobile.com
- byteoversea.com
- google.com
- googlesyndication.com
- googleadservices.com
- googlevideo.com
- googlehosted.com
- ggpht.com
- tokopedia.net
- tokopedia.com
- shopee.co.id
- tiktokcdn.com
- awsglobalaccelerator.com
- akamaized.net
- edgesuite.net
- edgekey.net
- cloudfront.net
- bytegeo.akadns.net
- bytedance.map.fastly.net