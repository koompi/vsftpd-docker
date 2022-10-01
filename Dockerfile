FROM archlinux:latest
STOPSIGNAL 9
COPY libnsl-2.0.0-2-x86_64.pkg.tar.zst libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst vsftpd-3.0.5-1-x86_64.pkg.tar.zst /
RUN yes | pacman -U /{libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst,libnsl-2.0.0-2-x86_64.pkg.tar.zst,vsftpd-3.0.5-1-x86_64.pkg.tar.zst} --overwrite="*" && \
    rm /{libpam_pwdfile-1.0-2-x86_64.pkg.tar.zst,libnsl-2.0.0-2-x86_64.pkg.tar.zst,vsftpd-3.0.5-1-x86_64.pkg.tar.zst} && \
    mkdir -p /etc/vsftpd && \
    useradd -m -d /srv/vsftpd vsftpd && \
    echo -e "auth required pam_pwdfile.so pwdfile /etc/vsftpd/.passwd\naccount required pam_permit.so" > /etc/pam.d/vsftpd
COPY --chmod=755 init_vsftpd.sh /usr/bin/
COPY vsftpd.conf /etc/vsftpd.conf
ENTRYPOINT [ "/usr/bin/init_vsftpd.sh" ]