#FROM image-registry.openshift-image-registry.svc:5000/openshift/jenkins@sha256:e0a054d0a2e3088eb9ac6c65149fec386fefcf2aacc7181fa806cf2fad190a4c as jenkins
#FROM quay.io/openshift/origin-jenkins@sha256:a7c28e11e20139e69b1a39e0c63a440d7d973f1058fda5e1b862ad7cf937410b as jenkins
FROM quay.io/openshift/origin-jenkins:latest as jenkins

ARG JENKINS_VERSION=2.462.1

USER root
#RUN yum install -y jenkins-plugin-openshift openshift-origin-cartridge-jenkins
#RUN yum update -y
COPY run_ucb.sh /usr/local/bin/run.sh
RUN cp -p /usr/libexec/s2i/run /usr/libexec/s2i/run.orig
RUN rm -f /usr/libexec/s2i/run
COPY run_ucb.sh /usr/libexec/s2i/run
RUN chmod 755 /usr/libexec/s2i/run && chmod 755 /usr/local/bin/run.sh
# Installing JDKs
#RUN mkdir -p /data/jdk
#RUN cd /data/jdk && wget --quiet --no-check-certificate https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && tar -zxvf jdk-17_linux-x64_bin.tar.gz && rm -f jdk-17_linux-x64_bin.tar.gz && ln -s jdk-17* jdk-17-latest
#RUN chmod -R 777 /data/jdk

#RUN mkdir -p /usr/lib/jvm
#RUN cd /usr/lib/jvm && wget --quiet --no-check-certificate https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && tar -zxvf jdk-17_linux-x64_bin.tar.gz && rm -f jdk-17_linux-x64_bin.tar.gz && ln -s jdk-17* jdk-17-latest
#RUN chmod -R 777 /usr/lib/jvm

# Install Corretto Java JDK (from Amazon repo, more arch independent)
#RUN rpm -i https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.rpm
#RUN ln -s /usr/lib/jvm/java-17-amazon-corretto /usr/lib/jvm/java-17; ln -s /usr/lib/jvm/java-17 /usr/lib/jvm/java-latest
#ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
#RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-amazon-corretto/bin/java 1

#RUN yum install -y java-17-openjdk java-17-openjdk-devel java-17-openjdk-headless
RUN yum install -y java-17-openjdk
RUN yum install -y java-17-openjdk-devel
RUN yum install -y java-17-openjdk-headless

WORKDIR /usr/lib/jenkins/
RUN rm -f jenkins.war && \
    wget --quiet --no-check-certificate https://updates.jenkins.io/download/war/2.462.1/jenkins.war
    

VOLUME ["/var/lib/jenkins"]

USER 1001
CMD /usr/local/bin/run.sh
