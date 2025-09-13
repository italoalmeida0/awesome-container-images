## | 🪸 AWECI - Awesome Container Images 🐋 |
 
Collection of ready-to-use development container images with modern tooling and optimized configurations.

## Available Images

### 🧑‍💻 VSCode

Web-based Visual Studio Code with Docker support and development tools.

**What's included:**

- VSCode Server (official)
- Docker CLI + Compose
- Git configuration
- Python 3 with UV package manager
- Homebrew + Starship prompt
- SSH tools

**Usage:**

```yml
services:
  vscode:
    image: ghcr.io/italoalmeida0/aweci:vscode
    container_name: vscode
    hostname: vscode
    environment:
      - PORT=8080
      - TZ=Europe/Lisbon
      - SERVER_DATA_DIR=/home/user/.vscode-server
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "./data:/home/user"
    ports:
      - "8080:8080"
    restart: always
    user: "1000:1000"
```

**Environment Variables:**

- `PORT` - Server port (default: 8080)
- `TZ` - Timezone
- `SERVER_DATA_DIR` - VSCode server data directory
- `VERBOSE` - Enable verbose logging (default: false)
- `GIT_USER_NAME` - Git user name (default: Developer)
- `GIT_USER_EMAIL` - Git email (default: dev@example.com)

---

### 👨‍🔬 Jupyter Lab

Modern data science environment with JupyterLab interface.

**What's included:**

- JupyterLab
- Catppuccin theme
- Python 3 with UV package manager
- Homebrew + Starship prompt
- SSH tools

**Usage:**

```yml
services:
  jupyterlab:
    image: ghcr.io/italoalmeida0/aweci:jupyterlab
    container_name: jupyterlab
    hostname: jupyterlab
    environment:
      - PORT=8080
      - TZ=Europe/Lisbon
    volumes:
      - "./data:/home/user"
    ports:
      - "8080:8080"
    restart: always
    user: "1000:1000"
```

**Environment Variables:**

- `PORT` - Server port (default: 8080)
- `TZ` - Timezone

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Built with ❤️ by Italo Almeida. Contributions are welcome!

**⭐ If this project helped you, please give it a star!**