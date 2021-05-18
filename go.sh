#!/bin/bash

# Get the id of old runners (if exists)
json=$(curl --header "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" "$GITLAB_INSTANCE/api/v4/groups/benevolt/runners")

for row in $(echo "${json}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    if [ $(_jq '.description') == $RUNNER_NAME ]
    then
      echo "👋 old runner $RUNNER_NAME runner is: $(_jq '.id')"
      echo "⚠️ trying to deactivate runner..."
      curl --request DELETE --header   "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN"   "$GITLAB_INSTANCE/api/v4/runners/$(_jq '.id')" 
    fi
done

# Register, then run the new runner
echo "👋 launching new gitlab-runner"

gitlab-runner register --non-interactive \
  --url "$GITLAB_INSTANCE/" \
  --name $RUNNER_NAME \
  --registration-token $REGISTRATION_TOKEN \
  --executor docker \
  --tag-list docker \
  --docker-image "docker:stable"

sed -i -e 's/concurrent = 1/concurrent = 10/g' /etc/gitlab-runner/config.toml

gitlab-runner  --restart always \
     -v /srv/gitlab-runner/config:/etc/gitlab-runner \
     -v /var/run/docker.sock:/var/run/docker.sock

echo "🌍 executing the http server"
python3 -m http.server 8080
