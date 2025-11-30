# Troubleshooting

<!--
TEMPLATE INSTRUCTIONS:
Document common issues, their symptoms, and solutions.
Investigate: GitHub issues, error handling code, logging, common support requests.
-->

## Quick Diagnostics

### Health Check

```bash
# Check if the application is running
curl http://localhost:PORT/health
```

### Logs

```bash
# View application logs
# Command depends on deployment method
```

### Common First Steps

1. Check the logs for error messages
2. Verify environment variables are set correctly
3. Ensure all dependencies are installed
4. Check database connectivity

## Common Issues

### Installation Issues

#### Issue: Dependencies fail to install

**Symptoms:**
- `npm install` fails with errors
- Missing peer dependencies warnings

**Solution:**
```bash
# Clear npm cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

#### Issue: Wrong Node.js version

**Symptoms:**
- Syntax errors on startup
- "Unsupported engine" warning

**Solution:**
```bash
# Check Node.js version
node --version

# Use nvm to switch versions
nvm install 18
nvm use 18
```

### Runtime Issues

#### Issue: Application fails to start

**Symptoms:**
- Process exits immediately
- Port already in use error

**Solution:**
```bash
# Check what's using the port
lsof -i :PORT

# Kill the process or use different port
kill -9 <PID>
# or
PORT=3001 npm run dev
```

#### Issue: Database connection failed

**Symptoms:**
- "Connection refused" errors
- "Authentication failed" errors

**Solution:**
1. Verify database is running
2. Check `DATABASE_URL` environment variable
3. Verify credentials are correct
4. Check network connectivity/firewall

```bash
# Test database connection
# (command depends on database type)
```

### API Issues

#### Issue: 401 Unauthorized errors

**Symptoms:**
- API calls return 401
- "Invalid token" message

**Solution:**
1. Verify authentication token is present in header
2. Check if token has expired
3. Ensure token format is correct (`Bearer <token>`)

#### Issue: CORS errors

**Symptoms:**
- "Access-Control-Allow-Origin" errors in browser console
- API works in Postman but not in browser

**Solution:**
1. Verify CORS configuration allows your origin
2. Check for preflight (OPTIONS) request handling
3. Verify allowed headers include those you're sending

### Performance Issues

#### Issue: Slow response times

**Symptoms:**
- API responses take > 1 second
- Timeouts occurring

**Diagnosis:**
```bash
# Check resource usage
top
# or
htop

# Check database query performance
# (check slow query logs)
```

**Possible causes:**
- Database queries not optimized (missing indexes)
- Memory leaks
- External API dependencies slow
- Insufficient resources

#### Issue: Memory leaks

**Symptoms:**
- Memory usage grows over time
- Application crashes with OOM errors

**Diagnosis:**
```bash
# Monitor memory usage
```

### Build Issues

#### Issue: Build fails

**Symptoms:**
- TypeScript compilation errors
- Missing module errors

**Solution:**
```bash
# Clean build artifacts
rm -rf dist/ .cache/

# Reinstall dependencies and rebuild
npm ci
npm run build
```

## Debugging

### Enable Debug Logging

```bash
# Set debug environment variable
DEBUG=app:* npm run dev
```

### Inspecting the Application

```bash
# Start with Node.js inspector
node --inspect dist/index.js
```

Then open `chrome://inspect` in Chrome.

### Database Debugging

```bash
# View recent queries (if query logging enabled)

# Check database status

# Verify schema is up to date
```

## Error Reference

<!--
List common error codes/messages and their meanings.
-->

| Error Code | Message | Meaning | Solution |
|------------|---------|---------|----------|
| `ERR_001` | | | |
| `ERR_002` | | | |

## Getting Help

If your issue isn't covered here:

1. Check existing [GitHub Issues](link)
2. Search the documentation
3. Open a new issue with:
   - Error message (full stack trace)
   - Steps to reproduce
   - Environment details (OS, Node version, etc.)
   - What you've already tried

## FAQ

### Q: How do I reset my local database?

**A:**
```bash
# Drop and recreate database
# Run migrations
# Seed data
```

### Q: How do I clear the cache?

**A:**
```bash
# Command to clear cache
```

### Q: Where are the logs stored?

**A:**
