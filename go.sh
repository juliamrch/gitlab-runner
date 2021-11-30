#!/bin/sh

######
# From https://gitlab.com/gitlab-org/gitlab-runner/-/blob/main/dockerfiles/runner/ubuntu/entrypoint
######

# gitlab-runner data directory
#DATA_DIR="/etc/gitlab-runner"
#CONFIG_FILE=${CONFIG_FILE:-$DATA_DIR/config.toml}
# custom certificate authority path
#CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$DATA_DIR/certs/ca.crt}
#LOCAL_CA_PATH="/usr/local/share/ca-certificates/ca.crt"

#update_ca() {
#  echo "Updating CA certificates..."
#  cp "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}"
#  update-ca-certificates --fresh >/dev/null
#}

#if [ -f "${CA_CERTIFICATES_PATH}" ]; then
  # update the ca if the custom ca is different than the current
#  cmp --silent "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}" || update_ca
#fi

######
# end
######


# Get the id of old runners (if exists)
echo "Handle old runners..."
json=$(curl --header "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" "$GITLAB_INSTANCE/api/v4/runners")

for row in $(echo "${json}" | jq -r '.[] | @base64'); do
    echo "$row";
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    echo "$row";
    if [[ $(_jq '.description') == $RUNNER_NAME ]]
    then
      echo "👋 old runner $RUNNER_NAME runner is: $(_jq '.id')"
      echo "⚠️ trying to deactivate runner..."
      curl --request DELETE --header "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" "$GITLAB_INSTANCE/api/v4/runners/$(_jq '.id')"
    fi
done

# Register, then run the new runner
echo "👋 launching new gitlab-runner"

gitlab-runner register \
  --non-interactive \
  --executor shell \
#  --docker-image ubuntu:v13.1.0 \
#  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --url "$GITLAB_INSTANCE/" \
  --name $RUNNER_NAME \
  --registration-token $REGISTRATION_TOKEN \
#  --tag-list "docker" \
#  --run-untagged="true" \
#  --locked="false" \
#  --access-level="not_protected"

#sed -i -e 's/concurrent = 1/concurrent = 10/g' /etc/gitlab-runner/config.toml

cat /etc/gitlab-runner/config.toml

gitlab-runner --debug run &

echo "🌍 executing the http server"
python3 -m http.server 8080
