# Use Node.js LTS
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD ["npm", "start"]
