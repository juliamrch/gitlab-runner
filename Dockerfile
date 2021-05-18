FROM gitlab/gitlab-runner:latest

COPY go.sh go.sh
RUN chmod +x go.sh

ENV PATH="${PATH}:/usr/local/bin"

# Install nodejs
RUN curl -sL https://rpm.nodesource.com/setup_current.x | bash  && \
    yum -y install nodejs jq && \
    echo "👋 🦊 Runner is installed" 
CMD [ "/go.sh" ]
