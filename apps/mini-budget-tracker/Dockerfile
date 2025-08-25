# Use lightweight Node.js image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all app files
COPY . .

# Expose port 3000 (Node.js server)
EXPOSE 3000

# Start the Node.js server
CMD ["node", "server.js"]
