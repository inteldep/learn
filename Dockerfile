# 使用官方的 Ubuntu 镜像作为基础镜像
FROM ubuntu:latest

# 更新软件包列表并安装必要的软件
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    x11-utils \
    wget \
    curl \
    ca-certificates \
    tinyproxy

# 设置 VNC 密码
RUN mkdir ~/.vnc
RUN echo "Dreamsky124" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# 创建一个启动脚本
RUN echo "#!/bin/bash" >> /usr/local/bin/start-vnc.sh
RUN echo "rm -rf /tmp/.X1-lock /tmp/.X11-unix" >> /usr/local/bin/start-vnc.sh
RUN echo "tightvncserver :1 -geometry 1440x900 -depth 24" >> /usr/local/bin/start-vnc.sh
RUN echo "tail -f /root/.vnc/*.log &" >> /usr/local/bin/start-vnc.sh
RUN echo "tinyproxy -d" >> /usr/local/bin/start-vnc.sh
RUN echo "export DISPLAY=:1" >> /usr/local/bin/start-vnc.sh
RUN echo "xfce4-session &" >> /usr/local/bin/start-vnc.sh
RUN echo "sleep infinity" >> /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh

# 暴露 VNC 和 TinyProxy 的端口
EXPOSE 8900 5901 9898

# 设置默认的启动命令
CMD ["/usr/local/bin/start-vnc.sh"]
