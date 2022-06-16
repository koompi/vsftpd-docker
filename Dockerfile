FROM archlinux:latest
COPY libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst vsftpd-3.0.5-1-x86_64.pkg.tar.zst /
COPY pacman.conf /etc/pacman.conf
RUN yes | pacman -Syy && \
    yes | pacman -U /libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst /vsftpd-3.0.5-1-x86_64.pkg.tar.zst --overwrite="*" && \
    yes | pacman -Scc && \
    rm /libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst  /vsftpd-3.0.5-1-x86_64.pkg.tar.zst && \
    mkdir -p /etc/vsftpd /srv/vsftpd && \
    useradd -d /srv/vsftpd vsftpd && \
    chown vsftpd:vsftpd /srv/vsftpd && \
    echo 'vsftpd: ALL\n' > /etc/hosts.allow
COPY --chmod=755 run_vsftpd.sh /usr/bin/
COPY vsftpd.conf /etc/vsftpd.conf
COPY vsftpd_pam /etc/pam.d/vsftpd
ENTRYPOINT [ "/usr/bin/run_vsftpd.sh" ]