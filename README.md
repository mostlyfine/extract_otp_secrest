# extract_otp_secrets (Docker)

## Overview

This repository is a Docker wrapper for [scito/extract_otp_secrets](https://github.com/scito/extract_otp_secrets).
With Docker, you can extract OTP secrets without setting up a local Python environment.

## Important Notes

- `export.txt` contains data that can lead to OTP secrets. Treat it like a password.
- `.gitignore` is configured to ignore `export.txt`, but make sure you never commit it by mistake.

## Requirements

- Docker
- `make` (optional; only needed if you use the Makefile)
- [uv](https://docs.astral.sh/uv/) (optional; only needed for `make decode`)

## Usage (Recommended: Makefile)

1. Put `export.txt` in this directory.
   - Save one or more `otpauth-migration://offline?data=...` URLs exported from Google Authenticator, etc.
2. Run:

```sh
make extract
```

`make extract` runs `docker build` and then `docker run`.
At runtime it mounts the current directory read-only to `/tmp` and uses `/tmp/export.txt` as the input file.

If you update `export.txt`, you do **not** need to rebuild the image. Just run `make extract` again (the `docker build` step is usually fast due to caching).

To see available targets:

```sh
make help
```

## Create export.txt from QR Code Images

If you have screenshots of the export QR codes from Google Authenticator, decode them and append the URLs to `export.txt`:

```sh
make decode IMAGES="$HOME/Downloads/IMG_*.PNG"
```

`make decode` runs `uv run decode_qr.py $(IMAGES) >> export.txt`. Dependencies (`opencv-python-headless`) are installed automatically by uv.
It appends to `export.txt`, so running it twice with the same images duplicates lines. Delete `export.txt` before starting over.

You can also run the script directly:

```sh
uv run decode_qr.py image1.png image2.png
```

Treat the screenshots like passwords too, and delete them when you are done.

## Usage (Docker Only)

### Build

```sh
docker build -t extract_otp_secrets .
```

### Run (use Dockerfile default CMD)

Mount `export.txt` so it is available as `/tmp/export.txt` inside the container.

```sh
docker run --rm -it \
  -v "$PWD/export.txt:/tmp/export.txt:ro" \
  extract_otp_secrets
```

Default CMD in the Dockerfile:

```text
python src/extract_otp_secrets.py -p --printqr /tmp/export.txt
```

### Run (override the command)

You can override the default CMD. For example:

```sh
docker run --rm -it \
  -v "$PWD/export.txt:/tmp/input.txt:ro" \
  extract_otp_secrets \
  python src/extract_otp_secrets.py -p --printqr /tmp/input.txt
```

If you are not sure about options, show help:

```sh
docker run --rm -it extract_otp_secrets python src/extract_otp_secrets.py --help
```

## License

MIT License

---

## 概要

このリポジトリは、[scito/extract_otp_secrets](https://github.com/scito/extract_otp_secrets) を Docker で手軽に実行するためのラッパーです。

Docker を利用することで、Python 環境のセットアップなしに OTP シークレットの抽出が可能になります。

## 重要な注意事項

- `export.txt` には OTP のシークレットに繋がる情報が含まれます。取り扱いはパスワード同等として扱ってください。
- このリポジトリの `.gitignore` は `export.txt` を無視する設定ですが、誤ってコミットしないよう必ず確認してください。

## 前提

- Docker が利用できること
- `make` が利用できること（Makefile を使わない場合は不要）
- [uv](https://docs.astral.sh/uv/) が利用できること（`make decode` を使わない場合は不要）

## 使い方（推奨: Makefile）

1. このディレクトリ直下に `export.txt` を用意します。
   - Google Authenticator 等の「エクスポート」から得られる `otpauth-migration://offline?data=...` 形式の URL を、1 行または複数行で保存します。
2. 実行します。

```sh
make extract
```

`make extract` は内部的に `docker build` → `docker run` を行います。
実行時にカレントディレクトリをコンテナの `/tmp` に読み取り専用でマウントし、`/tmp/export.txt` を入力として処理します。

`export.txt` を更新した場合は **再ビルド不要** で、再度 `make extract` を実行すれば反映されます（`docker build` はキャッシュされるため通常は高速です）。

利用可能なターゲットは次で確認できます。

```sh
make help
```

## QR コード画像から export.txt を作成する

Google Authenticator のエクスポート画面の QR コードをスクリーンショットで保存した場合、次のコマンドでデコードし、URL を `export.txt` に追記できます。

```sh
make decode IMAGES="$HOME/Downloads/IMG_*.PNG"
```

`make decode` は `uv run decode_qr.py $(IMAGES) >> export.txt` を実行します。依存ライブラリ（`opencv-python-headless`）は uv が自動でインストールします。
`export.txt` への追記のため、同じ画像で 2 回実行すると行が重複します。やり直す場合は `export.txt` を削除してから実行してください。

スクリプトを直接実行することもできます。

```sh
uv run decode_qr.py image1.png image2.png
```

スクリーンショットもパスワード同等に扱い、作業後は削除してください。

## 使い方（Docker コマンドのみ）

### ビルド

```sh
docker build -t extract_otp_secrets .
```

### 実行（Dockerfile の既定 CMD を実行）

`export.txt` をコンテナ側の `/tmp/export.txt` に見えるようにマウントして実行します。

```sh
docker run --rm -it \
  -v "$PWD/export.txt:/tmp/export.txt:ro" \
  extract_otp_secrets
```

Dockerfile の既定 CMD は以下です。

```text
python src/extract_otp_secrets.py -p --printqr /tmp/export.txt
```

### 実行（コマンドを上書きして任意の入力で動かす）

既定 CMD を上書きして実行できます。たとえばホスト側の `export.txt` を読み取り専用でマウントする例は以下です。

```sh
docker run --rm -it \
  -v "$PWD/export.txt:/tmp/input.txt:ro" \
  extract_otp_secrets \
  python src/extract_otp_secrets.py -p --printqr /tmp/input.txt
```

[extract_otp_secrets](https://github.com/scito/extract_otp_secrets) のオプションや使い方が不明な場合は、ヘルプを表示してください。

```sh
docker run --rm -it extract_otp_secrets python src/extract_otp_secrets.py --help
```

## ファイル

- [Dockerfile](Dockerfile): extract_otp_secrets 用の Docker イメージ定義
- [Makefile](Makefile): `make extract` / `make decode` での実行を簡略化
- [decode_qr.py](decode_qr.py): 画像内の QR コードをデコードするスクリプト

## ライセンス

MIT License
