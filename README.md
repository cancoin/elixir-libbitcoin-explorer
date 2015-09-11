# Libbitcoin Explorer

Simple port wrapper for [libbitcoin explorer](https://github.com/libbitcoin/libbitcoin-explorer)

## Quick start

Install [libbitcoin explorer](https://raw.githubusercontent.com/libbitcoin/libbitcoin-explorer/v2.1.0/install.sh) (bx)

```
curl -O https://raw.githubusercontent.com/libbitcoin/libbitcoin-explorer/v2.1.0/install.sh
bash install.sh --build-boost --build-icu --prefix=/usr/local
```

You must have libbitcoin-explorer (bx) in your PATH

## Fetch dependancies and run an Elixir console

```
mix deps.get
iex -S mix
```

## Example

```
➜  libbitcoin_explorer git:(master) ✗ iex -S mix
Erlang/OTP 18 [erts-7.0] [source-4d83b58] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.1.0-dev) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Libbitcoin.Explorer.address_decode("1HjFSwyWZrdwTXowHMHVc9E1uAHj2cSkvd") 
{:ok,
 %{"wrapper" => %{"checksum" => "2876689768",
     "payload" => "b77f8b01ec4d27f6694328b86bb18b896a06acd5",
     "version" => "0"}}}
```

## Supported commands

```
[✓] address-decode
[✓] address-embed
[✓] address-encode
[✓] address-validate
[x] base16-decode
[x] base16-encode
[✓] base58-decode
[✓] base58-encode
[✓] base58check-decode
[✓] base58check-encode
[x] base64-decode
[x] base64-encode
[✓] bitcoin160
[✓] bitcoin256
[✓] btc-to-satoshi
[ ] cert-new
[ ] cert-public
[ ] ec-add
[ ] ec-add-secrets
[N] ec-lock
[ ] ec-multiply
[ ] ec-multiply-secrets
[ ] ec-new
[ ] ec-to-address
[ ] ec-to-public
[ ] ec-to-wif
[ ] ec-unlock
[x] fetch-balance
[x] fetch-header
[x] fetch-height
[x] fetch-history
[x] fetch-public-key
[x] fetch-stealth
[x] fetch-tx
[x] fetch-tx-index
[x] fetch-utxo
[✓] hd-new
[✓] hd-private
[✓] hd-public
[✓] hd-to-address
[✓] hd-to-ec
[✓] hd-to-public
[✓] hd-to-wif
[x] help
[ ] input-set
[ ] input-sign
[ ] input-validate
[ ] message-sign
[ ] message-validate
[ ] mnemonic-new
[ ] mnemonic-to-seed
[ ] qrcode
[ ] ripemd160
[ ] satoshi-to-btc
[ ] script-decode
[ ] script-encode
[ ] script-to-address
[ ] seed
[ ] send-tx
[ ] send-tx-node
[ ] send-tx-p2p
[ ] settings
[ ] sha160
[ ] sha256
[ ] sha512
[ ] stealth-decode
[ ] stealth-encode
[ ] stealth-public
[ ] stealth-secret
[ ] stealth-shared
[✓] tx-decode
[ ] tx-encode
[ ] tx-sign
[ ] uri-decode
[ ] uri-encode
[ ] validate-tx
[ ] watch-address
[ ] watch-tx
[ ] wif-to-ec
[ ] wif-to-public
[ ] wrap-decode
[ ] wrap-encode
```
