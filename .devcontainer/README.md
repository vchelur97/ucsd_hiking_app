# Development Environment with DevContainers

This project uses DevContainers to standardize the development environment across different machines and developers. This helps to ensure that everyone is working with the same tool versions, reducing the "it works on my machine" problem.

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code

## Getting Started

1. Clone the repository to your local machine.
2. Open the project in Visual Studio Code.
3. When prompted to "Reopen in Container", click "Reopen". If you are not prompted, press `F1`, type "Remote-Containers: Reopen Folder in Container", and press `Enter`.
4. Wait for the container to build. This may take a few minutes the first time, but will be faster on subsequent loads.
5. Once the container is built, VS Code will reload and you'll be in the development environment!

## Using the DevContainer

Once you're in the DevContainer, you can use the terminal just like you would on your local machine. The workspace is mounted as a volume in the Docker container, so any changes you make to files in the workspace will be reflected in the container.

## Customizing Your DevContainer

### Workspace Folder and Mounts

You can customize the mounts in the `devcontainer.json` file. For example, to bind mount the `.ssh` directory from your local environment to the container, you can add the following:

```jsonc
"mounts": [
    {
        "source": "${localEnv:HOME}/.ssh",
        "target": "/home/vscode/.ssh",
        "type": "bind"
    }
]
```

This will allow the container to access your SSH keys, which can be useful if you need to clone private repositories or connect to other services over SSH.

### Environment Variables

Environment variables are set in the `.env` file in the `.devcontainer` directory. To make the database work with the DevContainer, you need to change the `DB_HOST` environment variable from `localhost` to `db`. This is because `localhost` refers to the container itself, but the database is running in a separate container.

```
DB_HOST=db
```

### Dotfiles

You can personalize your DevContainer by using dotfiles from a dotfile repository. To do this, follow these steps:

1. Create a dotfile repository on a version control system like GitHub or GitLab.
2. Add your dotfiles to the repository. Here's an example: https://github.com/crvineeth97/dotfiles (Warning: This is a personal repository and may not be suitable for your use case. The .gitconfig file contains my name and email address. The install.sh script WILL OVERWRITE your existing dotfiles if you install it on your local machine. It should be fine to use in a DevContainer. Use at your own risk.)
3. Follow the instructions at https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories

You can configure the dotfile repository in your VS Code settings by adding the following:
```json
{
    "dotfiles.repository": "<GitHub Repository URL>", // e.g. "crvineeth97/dotfiles"
    "dotfiles.targetPath": "/home/vscode/dotfiles",
    "dotfiles.installCommand": "install.sh",
}
```

## Troubleshooting

If you're having trouble with the DevContainer, try the following:

- Rebuild the container: `F1` -> "Remote-Containers: Rebuild Container"
- Check Docker Desktop is running and has resources available.
- Check the Dockerfile and devcontainer.json for errors.

Happy coding!