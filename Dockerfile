FROM python:3.12-alpine

WORKDIR /app

RUN apk update \
  && apk add git \
  && git clone https://github.com/scito/extract_otp_secrets.git /app \
  && pip install protobuf qrcode colorama

CMD ["python", "src/extract_otp_secrets.py", "-p", "--printqr", "/tmp/export.txt"]
