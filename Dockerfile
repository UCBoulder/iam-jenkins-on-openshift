#FROM image-registry.openshift-image-registry.svc:5000/openshift/jenkins@sha256:81dc3755056f60a34693121d0da1e93deaaf00d86a72a6a2e5e259a7a09c881c as jenkins
#FROM image-registry.openshift-image-registry.svc:5000/openshift/jenkins@sha256:e0a054d0a2e3088eb9ac6c65149fec386fefcf2aacc7181fa806cf2fad190a4c as jenkins
#FROM quay.io/openshift/origin-jenkins@sha256:ed8605f19d17ce84e78aaaac932a347b24ffcd1827d73258ff5628d6366d16df as jenkins
#FROM quay.io/openshift/origin-jenkins@sha256:a7c28e11e20139e69b1a39e0c63a440d7d973f1058fda5e1b862ad7cf937410b as jenkins
FROM quay.io/openshift/origin-jenkins:latest as jenkins

USER root
#RUN yum install -y jenkins-plugin-openshift openshift-origin-cartridge-jenkins
#RUN yum update -y
COPY run_ucb.sh /usr/local/bin/run.sh
RUN cp -p /usr/libexec/s2i/run /usr/libexec/s2i/run.orig
RUN rm -f /usr/libexec/s2i/run
COPY run_ucb.sh /usr/libexec/s2i/run
RUN chmod 755 /usr/libexec/s2i/run && chmod 755 /usr/local/bin/run.sh

WORKDIR /usr/lib/jenkins/
RUN rm -f jenkins.war && \
    wget --quiet --no-check-certificate https://updates.jenkins.io/download/war/2.375.3/jenkins.war
    

VOLUME ["/var/lib/jenkins"]

USER 1001
CMD /usr/local/bin/run.sh
