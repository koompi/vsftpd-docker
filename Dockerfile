FROM archlinux:latest
COPY libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst vsftpd-3.0.5-1-x86_64.pkg.tar.zst /
RUN pacman -Syy && yes | pacman -U /libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst /vsftpd-3.0.5-1-x86_64.pkg.tar.zst --overwrite="*" && \
    rm /libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst  /vsftpd-3.0.5-1-x86_64.pkg.tar.zst && \
    mkdir -p /etc/vsftpd && \
    useradd -m -d /srv/vsftpd vsftpd 
COPY --chmod=755 run_vsftpd.sh /usr/bin/
COPY vsftpd.conf /etc/vsftpd.conf
COPY vsftpd_pam /etc/pam.d/vsftpd
ENTRYPOINT [ "/usr/bin/run_vsftpd.sh" ]