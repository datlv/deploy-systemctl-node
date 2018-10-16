#!/bin/bash
set -e

usage() { echo "Usage: $0 [-s <service name>] [-f <path folder>] [-e <path file exec>]" 1>&2; exit 1; }
while getopts ":s:f:e:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ;;
        f)
            f=${OPTARG}
            ;;
        e)
            e=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${s}" ] || [ -z "${f}" ] || [ -z "${e}" ]; then
    usage
fi
echo "[Unit]
Description=Node.js ${s}

[Service]
PIDFile=/tmp/${s}.pid
User=ubuntu
Group=root
Restart=always
KillSignal=SIGQUIT
WorkingDirectory=${f}
ExecStart=${e}

[Install]
WantedBy=multi-user.target" > ${s}.service
sudo cp ${s}.service /etc/systemd/system/${s}.service
sudo systemctl enable ${s}
sudo systemctl start ${s}
sudo systemctl status ${s}
echo "done"