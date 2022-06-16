#!/bin/bash

export PASV_MIN_PORT
export PASV_MAX_PORT

sed -i "s/pasv_min_port=50000/pasv_min_port=${PASV_MIN_PORT}/g" /etc/vsftpd.conf
sed -i "s/pasv_max_port=60100/pasv_max_port=${PASV_MAX_PORT}/g" /etc/vsftpd.conf

NUM=1;
USER_ARR=()

while true;
do
    local_var=FTP_USER_$NUM
    export FTP_USER_$NUM
    if [ -z "${!local_var}" ]; then break; else USER_ARR+=("${!local_var}");  fi
    NUM=$(echo $(( ${NUM}+1 )))

done

for VALUE in "${USER_ARR[@]}"
do
    USERNAME=$(echo "${VALUE}" | awk -F':' '{printf $1}')
    chown vsftpd:vsftpd /srv/vsftpd/${USERNAME}/
    echo -e "${VALUE}\n" >> /etc/vsftpd/.passwd
    echo "Created user:" $USERNAME
done

echo "Starting vsftpd..."

/usr/bin/vsftpd