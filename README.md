
# Portable Ubuntu

By the usage of dockers, we can easily export our ubuntu machine from one device to other, that process of exporting the images and cleaning up the host system after each usage is automated by my scripts. Hope this might help you, in your work.

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

#### `when_leaving.sh`

**Purpose**: Commit changes from a running container to a new image, save it to a tarball, and clean up Docker resources.

**Usage**: Run this script to save changes, clean up, and prepare for the next session.

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

