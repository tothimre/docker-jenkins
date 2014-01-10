FROM ubuntu:12.04
MAINTAINER Allan Espinosa "allan.espinosa@outlook.com"

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe >> /etc/apt/sources.list
RUN apt-get update && apt-get clean
RUN apt-get install -q -y openjdk-7-jre-headless && apt-get clean
ADD http://mirrors.jenkins-ci.org/war/1.546/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ADD run /usr/local/bin/run
RUN useradd -m jenkins

RUN chown jenkins /home/jenkins/.jenkins
RUN exec su jenkins -c "java -jar /opt/jenkins.war"
RUN wget http://localhost:8080/jnlpJars/jenkins-cli.jar

RUN java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin  checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit
RUN java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart
RUN curl https://raw.github.com/sebastianbergmann/php-jenkins-template/master/config.xml |  java -jar jenkins-cli.jar -s http://localhost:8080 create-job php-template
RUN wget http://localhost:8080/exit

EXPOSE 8080
VOLUME ["/home/jenkins/.jenkins"]
CMD /usr/local/bin/run
