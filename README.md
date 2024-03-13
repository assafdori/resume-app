# Terminal Resume 💻

Terminal Resume is a terminal emulator using HTML, CSS and JavaScript to showcase my resume in terminal.<br><p>
<b>Live Site - <a href="https://www.assafdori.com" target="_blank">https://www.assafdori.com</a></b><br>

<img src="https://github.com/assafdori/resume/blob/main/screen-record.gif?raw=true" width=100%>

### Available Commands 🕹️

```zsh
help, about, education, projects, experience, skills, contact, download, clear
```

### Application is available as a Docker image 🐋

```zsh
docker pull asixl/cli-resume:0.0.9
```

### Also available as a Docker Compose YAML with Health Check (ARM64) 🥳

```zsh
curl https://raw.githubusercontent.com/assafdori/resume-app/main/docker-compose.yml -o ./docker-compose.yml && docker compose up
```

### Features 🌐

- Customized commands to display different resume sections
- Cycle through the commands history using <kbd>&uarr;</kbd> and <kbd>&darr;</kbd> arrow keys.
- Command completion using <kbd>CTRL</kbd> + <kbd>SPACE</kbd> keyboard shortcut
- Clear console with ```clear``` command
- Download resume with ```download``` command
- Display error message on incorrect command
- Automatic console scroll down with command output
- **Health check container that monitors the main web application container (Compose only)**

### Progress, Journaling & Ideas 💡

- ~~March 7th, 2024 - Next stage is to implement a health check system that will check the main container via HTTP requests. Utilize Docker Compose for the proof of concept, then migrate to K8s once I've adapted to it.~~
