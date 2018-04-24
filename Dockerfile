FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
    openssh-server \
    python \
    ruby \
    wget \
    net-tools \
    curl \
    sudo

RUN curl https://omnitruck.chef.io/install.sh | bash -s -- -P chefdk -c stable -v 2.3.4
RUN useradd -ms /bin/bash chef && echo "chef:chef" | chpasswd && adduser chef sudo
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 1-1000
CMD ["/usr/sbin/sshd", "-D"]
RUN export TERM=xterm
