# Runner for a nodejs project
FROM gitlab/gitlab-runner:latest

COPY go.sh go.sh
RUN chmod +x go.sh

# Install gitlab-runner and nodejs
RUN apt-get update && \
    apt-get -y install nodejs jq && \
    echo "👋 🦊 Runner is installed" 
CMD [ "/go.sh" ]
