FROM gitlab/gitlab-runner:latest

ADD go.sh go.sh
RUN chmod +x go.sh

ENV PATH="${PATH}:/usr/local/bin"

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash  && \
    apt-get -y update && \
    apt-get -y install nodejs jq && \
    pwd && \
    ls bin && \
    echo "👋 🦊 Runner is installed" 
CMD go.sh
