FROM gitlab/gitlab-runner:latest

RUN apt-get update && \
    apt-get -y install jq python3.6 && \
    echo "👋 🦊 Runner is installed" 

COPY go.sh /go.sh
ENTRYPOINT ["/go.sh"]
CMD ["run", "--working-directory=/home/gitlab-runner", "--user=gitlab-runner"]
