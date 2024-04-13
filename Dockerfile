# lightweight Nginx image
FROM nginx:alpine

# Install Certbot and other dependencies
RUN apk update && apk add --no-cache certbot curl

# Copy HTML, CSS, JavaScript, images, and PDF files to Nginx web root
COPY index.html /usr/share/nginx/html
COPY resume.js /usr/share/nginx/html
COPY resume.css /usr/share/nginx/html
COPY favicon.png /usr/share/nginx/html
COPY screen-record.gif /usr/share/nginx/html
COPY resume.pdf /usr/share/nginx/html

# Create directory for Certbot challenge files
RUN mkdir -p /usr/share/nginx/html/.well-known/acme-challenge

# Expose port 80 of the container
EXPOSE 80

# Add internal health check function (external health check done via other container)
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:80/resume.pdf --output /dev/null || exit 1

# Add script for certificate renewal
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Print to log that container loaded properly & start nginx server
CMD ["sh", "-c", "echo 'Container init successfully' && /entrypoint.sh"]
