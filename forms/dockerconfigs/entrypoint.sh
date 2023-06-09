#!/bin/bash
# CRLF -> LF
set -ex

pip install -r /app/requirements.txt

RUN_FLUXBOX=${RUN_FLUXBOX:-yes}
RUN_XTERM=${RUN_XTERM:-yes}

case $RUN_FLUXBOX in
  false|no|n|0)
    rm -f /app/dockerconfigs/conf.d/fluxbox.conf
    ;;
esac

case $RUN_XTERM in
  false|no|n|0)
    rm -f /app/dockerconfigs/conf.d/xterm.conf
    ;;
esac

exec supervisord -c /app/dockerconfigs/supervisord.conf &
echo "The server is up and running. To enter GUI visit this link: http://localhost:8080/vnc.html"
sleep infinity