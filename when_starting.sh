#!/bin/bash

# Variables
IMAGE_TAR_PATH="/media/thriambakesvar/0EAA-170B/ubuntu_old.tar"  # Path to your saved tarball
IMAGE_NAME="ubuntu_old"     # The name you want for the image
IMAGE_TAG="qazwsxedc"       # Tag for the image (used for isolation)
CONTAINER_NAME="mycontainer" # Name of the new container
PORT_MAPPING="6767:80"     # Port mapping for the container (host:container)

# Load the Docker image from the tar file
docker load -i "$IMAGE_TAR_PATH" || { echo "Error: Failed to load image from tarball."; exit 1; }

# Optional: Tag the loaded image if needed
if ! docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$IMAGE_NAME:$IMAGE_TAG$"; then
    # Find the image ID of the newly loaded image
    IMAGE_ID=$(docker images --filter "dangling=false" --format "{{.ID}}" | head -n 1)

    # Tag the loaded image with the desired name and tag for isolation
    docker tag "$IMAGE_ID" "$IMAGE_NAME:$IMAGE_TAG" || { echo "Error: Failed to tag image as '$IMAGE_NAME:$IMAGE_TAG'."; exit 1; }
fi

# Run a new container from the loaded image
docker run -itd -p "$PORT_MAPPING" --name "$CONTAINER_NAME" "$IMAGE_NAME:$IMAGE_TAG" /bin/bash || { echo "Error: Failed to start container."; exit 1; }

echo "Starting process completed: Image loaded, tagged, and new container started."

