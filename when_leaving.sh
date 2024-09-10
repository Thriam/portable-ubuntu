#!/bin/bash

# Variables
CONTAINER_NAME="mycontainer"         # Name of the running container
OLD_IMAGE_NAME="ubuntu_old"          # The name of the old image
IMAGE_TAG="qazwsxedc"                # Tag used for isolation
IMAGE_TAR_PATH="/media/thriambakesvar/0EAA-170B/ubuntu_old.tar"  # Path to the tarball

# Check if the container exists
if ! docker ps -q -f name="$CONTAINER_NAME" > /dev/null; then
    echo "Error: Container '$CONTAINER_NAME' does not exist or is not running."
    exit 1
fi

# Commit the running container to a new image
docker commit "$CONTAINER_NAME" "$OLD_IMAGE_NAME:$IMAGE_TAG" || { echo "Error: Failed to commit container to new image."; exit 1; }

# Save the updated image to the tarball file
docker save -o "$IMAGE_TAR_PATH" "$OLD_IMAGE_NAME:$IMAGE_TAG" || { echo "Error: Failed to save image to tarball."; exit 1; }

# Stop and remove the existing container
docker stop "$CONTAINER_NAME" || { echo "Error: Failed to stop container '$CONTAINER_NAME'."; exit 1; }
docker rm "$CONTAINER_NAME" || { echo "Error: Failed to remove container '$CONTAINER_NAME'."; exit 1; }

# Remove the image created by 'when_starting.sh'
docker rmi "$OLD_IMAGE_NAME:$IMAGE_TAG" || { echo "Error: Failed to remove image '$OLD_IMAGE_NAME:$IMAGE_TAG'."; exit 1; }

echo "Leaving process completed: Committed changes, saved to tarball, and cleaned up."

