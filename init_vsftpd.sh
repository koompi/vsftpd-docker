#!/bin/bash

export PASV_MIN_PORT
export PASV_MAX_PORT
export PASV_ADDR_RESOLVE
export PASV_ADDRESS
export IMPLICIT_SSL
export WRITE_ENABLE
export LISTEN_PORT

[[ ! -z "${PASV_MIN_PORT}" ]] && sed -i "s/pasv_min_port=60000/pasv_min_port=${PASV_MIN_PORT}/g" /etc/vsftpd.conf
[[ ! -z "${PASV_MAX_PORT}" ]] && sed -i "s/pasv_max_port=60100/pasv_max_port=${PASV_MAX_PORT}/g" /etc/vsftpd.conf
[[ ! -z "${PASV_ADDRESS}" ]] && echo -e "pasv_address=${PASV_ADDRESS}\n" >> /etc/vsftpd.conf
[[ ! -z "${LISTEN_PORT}" ]] && sed -i "s/listen_port=21/listen_port=${LISTEN_PORT}/g" /etc/vsftpd.conf
[[ "${IMPLICIT_SSL}" == "YES" ]] && sed -i "s/implicit_ssl=NO/implicit_ssl=YES/g" /etc/vsftpd.conf
[[ "${PASV_ADDR_RESOLVE}" == "YES" ]] && sed -i "s/pasv_addr_resolve=NO/pasv_addr_resolve=YES/g" /etc/vsftpd.conf
[[ "${WRITE_ENABLE}" == "NO" ]] && sed -i "s/write_enable=YES/write_enable=NO/g" /etc/vsftpd.conf

NUM=1;
USER_ARR=()

while true;
do
    local_var=FTP_USER_$NUM
    export FTP_USER_$NUM
    if [ -z "${!local_var}" ]; then break; else USER_ARR+=("${!local_var}");  fi
    NUM=$(echo $(( ${NUM}+1 )))

done

echo -e "\nCreating Users...\n"

for VALUE in "${USER_ARR[@]}"
do
    USERNAME=$(echo "${VALUE}" | awk -F':' '{printf $1}')
    chown vsftpd:vsftpd /srv/vsftpd/${USERNAME}/
    echo -e "${VALUE}\n" >> /etc/vsftpd/.passwd
    echo "User '"$USERNAME"' Created"
done

trap "pgrep vsftpd | xargs kill -9" SIGHUP SIGQUIT SIGABRT SIGINT SIGTERM SIGCHLD

echo -e "\nStarting Very Secure File Transfer Protocol Daemon...\n"

/usr/bin/vsftpd