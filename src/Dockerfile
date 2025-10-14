## Use official Node.js image as the base
FROM alpine:3.22.2

## Set the working directory inside the container
WORKDIR /app

## Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

## Install Node.js dependencies
RUN npm install

## Copy all project files to the container
COPY . .

## Set the default command to run the application
CMD ["node", "server.js"]

## Expose port 8080 for the application
EXPOSE 8080