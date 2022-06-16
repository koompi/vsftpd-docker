# VSFTPD Docker Image

This is a micro-service image for VSFTPD.

## Important Note
- This is built for production only. Check Options sections
- Local User, Passive mode, Log, Write, DotFile, and SSL is enabled by default. 
- Chmod, Anon is not enabled
- TCP Wrapper is not compiled in. 

## Options

The following environment variables are used.

- `FTP_USER_*`: Adds multiple users. Value must be in the form of `username:'hash'`. This requires a hashed password such as the ones created with `mkpasswd -m sha-512`. **Required at least 1**
- `PASV_MIN_PORT`: Control Passive Mode Minimum Ports. This requires the port mapped out, too, to work. *Default is 50000*
- `PASV_MAX_PORT`: Control Passive Mode Maximum Ports. This requires the port mapped out, too, to work. *Default is 60100*

The following mounts are used.

- /etc/ssl/certs/vsftpd.crt **Required**
- /etc/ssl/certs/vsftpd.key **Required**
- /srv/vsftpd/$USER **Required at least 1 for each user**

The following port are used.

- 20 **Required**
- 21 **Required**
- PASV MIN/MAX Ports Range **Required**

## Usage Examples

```
docker run -it \
--name vsftpd \
-v `pwd`/vsftpd.pem:/etc/ssl/certs/vsftpd.crt \
-v `pwd`/vsftpd.pem:/etc/ssl/certs/vsftpd.key \
-e PASV_MIN_PORT=1500 \
-e PASV_MAX_PORT=1600 \
-e FTP_USER_1=isaac:'$6$C138ihonnOEQzW4f$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0' \
-v `pwd`/isaac/:/srv/vsftpd/isaac/isaac \
-p 20-21:20-21 \
-p 1500-1600:1500-1600 \
--restart=always \
isaacjacksonreay/vsftpd:latest
```

## Multiple Users Example

```
...
-e FTP_USER_1=isaac:'$6$C138ihonnOEQzW4f$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0' \
-e FTP_USER_2=adam:'$6$C138ihonnOEQzW4f$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0' \
-e FTP_USER_3=abraham:'$6$C138ihonnOEQzW4f$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0' \
-v `pwd`/isaac/:/srv/vsftpd/isaac/isaac \
-v `pwd`/adam/:/srv/vsftpd/adam/adam \
-v `pwd`/abraham/:/srv/vsftpd/abraham/abraham \
...
```

## Development Note

Since certificate is always needed, you can create a self-signed for development with guide below and get a real certificate when hosting public. 

```
[user@server ~]$ openssl req -x509 -nodes -newkey rsa:2048 -keyout vsftpd.pem -out vsftpd.pem -days 3650
Generating a RSA private key
.....+++++
................+++++
writing new private key to 'vsftpd.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:JP   # country code
State or Province Name (full name) []:Hiroshima    # State
Locality Name (eg, city) [Default City]:Hiroshima  # city
Organization Name (eg, company) [Default Company Ltd]:GTS  # company
Organizational Unit Name (eg, section) []:Server World     # department
Common Name (eg, your name or your server's hostname) []:www.srv.world  # server's FQDN
Email Address []:root@srv.world   # admin's email

[user@server ~]$ chmod 600 vsftpd.pem
```

For more information, check https://www.server-world.info/en/note?os=CentOS_Stream_8&p=ftp&f=5

## Logs

To get the FTP logs mount `/var/log` outside of the container. For example add `-v /var/log/ftp:/var/log` to your `docker run ...` command.