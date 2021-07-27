FROM gitlab/gitlab-runner:v13.4.0

COPY go.sh /
RUN chmod +x /go.sh


# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash  && \
    apt-get -y update && \
    apt-get -y install nodejs jq && \
    echo "👋  🦊 Runner is installed"

ENTRYPOINT ["/usr/bin/dumb-init", "/go.sh"]
