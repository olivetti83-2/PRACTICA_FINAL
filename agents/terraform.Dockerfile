FROM oliverp83/base-jenkins-agent

RUN apt-get update && \
    apt-get install -qy gnupg software-properties-common curl && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install -qy terraform zip awscli



EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]