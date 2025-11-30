# Development Setup

<!--
TEMPLATE INSTRUCTIONS:
Guide developers through setting up their local development environment.
Investigate: README.md, package.json scripts, docker-compose.yml, Makefile.
-->

## Prerequisites

<!--
List all required software and their minimum versions.
Include: language runtime, package manager, databases, tools.
-->

| Software | Version | Installation |
|----------|---------|--------------|
| Node.js | >= 18.x | [nodejs.org](https://nodejs.org) |
| | | |

## Quick Start

<!--
Minimal steps to get the project running locally.
This should be copy-paste ready.
-->

```bash
# Clone the repository
git clone <repository-url>
cd <project-name>

# Install dependencies
npm install

# Set up environment
cp .env.example .env

# Start development server
npm run dev
```

## Detailed Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <project-name>
```

### 2. Install Dependencies

```bash
# Primary package manager command
```

### 3. Environment Configuration

<!--
Explain required environment variables.
Reference configuration.md for full details.
-->

Copy the example environment file:

```bash
cp .env.example .env
```

Required variables to configure:

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | Database connection string | `postgresql://...` |
| | | |

### 4. Database Setup

<!--
Instructions for setting up local database.
Include: starting database, running migrations, seeding.
-->

```bash
# Start database (if using Docker)

# Run migrations

# Seed data (if applicable)
```

### 5. Start Development Server

```bash
# Command to start dev server
```

The application will be available at: `http://localhost:PORT`

## IDE Setup

<!--
Recommended IDE configuration and extensions.
-->

### VS Code

Recommended extensions:
-
-

Workspace settings (`.vscode/settings.json`):
```json
{
}
```

## Common Development Tasks

<!--
Frequently used commands during development.
-->

| Task | Command |
|------|---------|
| Start dev server | `npm run dev` |
| Run tests | `npm test` |
| Lint code | `npm run lint` |
| Format code | `npm run format` |
| Build | `npm run build` |

## Docker Development

<!--
If Docker is used for local development.
-->

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Troubleshooting Setup Issues

<!--
Common problems during setup and their solutions.
-->

### Issue: [Description]

**Symptoms:**

**Solution:**

```bash
# Fix command
```
