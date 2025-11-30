# Configuration

<!--
TEMPLATE INSTRUCTIONS:
Document all configuration options: environment variables, config files, feature flags.
Investigate: .env.example, config/, settings files, process.env usage in code.
-->

## Environment Variables

<!--
List all environment variables the application uses.
Group by category for readability.
-->

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `development`, `production` |
| `DATABASE_URL` | Database connection string | `postgresql://user:pass@host:5432/db` |
| | | |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `3000` |
| `LOG_LEVEL` | Logging verbosity | `info` |
| | | |

### Third-Party Services

| Variable | Service | Description |
|----------|---------|-------------|
| | | |

## Configuration Files

<!--
Document configuration files and their purposes.
-->

### Application Config

**Location:** `config/`

```javascript
// Example structure
module.exports = {
  server: {
    port: process.env.PORT || 3000,
  },
  database: {
    url: process.env.DATABASE_URL,
  },
};
```

### Environment-Specific Config

<!--
How configuration varies by environment.
-->

| File | Environment |
|------|-------------|
| `.env.development` | Local development |
| `.env.test` | Test environment |
| `.env.production` | Production |

## Feature Flags

<!--
If the application uses feature flags, document them.
-->

| Flag | Description | Default | How to Enable |
|------|-------------|---------|---------------|
| | | | |

## Logging Configuration

<!--
How to configure logging behavior.
-->

### Log Levels

| Level | Description |
|-------|-------------|
| `error` | Error conditions |
| `warn` | Warning conditions |
| `info` | Informational messages |
| `debug` | Debug-level messages |

### Log Output

- **Development:** Console output
- **Production:**

## Database Configuration

<!--
Database-specific configuration options.
-->

### Connection Pool

| Setting | Description | Default |
|---------|-------------|---------|
| `max` | Maximum connections | `10` |
| `min` | Minimum connections | `2` |
| `idle` | Idle timeout (ms) | `10000` |

## Cache Configuration

<!--
If caching is used, document configuration.
-->

| Setting | Description | Default |
|---------|-------------|---------|
| `CACHE_TTL` | Default TTL (seconds) | `300` |
| `REDIS_URL` | Redis connection URL | |

## API Configuration

<!--
API-related configuration options.
-->

### Rate Limiting

| Setting | Description | Default |
|---------|-------------|---------|
| `RATE_LIMIT_MAX` | Max requests per window | `100` |
| `RATE_LIMIT_WINDOW` | Window size (ms) | `60000` |

### CORS

| Setting | Description | Default |
|---------|-------------|---------|
| `CORS_ORIGIN` | Allowed origins | `*` |

## Security Configuration

<!--
Security-related settings.
-->

| Setting | Description | Recommendation |
|---------|-------------|----------------|
| `SESSION_SECRET` | Session signing secret | Use strong random value |
| `JWT_SECRET` | JWT signing secret | Use strong random value |
| `JWT_EXPIRY` | Token expiration | `24h` |

## Configuration Best Practices

### Local Development

1. Copy `.env.example` to `.env`
2. Fill in required values
3. Never commit `.env` to version control

### Production

1. Use secrets management (not `.env` files)
2. Rotate secrets regularly
3. Use least-privilege access

## Validating Configuration

<!--
How to verify configuration is correct.
-->

```bash
# Command to validate config
npm run config:validate

# Or check specific values
echo $DATABASE_URL
```

## Configuration Schema

<!--
If using config validation (Joi, Zod, etc.), document the schema.
-->

```typescript
const configSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.string().default('3000'),
  DATABASE_URL: z.string().url(),
});
```
