# Use official NGINX image as base
FROM nginx:latest

# Copy custom index.html to NGINX default location
COPY index.html /usr/share/nginx/html/index.html

# Keep default NGINX configuration
# The default nginx.conf will serve files from /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# NGINX runs as daemon by default, no need for CMD override
