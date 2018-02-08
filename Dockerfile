FROM openjdk:8-jdk

MAINTAINER Carlos Sanchez <carlos@apache.org>

ENV JENKINS_SWARM_VERSION 3.9
ENV HOME /home/jenkins-slave

ENV DOCKER_ARCH docker-17.09.1-ce.tgz
RUN curl -o /tmp/$DOCKER_ARCH https://download.docker.com/linux/static/stable/x86_64/$DOCKER_ARCH \
        && tar -zxvf /tmp/$DOCKER_ARCH -C /usr/local/bin/ --strip-components=1 docker/docker \
        && rm /tmp/$DOCKER_ARCH

# install netstat to allow connection health check with
# netstat -tan | grep ESTABLISHED
RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*

RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

USER jenkins-slave
VOLUME /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]
