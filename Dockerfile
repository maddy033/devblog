FROM node:20-alpine3.18@sha256:a74f86ef4efc76bfd4a5b742bc4a3452a6bb3fa0dd308e153dd3afc5b1359adf

WORKDIR /app

# Install security updates only, avoid caching package manager
RUN apk add --no-cache --update \
    dumb-init \
    && apk update \
    && apk upgrade

# Copy dependency files
COPY package*.json ./

# Install production dependencies with security audit
RUN npm ci --omit=dev --audit-level=moderate

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
