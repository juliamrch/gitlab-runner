FROM gitlab/gitlab-runner:latest

ADD go.sh /etc/gitlab-runner/go.sh
RUN chmod +x /etc/gitlab-runner/go.sh

ENV PATH="${PATH}:/usr/local/bin"

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash  && \
    apt-get -y update && \
    apt-get -y install nodejs jq && \
    echo "👋 🦊 Runner is installed" 
CMD ["/etc/gitlab-runner/go.sh"]
