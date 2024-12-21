FROM jenkins/jenkins:2.462.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
#RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
COPY plugins.txt /usr/share/jenkins/plugins.txt


COPY config.xml /usr/share/jenkins/ref/jobs/my-job/config.xml
COPY jenkins-config.yaml /usr/share/jenkins/ref/jenkins-config.yaml

# Set the environment variable for JCasC to load the configuration
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/jenkins-config.yaml
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt