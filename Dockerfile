# Runner for a nodejs project
FROM centos:latest

COPY go.sh go.sh
RUN chmod +x go.sh

ENV PATH="${PATH}:/usr/local/bin"

# Install gitlab-runner and nodejs
RUN yum update && \
    yum install -y curl && \
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash  && \
    yum install -y gitlab-runner=13.1.0 && \
    curl -sL https://rpm.nodesource.com/setup_current.x | bash  && \
    yum -y install nodejs jq && \
    echo "👋 🦊 Runner is installed" 
CMD [ "/go.sh" ]
