# Use the official Meteor base image
FROM geoffreybooth/meteor-base:latest

# Set the working directory in the container
WORKDIR /app

# Copy your app's source code into the container
COPY . /app

# Install OS dependencies, if any
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python \
    && rm -rf /var/lib/apt/lists/*

# Install NPM packages
RUN meteor npm install

# Build the Meteor app
RUN meteor build --directory /app-build

# Use the Node.js base image to run the app
FROM meteor/node:14.21.4-alpine3.17

WORKDIR /app

# Copy the built app from the previous stage and install production NPM packages
COPY --from=0 /app-build /app
RUN cd /app/bundle/programs/server && npm install

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run your app
CMD ["node", "/app/bundle/main.js"]
