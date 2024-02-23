# Use a lightweight Nginx image
FROM nginx:alpine

# Copy HTML, CSS, JavaScript, images, and PDF files to Nginx web root
COPY index.html /usr/share/nginx/html
COPY resume.js /usr/share/nginx/html
COPY resume.css /usr/share/nginx/html
COPY favicon.png /usr/share/nginx/html
COPY screen-record.gif /usr/share/nginx/html
COPY resume.pdf /usr/share/nginx/html

# Expose port 80 to allow outside access to the web server
EXPOSE 80
