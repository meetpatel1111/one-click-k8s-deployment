#FROM node:18-alpine
#WORKDIR /app
#COPY package*.json ./
#RUN npm install
#COPY . .
#EXPOSE 3000
#CMD ["npm","start"]

# Use a lightweight NGINX image
FROM nginx:alpine

# Copy the index.html file into the default NGINX web directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to the host machine
EXPOSE 80

# The default command runs NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
