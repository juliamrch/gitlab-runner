FROM gitlab/gitlab-runner:latest

COPY go.sh /home/gitlab-runner/go.sh
RUN chmod +x /home/gitlab-runner/go.sh

ENV PATH="${PATH}:/usr/local/bin"

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash  && \
    apt-get -y update && \
    apt-get -y install nodejs jq && \
    echo "👋 🦊 Runner is installed" 
CMD [ "/home/gitlab-runner/go.sh" ]
