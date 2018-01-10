FROM ubuntu:trusty
MAINTAINER EasyChen <easychen@gmail.com>

# 添加商业软件源
#deb http://archive.ubuntu.com/ubuntu trusty multiverse
#deb http://archive.ubuntu.com/ubuntu trusty-updates multiverse

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-updates multiverse" >> /etc/apt/sources.list

# 先更新apt-get
RUN apt-get update && apt-get upgrade -y

# 安装unrar
RUN apt-get install unrar wget unzip -y
RUN apt-get install p7zip-full p7zip-rar -y
#RUN apt-get install p7zip-rar -y

# 安装PHP和Apache
RUN apt-get install apache2 -y
RUN apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl php5-gd -y

RUN wget https://downloads.rclone.org/rclone-current-linux-amd64.zip && unzip rclone-current-linux-amd64.zip && \
	chmod 0755 ./rclone-*/rclone && \
	cp ./rclone-*/rclone /usr/bin/ && \
	rm -rf ./rclone-*
  
# 安装WebApp
RUN rm -Rf /var/www/html

RUN apt-get install git -y
RUN git clone https://github.com/easychen/KODExplorer.git  /var/www/html


# 安装aria2
RUN apt-get install aria2 -y 

#RUN mkdir cldata
COPY aria2.conf /cldata/aria2.conf
COPY init.sh /cldata/init.sh
COPY on-complete.sh /cldata/on-complete.sh
RUN chmod +x /cldata/init.sh
RUN chmod +x /cldata/on-complete.sh

WORKDIR /var/www/html/comic


EXPOSE 80 6800

CMD /cldata/init.sh
