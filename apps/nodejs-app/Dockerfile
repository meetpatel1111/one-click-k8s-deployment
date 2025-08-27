# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy app source
COPY . .

# Expose app port
EXPOSE 3000

# Run server
CMD ["node", "server.js"]
