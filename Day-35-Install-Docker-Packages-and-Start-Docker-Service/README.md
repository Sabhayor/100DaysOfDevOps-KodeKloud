# Day 35 – Install Docker Packages and Start Docker Service

## Task/Requirement

The Nautilus DevOps team aims to containerize various applications following a recent meeting with the application development team. They intend to conduct testing with the following steps:  

- Install docker-ce and docker compose packages on App Server 1.  
- Initiate the docker service.

---

### Step 1 – Connect to App Server
```
ssh tony@stapp01
```

### Step 2 -  Remove any existing Docker packages
```
sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
```

### Step 3 - Install DNF plugins
```
sudo dnf install -y dnf-plugins-core
```

### Step 4 - Add official Docker repository
```
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

### Step 5 -  Install Docker CE and Docker Compose plugin
```
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Step 6 - Verify Docker installation
```
docker --version
```

### Step 7 - Verify Docker Compose installation
```
docker compose version
```
---

### Step 8 - Enable and start Docker service

```
sudo systemctl enable --now docker
```
### Step 9 - Verify Docker service status

```
sudo systemctl status docker
```
---

### Key Learnings
- Docker CE should be installed using the official Docker repository
- Old Docker packages must be removed to avoid conflicts
- Docker Compose is now provided as a plugin (docker compose)
- Docker service must be enabled and started before usage
- Verifying versions confirms successful installation