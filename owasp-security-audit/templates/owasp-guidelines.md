# OWASP Top 10 - 2021 Quick Reference

This file provides the security guidelines reference for the multi-agent audit.

---

## A01:2021 - Broken Access Control

### Description
Access control enforces policy such that users cannot act outside of their intended permissions. Failures typically lead to unauthorized information disclosure, modification, or destruction of data.

### Vulnerability Examples
- Bypassing access controls by modifying URL, application state, or HTML page
- Allowing primary key to be changed to another user's record (IDOR)
- Privilege escalation (acting as admin while logged in as user)
- Metadata manipulation (JWT, cookies, hidden fields)
- CORS misconfiguration allowing unauthorized API access

### Prevention Checklist
- [ ] Deny access by default, except for public resources
- [ ] Implement access control mechanisms once and reuse throughout application
- [ ] Model access controls should enforce record ownership
- [ ] Disable web server directory listing
- [ ] Log access control failures and alert admins on repeated failures
- [ ] Rate limit API and controller access
- [ ] Invalidate JWT tokens on server after logout

### Search Patterns
```
# Authorization checks
grep -r "isAdmin\|isAuthorized\|hasPermission\|checkAccess\|authorize"
grep -r "req\.user\|currentUser\|session\.user"

# Direct object references
grep -r "params\.id\|query\.id\|body\.id"
grep -r "findById\|getById\|where.*id"

# CORS configuration
grep -r "Access-Control-Allow-Origin\|cors("
```

---

## A02:2021 - Cryptographic Failures

### Description
Failures related to cryptography which often lead to exposure of sensitive data. Previously known as "Sensitive Data Exposure."

### Vulnerability Examples
- Data transmitted in plain text (HTTP, SMTP, FTP)
- Old or weak cryptographic algorithms
- Default or weak crypto keys
- Missing encryption enforcement (no HSTS)
- Insufficient certificate validation
- Using deprecated hash functions (MD5, SHA1)

### Prevention Checklist
- [ ] Classify data according to privacy laws and business requirements
- [ ] Don't store unnecessary sensitive data
- [ ] Encrypt all data in transit with TLS
- [ ] Encrypt all sensitive data at rest
- [ ] Use up-to-date and strong standard algorithms
- [ ] Store passwords with strong adaptive hashing (Argon2, bcrypt)
- [ ] Use authenticated encryption
- [ ] Generate keys cryptographically randomly

### Search Patterns
```
# Encryption usage
grep -r "crypto\|encrypt\|decrypt\|hash\|bcrypt\|argon2"
grep -r "MD5\|SHA1\|DES\|RC4"

# TLS/HTTPS
grep -r "http://\|https://\|HTTPS\|TLS\|SSL"
grep -r "HSTS\|Strict-Transport-Security"

# Sensitive data
grep -r "password\|secret\|apiKey\|api_key\|token\|credential"
```

---

## A03:2021 - Injection

### Description
Injection flaws occur when untrusted data is sent to an interpreter as part of a command or query.

### Types
- SQL Injection
- NoSQL Injection
- OS Command Injection
- LDAP Injection
- XSS (Cross-Site Scripting)
- Template Injection

### Prevention Checklist
- [ ] Use parameterized queries (prepared statements)
- [ ] Use positive server-side input validation
- [ ] Escape special characters for the specific interpreter
- [ ] Use LIMIT and other SQL controls to prevent mass disclosure
- [ ] Implement Content Security Policy (CSP)
- [ ] Use auto-escaping template engines

### Search Patterns
```
# SQL queries
grep -r "SELECT.*FROM\|INSERT.*INTO\|UPDATE.*SET\|DELETE.*FROM"
grep -r "query(\|execute(\|exec("
grep -r "\$\{.*\}.*SELECT\|`.*\$.*`.*SELECT"

# Command execution
grep -r "exec(\|spawn(\|system(\|popen\|shell_exec\|eval("

# XSS vectors
grep -r "innerHTML\|outerHTML\|document\.write\|v-html"
grep -r "dangerouslySetInnerHTML"

# Input handling
grep -r "req\.body\|req\.query\|req\.params\|request\.form"
```

---

## A04:2021 - Insecure Design

### Description
A new category focusing on risks related to design flaws. Insecure design cannot be fixed by perfect implementation - the required security controls were never created.

### Vulnerability Examples
- Missing business logic validation
- No rate limiting on sensitive functions
- Missing defense in depth
- Insufficient separation of responsibilities
- Lack of threat modeling

### Prevention Checklist
- [ ] Use secure development lifecycle
- [ ] Use threat modeling for critical auth, access control, and business logic
- [ ] Integrate security language in user stories
- [ ] Write unit and integration tests for security controls
- [ ] Implement tiered architecture
- [ ] Limit resource consumption

### Search Patterns
```
# Rate limiting
grep -r "rateLimit\|throttle\|limiter"

# Validation
grep -r "validate\|validator\|schema\|Joi\|Yup\|Zod"

# Error handling
grep -r "try.*catch\|\.catch(\|onError"
```

---

## A05:2021 - Security Misconfiguration

### Description
The application may be vulnerable if it has insecure default settings, incomplete configurations, open cloud storage, misconfigured HTTP headers, or verbose error messages.

### Vulnerability Examples
- Unnecessary features enabled (ports, services, pages)
- Default accounts and passwords still active
- Error messages show stack traces
- Security features disabled or not configured
- Outdated or vulnerable software

### Prevention Checklist
- [ ] Repeatable hardening process
- [ ] Minimal platform without unnecessary features
- [ ] Review and update configurations regularly
- [ ] Automated process to verify effectiveness
- [ ] Send security directives to clients (Security Headers)
- [ ] Segmented application architecture

### Search Patterns
```
# Security headers
grep -r "X-Frame-Options\|X-Content-Type-Options\|X-XSS-Protection"
grep -r "Content-Security-Policy\|Referrer-Policy"
grep -r "helmet\|securityHeaders"

# Debug/development settings
grep -r "DEBUG\|debug.*true\|NODE_ENV\|development"
grep -r "console\.log\|console\.error"

# Default credentials
grep -r "admin\|password\|123456\|default"
```

---

## A06:2021 - Vulnerable and Outdated Components

### Description
Components such as libraries, frameworks, and other software modules run with the same privileges as the application. If a vulnerable component is exploited, it can lead to serious data loss or server takeover.

### Vulnerability Indicators
- Unknown versions of all components
- Outdated or unsupported software
- Not regularly scanning for vulnerabilities
- Not timely patching or upgrading
- Developers don't test compatibility of updated libraries

### Prevention Checklist
- [ ] Remove unused dependencies
- [ ] Continuously inventory component versions
- [ ] Monitor sources like CVE and NVD for vulnerabilities
- [ ] Only obtain components from official sources via secure links
- [ ] Monitor unmaintained libraries
- [ ] Use automated tools like Dependabot or Renovate

### Search Patterns
```
# Package files
cat package.json
cat package-lock.json
cat requirements.txt
cat go.mod
cat Cargo.toml

# Vulnerability scanning
npm audit
pip-audit
cargo audit
```

---

## A07:2021 - Identification and Authentication Failures

### Description
Confirmation of user identity, authentication, and session management is critical to protect against authentication-related attacks.

### Vulnerability Indicators
- Permits automated attacks like credential stuffing
- Permits brute force attacks
- Allows weak passwords
- Weak credential recovery processes
- Session identifier visible in URL
- Sessions not properly invalidated

### Prevention Checklist
- [ ] Implement multi-factor authentication
- [ ] Don't deploy with default credentials
- [ ] Implement weak-password checks
- [ ] Use same messages for all authentication outcomes
- [ ] Limit or delay failed login attempts
- [ ] Use server-side session manager with high entropy
- [ ] Generate new session ID after login

### Search Patterns
```
# Authentication
grep -r "login\|logout\|authenticate\|signIn\|signOut"
grep -r "session\|jwt\|token\|cookie"
grep -r "password\|credential\|auth"

# Session handling
grep -r "session\.destroy\|session\.regenerate\|invalidate"
grep -r "maxAge\|expires\|httpOnly\|secure"
```

---

## A08:2021 - Software and Data Integrity Failures

### Description
Software and data integrity failures relate to code and infrastructure that does not protect against integrity violations. Includes insecure deserialization.

### Vulnerability Examples
- Using untrusted CDNs or repositories
- Auto-update functionality without integrity verification
- Insecure CI/CD pipelines
- Deserializing untrusted data

### Prevention Checklist
- [ ] Use digital signatures to verify software origin
- [ ] Ensure libraries come from trusted repositories
- [ ] Use software supply chain security tool
- [ ] Review process for code and configuration changes
- [ ] Ensure CI/CD pipeline has proper segregation and access control
- [ ] Avoid deserializing untrusted data

### Search Patterns
```
# Deserialization
grep -r "deserialize\|unserialize\|pickle\|marshal"
grep -r "JSON\.parse\|yaml\.load\|fromJSON"

# External resources
grep -r "cdn\.\|unpkg\|jsdelivr\|cloudflare"
grep -r "integrity=\|crossorigin"

# CI/CD files
find . -name ".github" -o -name "azure-pipelines" -o -name "Jenkinsfile"
```

---

## A09:2021 - Security Logging and Monitoring Failures

### Description
Without logging and monitoring, breaches cannot be detected. Insufficient logging, detection, monitoring, and active response occurs when attacks are not detected in a timely manner.

### Vulnerability Indicators
- Auditable events not logged
- Warnings and errors generate unclear log messages
- Logs only stored locally
- No alerting thresholds and response escalation processes
- Penetration tests and scans don't trigger alerts

### Prevention Checklist
- [ ] Log all login, access control, and input validation failures
- [ ] Ensure logs are in a format that log management solutions can use
- [ ] Ensure high-value transactions have audit trail
- [ ] Establish effective monitoring and alerting
- [ ] Establish incident response and recovery plan
- [ ] Sanitize logs to prevent log injection

### Search Patterns
```
# Logging
grep -r "logger\|log\.\|console\.log\|winston\|pino\|bunyan"
grep -r "audit\|trace\|info\|warn\|error\|debug"

# Monitoring
grep -r "monitor\|metrics\|telemetry\|applicationInsights"
grep -r "sentry\|datadog\|newrelic"
```

---

## A10:2021 - Server-Side Request Forgery (SSRF)

### Description
SSRF flaws occur when a web application fetches a remote resource without validating the user-supplied URL. This allows an attacker to coerce the application to send requests to unexpected destinations.

### Attack Vectors
- Access to internal services behind firewalls
- Scanning internal ports
- Reading local files
- Accessing cloud provider metadata services

### Prevention Checklist (Network Layer)
- [ ] Segment remote resource access in separate networks
- [ ] Enforce "deny by default" firewall policies

### Prevention Checklist (Application Layer)
- [ ] Sanitize and validate all client-supplied input data
- [ ] Enforce URL schema, port, and destination with positive allow list
- [ ] Don't send raw responses to clients
- [ ] Disable HTTP redirections
- [ ] Be aware of URL consistency to avoid DNS rebinding

### Search Patterns
```
# URL fetching
grep -r "fetch(\|axios\|request(\|http\.get\|https\.get"
grep -r "urllib\|requests\.get\|httpClient"
grep -r "url.*=.*req\|url.*=.*params\|url.*=.*body"

# Redirect handling
grep -r "redirect\|followRedirect\|maxRedirects"

# Internal addresses
grep -r "localhost\|127\.0\.0\.1\|0\.0\.0\.0\|::1"
grep -r "169\.254\|10\.\|172\.16\|192\.168"
```

---

## Solution Type Reference

### Frontend-Only Applications
Primary concerns:
- A03: XSS prevention (DOM manipulation, template injection)
- A05: Security headers (CSP, HSTS, X-Frame-Options)
- A06: Client-side dependencies
- A08: CDN integrity (SRI hashes)

Limited concerns:
- A01: Client-side access control (easily bypassed)
- A02: Token storage, no server-side encryption
- A07: Token handling only

Not applicable:
- A10: No server-side requests

### Backend-Only / API Applications
Full scope on all guidelines, with focus on:
- A01: Authorization on every endpoint
- A02: Data encryption at rest and in transit
- A03: All injection types
- A07: Authentication implementation
- A10: SSRF if external URLs are processed

### Full-Stack Applications
All guidelines apply with full scope.

### Libraries / Packages
Primary concerns:
- A04: Secure design patterns
- A06: Own dependencies
- A08: Build and publish integrity

Limited concerns:
- Most runtime concerns depend on consumer implementation
