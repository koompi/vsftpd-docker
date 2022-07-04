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
- `WRITE_ENABLE`: Enable or Disable write access to the server. Accepted values are `YES` or `NO` **Default is YES**
- `IMPLICIT_SSL`: Enable or Disable IMPLICIT SSL mode. Accepted values are `YES` or `NO` **Default is NO**
- `LISTEN_PORT`: Control Listening mode Ports. This requires the port mapped out, too, to work. **Default is 21**
- `PASV_MIN_PORT`: Control Passive Mode Minimum Ports. This requires the port mapped out, too, to work. **Default is 60000**
- `PASV_MAX_PORT`: Control Passive Mode Maximum Ports. This requires the port mapped out, too, to work. **Default is 60100**
- `PASV_ADDR_RESOLVE`: Enable or Disable Address Resolve to name. Accepted values are `YES` or `NO` **Default is NO**
- `PASV_ADDRESS`: Control the address or hostname of the server. **Only Required if PASV_ADDR_RESOLVE is YES**


The following mounts are used.

- /etc/ssl/certs/vsftpd.crt **Required**
- /etc/ssl/certs/vsftpd.key **Required**
- /srv/vsftpd/$USER **Required at least 1 for each user**
- /var/log **If viewing log is needed**

The following port are used.

- 21 **Required If LISTEN_PORT isn't set**
- PASV MIN/MAX Ports Range **Required**
- LISTEN_PORT **Required If set**

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

## Custom Port Explicit SSL Example

```
docker run -it \
--name vsftpd \
-v `pwd`/vsftpd.pem:/etc/ssl/certs/vsftpd.crt \
-v `pwd`/vsftpd.pem:/etc/ssl/certs/vsftpd.key \
-e PASV_MIN_PORT=1500 \
-e PASV_MAX_PORT=1600 \
-e LISTEN_PORT=10000 \
-e FTP_USER_1=isaac:'$6$C138ihonnOEQzW4f$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0' \
-v `pwd`/isaac/:/srv/vsftpd/isaac/isaac \
-p 1500-1600:1500-1600 \
-p 10000:10000 \
--restart=always \
isaacjacksonreay/vsftpd:latest
```

## Implicit Example

```
docker run -it \
--name vsftpd \
-v `pwd`/vsftpd.pem:/etc/ssl/certs/vsftpd.crt \
-v `pwd`/vsftpd.pem:/etc/ssl/certs/vsftpd.key \
-e PASV_MIN_PORT=1500 \
-e PASV_MAX_PORT=1600 \
-e FTP_USER_1=isaac:'$6$C138ihonnOEQzW4f$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0' \
-e IMPLICIT_SSL=YES \
-e LISTEN_PORT=990 \
-v `pwd`/isaac/:/srv/vsftpd/isaac/isaac \
-p 1500-1600:1500-1600 \
-p 990:990 \
--restart=always \
isaacjacksonreay/vsftpd:latest
```

## Docker-Compose Example

```
version: '3.8'
services:
  vsftp:
    image: "isaacjacksonreay/vsftpd:latest"
    ports:
      - "990:990"
      - "10000-10100:10000-10100"
    volumes:
      - /path/to/folder1:/srv/vsftpd/isaac/folder:ro
      - /path/to/vsftpd.pem:/etc/ssl/certs/vsftpd.crt:ro
      - /path/to/vsftpd.pem:/etc/ssl/certs/vsftpd.key:ro
    environment:
      - WRITE_ENABLE=NO
      - FTP_USER_1=isaac:$$6$$C138ihonnOEQzW4f$$P8ZRSQ2rU8qU.6dUyBcXHj.4piADxEL0mQskpBeBTAtjxBMobTohykzsBG8cYShgu9ciUp59AxDFvsn2asH2X0
      - PASV_MIN_PORT=10000
      - PASV_MAX_PORT=10100
      - LISTEN_PORT=990
      - IMPLICIT_SSL=YES
```

**Note:** All `**Dollar Sign**` in SHA-512 hash password must be escaped by adding another `**Dollar Sign**`

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