#!/bin/bash
app=/root/Infchaind
[ -z "$1" ] && echo -e "usage:\n$0 <getinfo|getbalance|listunspent>"
[ -n "$1" ] && $app $*
