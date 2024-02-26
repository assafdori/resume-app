# Terminal Resume 💻
Terminal Resume is a terminal emulator using HTML, CSS and JavaScript to showcase my resume in terminal.<br><p>
<b>Live Site - <a href="https://www.assafdori.com" target="_blank">https://www.assafdori.com</a></b><br> (Currently inactive)

<img src="https://github.com/assafdori/resume/blob/main/screen-record.gif?raw=true" width=100%>

### Features
- Customized commands to display various resume sections
- Cycle through the commands history using <b>up</b> ⬆️ and <b>down</b> ⬇️ arrow keys
- Command completion using <b>Ctrl</b> + <b>Space</b> keyboard shortcut
- Clear console with <b>clear</b> command
- Download resume with <b>download</b> command
- Display error message on incorrect command
- Auto scroll down console with command output

### Available Commands
- help, about, education, projects, experience, skills, contact, download, clear

### Progress, Journaling & Ideas
- 24/02/2024 - As of now, the base app is ready. I'm thinking of implementing a visitor counter and some sort of Python monitoring, just for the learning. Actual monitoring will be utilized by a more 'meta' app, such as Prometheus & visualize with Grafana.
- 24/02/2024 - As of now, the next hop in the project is to better learn Ansible/Terraform to start with the deployment and automation process of the app.
- 24/02/2024 - Next steps are to create another Dockerfile & Docker image that it's purpose is to do HTTP requests to the main container to check it's alive and make the end point var to come from the config file of the k8s pod - "GET http://localhost:port/index.html" 
http://{end_point_coming_from_config}
