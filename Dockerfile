FROM jenkins/jenkins:2.303.2-jdk11
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

#Para ansible y gestión de red
RUN apt-get -y install python3-pip
RUN pip3 install --upgrade pip
RUN pip install ansible==2.10
RUN pip install netaddr
RUN pip install paramiko
RUN pip install argcomplete
RUN pip install pyats[library] jmespath fortiosapi

#Modulos de ansible
RUN ansible-galaxy install clay584.parse_genie
RUN ansible-galaxy install ansible-network.network-engine
RUN ansible-galaxy collection install fortinet.fortios

#Para git en ansible
RUN ansible-galaxy collection install lvrfrc87.git_acp
RUN git config --global user.email usermail@example.com
RUN git config --global user.name "Name Surname"

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.0 docker-workflow:1.26"