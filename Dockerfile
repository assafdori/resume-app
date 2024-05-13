# lightweight Nginx image
FROM nginx:alpine

# Copy HTML, CSS, JavaScript, images, and PDF files to Nginx web root
COPY index.html /usr/share/nginx/html
COPY resume.js /usr/share/nginx/html
COPY resume.css /usr/share/nginx/html
COPY favicon.png /usr/share/nginx/html
COPY screen-record.gif /usr/share/nginx/html
COPY resume.pdf /usr/share/nginx/html

# Expose port 80 & 443 of the container
EXPOSE 80
EXPOSE 443

# Add internal health check function (extenral health check done via other container)
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:80/resume.pdf --output /dev/null || exit 1

# Print to log that container loaded properly & start nginx server
CMD ["sh", "-c", "echo 'Container init successfully' && nginx -g 'daemon off;'"]