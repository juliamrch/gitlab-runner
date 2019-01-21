# Runner for a nodejs project
FROM gitlab/gitlab-runner:latest

COPY go.sh /home/gitlab-runner/go.sh
RUN chmod +x go.sh

RUN apt-get update && \
    apt-get -y install jq && \
    echo "👋 🦊 Runner is installed" 
CMD [ "/home/gitlab-runner/go.sh" ]
