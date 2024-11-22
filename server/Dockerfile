# Use Node.js LTS as the base image
FROM node:22

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Expose the application port (replace 3000 with your app's port if different)
EXPOSE 3000

# Define the command to run your app
CMD ["node", "index.js"]