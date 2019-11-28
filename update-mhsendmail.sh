#!/usr/bin/env sh

curl -LsSo mhsendmail "https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64"
chmod +x mhsendmail

for phpver in 5.6 7.0 7.1 7.2 7.3 7.4; do
    mkdir -p "$phpver/scripts/usr/local/lib"
    cp -a mhsendmail "$phpver/scripts/usr/local/lib/"
done
