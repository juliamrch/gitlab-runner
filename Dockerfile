#FROM gitlab/gitlab-runner:v13.1.0
FROM gitlab/gitlab-runner:v13.1.0
# Doesn't work after v13.0.1

COPY go.sh /go.sh
RUN chmod +x /go.sh

# Install bash
RUN apt update && apt install bash
#RUN apk update && apk add bash

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash  && \
    apt-get -y update && \
    apt-get -y install nodejs jq && \
    apt-get -y install rustc && \
    echo "👋  🦊 Runner is installed"

ENTRYPOINT ["/usr/bin/dumb-init", "/go.sh"]
#RUN [ "/go.sh" ]
