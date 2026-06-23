# Custom Kasm Workspace images
Custom Kasm Workspace images with some extra tooling based on the [official images](https://github.com/kasmtech/workspaces-images). If a commonly used tool is missing feel free to create a pull request. To use these images download the official Workspace and then replace the docker image URL in your workplace settings. Images are automatically built weekly.

# Usage
Create a new Workspace and edit it. If you want to use for example Ubuntu Jammy Desktop then you should select the Jammy Desktop Workspace from the official Registry and then click "Edit".

In the edit menu, Replace the Docker Image under container options. The Image name follows the following naming convention: `ghcr.io/bysimpson/kasm-workspace-{{Dockerfile-name}}:{{kasm-version}}`. So if you want to use the Image ubuntu-jammy-desktop with the 
kasm version 1.15, then the image tag will be `ghcr.io/bysimpson/kasm-workspace-ubuntu-jammy-desktop:1.19.0`.

If you want to use Wireguard, you have to add the following to Docker Run Config Override:
```json
{
  "hostname": "kasm",
  "cap_add": [
    "NET_ADMIN"
  ]
}
```

To enable persistant storage, put something like the following path into persistant storage path:
```
/mnt/kasm_profiles/{image_id}/{username}
```

# Currently included changes
## All images
 - python
 - rust
 - sudo (NOPASSWD all)
 - zsh (oh-my-zsh)

## Ubuntu
 - Wireguard
 - 1password (amd64 only)
