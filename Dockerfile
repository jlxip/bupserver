FROM ubuntu:jammy

RUN apt update && apt -y upgrade && apt install -y bup openssh-server sudo
RUN apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN useradd -m user

VOLUME ["/etc/ssh", "/home/user/.bup"]

EXPOSE 8080
EXPOSE 22

COPY start.sh /start.sh
COPY sshd_config /.sshd_config
CMD ["/start.sh"]
