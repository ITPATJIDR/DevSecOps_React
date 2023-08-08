# Use the official Ubuntu image as the base
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs wget gnupg software-properties-common && \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
    add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" && \
    apt-get update && \
    apt-get install -y grafana prometheus nginx

# Set up Grafana configuration (replace with your actual Grafana config)
COPY grafana.ini /etc/grafana/grafana.ini

# Set up Prometheus configuration (replace with your actual Prometheus config)
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Set up Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default

# Expose ports for Grafana, Prometheus, and Nginx
EXPOSE 3000 9090 80

# Start services
CMD service grafana-server start && service prometheus start && nginx -g "daemon off;"
