<< '###'
#!/bin/bash
# Function to check "Ensure only trusted users are allowed to control Docker daemon"
echo "Checking 1.1.2: Ensure only trusted users are allowed to control Docker daemon"
# Check if there are any users in the docker group other than the expected trusted users
if getent group docker | grep -E -q 'untrusted_user'; then
  echo "Warning: Untrusted users found in the Docker group."
else
  echo "Pass: No untrusted users found in the Docker group."
fi
###

#!/bin/bash

# Function to check and manage trusted users in the Docker group
check_trusted_users_for_docker() {
    echo "Checking users in the Docker group..."

    # Define the list of trusted users (edit this list according to your organization)
    trusted_users=("user1" "user2" "admin")

    # Get current members of the docker group
    docker_group_users=$(getent group docker | cut -d: -f4 | tr ',' ' ')

    # Check each user in the docker group
    for user in $docker_group_users; do
        if [[ ! " ${trusted_users[@]} " =~ " ${user} " ]]; then
            echo "WARNING: User '$user' is not a trusted user!"
            echo "To remove the untrusted user, use the following command:"
            echo "sudo gpasswd -d $user docker"
        else
            echo "User '$user' is trusted."
        fi
    done
}

# Execute the function
check_trusted_users_for_docker

