# How to build this image

Firstly, install dependencies

```bash
sudo pacman -Sy docker
sudo usermod -aG docker "${USER}"
sudo systemctl enable --now docker.service
```

Next, reboot machine. And after reboot, clone the repo

```bash
git clone https://github.com/koompi/vsftpd-docker.git --depth 1
cd vsftpd-docker
```

Next, start building

```bash
DOCKER_BUILDKIT=1 docker build --no-cache --progress=plain -t vsftpd:latest ./
```

Finally, you will be able to use the image with tag `vsftpd:latest` in your `docker run`