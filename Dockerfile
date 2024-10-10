# Use the official Node.js image as the base image
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json/yarn.lock into the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app's source code into the container
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Serve the app
FROM node:18-alpine AS runner

WORKDIR /app

# Copy the Next.js build output from the previous stage
COPY --from=builder /app ./

# Expose the port Next.js will run on
EXPOSE 3000

# Set environment variable to optimize Next.js for production
ENV NODE_ENV production

# Start the app
CMD ["npm", "run", "start"]
