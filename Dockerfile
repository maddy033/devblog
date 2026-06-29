FROM node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293

WORKDIR /app

# Install security updates with pinned versions
RUN apk add --no-cache \
    dumb-init=1.2.5-r3 \
    && apk upgrade --no-cache

# Copy dependency files
COPY package*.json ./

# Install production dependencies with security audit
RUN npm install --omit=dev --audit-level=moderate

# Copy application code
COPY . .

# Create necessary directories and set permissions
RUN mkdir -p public/images && \
    chown -R node:node /app

# Expose port
EXPOSE 3000

# Use non-root user
USER node

# Use dumb-init to handle signals properly
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

CMD ["npm", "start"]
