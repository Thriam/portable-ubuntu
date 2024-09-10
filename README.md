
# Docker Image Management Scripts

## Overview

This repository contains scripts to manage Docker images and containers, specifically designed to automate the process of saving Docker images to a tarball, committing changes from a running container, and cleaning up Docker resources. The process involves saving an image, creating a new image from a container, and restoring from the saved tarball.

## Manual Setup

Before using the automation scripts, perform the following manual steps:

### 1. Pull the Ubuntu Docker Image

Ensure that you have the `ubuntu` Docker image available by running the following command:

```bash
sudo docker pull ubuntu
```

### 2. Save the Docker Image to a Tarball

Save the `ubuntu` image to a tarball at a specified location:

```bash
sudo docker save -o /media/thriambakesvar/0EAA-170B/ubuntu_old.tar ubuntu
```

### 3. Remove the Existing Ubuntu Docker Image

Remove the `ubuntu` image from the local Docker repository:

```bash
sudo docker rmi -f ubuntu
```

## Automation with Scripts

### Scripts

- **when_starting.sh**: Loads an image from a tarball, tags it, and starts a new container.
- **when_leaving.sh**: Commits changes from a running container to a new image, saves it to a tarball, and performs cleanup.

### Script Details

#### `when_starting.sh`

**Purpose**: Load a Docker image from a tarball, tag it, and start a new container.

**Usage**: Run this script to start a new Docker container from the saved tarball.

```bash
#!/bin/bash

# Variables
IMAGE_TAR_PATH="/media/thriambakesvar/0EAA-170B/ubuntu_old.tar"  # Path to your saved tarball
IMAGE_NAME="ubuntu_old"     # The name of the image
IMAGE_TAG="qazwsxedc"       # Tag for the image (used for isolation)
CONTAINER_NAME="mycontainer" # Name of the new container
PORT_MAPPING="6767:80"     # Port mapping for the container (host:container)

# Load the Docker image from the tar file
docker load -i "$IMAGE_TAR_PATH" || { echo "Error: Failed to load image from tarball."; exit 1; }

# Optional: Tag the loaded image if needed
if ! docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$IMAGE_NAME:$IMAGE_TAG$"; then
    IMAGE_ID=$(docker images --filter "dangling=false" --format "{{.ID}}" | head -n 1)
    docker tag "$IMAGE_ID" "$IMAGE_NAME:$IMAGE_TAG" || { echo "Error: Failed to tag image as '$IMAGE_NAME:$IMAGE_TAG'."; exit 1; }
fi

# Run a new container from the loaded image
docker run -itd -p "$PORT_MAPPING" --name "$CONTAINER_NAME" "$IMAGE_NAME:$IMAGE_TAG" /bin/bash || { echo "Error: Failed to start container."; exit 1; }

echo "Starting process completed: Image loaded, tagged, and new container started."
```

#### `when_leaving.sh`

**Purpose**: Commit changes from a running container to a new image, save it to a tarball, and clean up Docker resources.

**Usage**: Run this script to save changes, clean up, and prepare for the next session.

```bash
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
```

## How to Use the Scripts

### 1. Make the Scripts Executable

Change permissions to make the scripts executable:

```bash
chmod +x when_starting.sh
chmod +x when_leaving.sh
```

### 2. Run the Scripts

#### When Starting: 

Use `when_starting.sh` to load the image and start a new container:

```bash
sudo ./when_starting.sh
```

#### When Leaving: 

Use `when_leaving.sh` to commit changes, save the image, and clean up:

```bash
sudo ./when_leaving.sh
```

## Important Notes

- **Tagging**: The tag `qazwsxedc` is used for isolation to ensure that only specific images and containers are affected.
- **Cleanup**: Be cautious when running cleanup commands as they will delete Docker resources. Review the resources before executing these commands.

