# NCSC ICT-Beveiligingsrichtlijnen voor Webapplicaties - Juli 2024

Dit bestand bevat de NCSC richtlijnen referentie voor de multi-agent audit.

---

## Overzicht Domeinen

| Code | Domein | Beschrijving |
|------|--------|--------------|
| U/TV | Toegangsvoorzieningsmiddelen | Authenticatie en identiteitsbeheer |
| U/WA | Webapplicaties | Applicatiebeveiliging |
| U/PW | Platformen en webservers | Server en platform configuratie |
| U/NW | Netwerken | Netwerkbeveiliging |

---

## U/TV: Toegangsvoorzieningsmiddelen

### U/TV.01 - Authenticatie van webapplicatiegebruikers

**Prioriteit:** Hoog

**Beschrijving:**
Bij toegang tot een webapplicatie wordt door middel van een authenticatiemechanisme de identiteit van de gebruiker vastgesteld voordat deze toegang krijgt.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Vóór toegang tot de webapplicatie vindt authenticatie plaats | Hoog |
| 02 | Gevoelige handelingen worden voorafgegaan door herauthenticatie met minimaal hetzelfde betrouwbaarheidsniveau | Hoog |
| 03 | Er vindt geen client-side authenticatie plaats | Hoog |
| 04 | Authenticatietokens worden server-side gegenereerd met voldoende entropie en beperkte levensduur | Hoog |
| 05 | Bij authenticatie met wachtwoord wordt sterke opslag toegepast (PBKDF2, scrypt, bcrypt, Argon2) | Hoog |
| 06 | Wachtwoordcontrole vindt uitsluitend server-side plaats | Hoog |
| 07 | Wachtwoorden worden tijdens transport beschermd | Hoog |
| 08 | Wachtwoordverificatie is niet vatbaar voor timing attacks | Midden |
| 09 | Authenticatiepogingen worden gelimiteerd (rate limiting, lockout, CAPTCHA) | Hoog |
| 10 | Bij authenticatiefalen wordt geen informatie over bestaande accounts vrijgegeven | Midden |
| 11 | Wachtwoorden worden niet automatisch ingevuld (autocomplete=off voor wachtwoord en OTP velden) | Laag |
| 12 | Wachtwoord-reset genereert een nieuw sterk random wachtwoord of een time-limited reset-link | Midden |
| 13 | Wachtwoordsterktevereisten worden afgedwongen (lengte, complexiteit, niet in breach-databases) | Hoog |
| 14 | MFA wordt geactiveerd bij toegang tot gevoelige onderdelen | Hoog |

**Zoekpatronen:**
```bash
# Authenticatie mechanismen
grep -r "login\|logout\|authenticate\|signIn\|signOut\|auth"
grep -r "password\|wachtwoord\|credential\|token"

# Wachtwoord hashing
grep -r "bcrypt\|argon2\|pbkdf2\|scrypt\|hash"

# Rate limiting
grep -r "rateLimit\|throttle\|limiter\|attempts"

# Session/token handling
grep -r "session\|jwt\|token\|cookie"

# MFA
grep -r "mfa\|2fa\|totp\|otp\|authenticator"
```

---

## U/WA: Webapplicaties

### U/WA.01 - Sessiemanagement

**Prioriteit:** Hoog

**Beschrijving:**
De webapplicatie maakt voor sessiebeheer alleen gebruik van mechanismen die de webserver biedt. Geen client-side sessie-identifiers.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Sessie-identifiers worden server-side aangemaakt met voldoende entropie (minimaal 128 bits) | Hoog |
| 02 | Nieuwe sessie-identifier wordt aangemaakt na succesvolle aanmelding | Hoog |
| 03 | Sessie-identifiers worden uitsluitend via HTTP(S) cookies uitgewisseld met HttpOnly en Secure flags | Hoog |
| 04 | Sessies krijgen server-side een timeout ingesteld | Hoog |
| 05 | Geïnvalideerde sessies op de server worden verwijderd | Midden |
| 06 | Bij uitloggen wordt de sessie aan server en client-side geïnvalideerd | Hoog |

**Zoekpatronen:**
```bash
# Session configuratie
grep -r "session\|Session"
grep -r "httpOnly\|HttpOnly\|secure\|Secure"
grep -r "maxAge\|expires\|timeout"

# Cookie settings
grep -r "cookie\|Cookie"
grep -r "sameSite\|SameSite"

# Session invalidation
grep -r "destroy\|invalidate\|logout\|signOut"
```

---

### U/WA.02 - Invoervalidatie

**Prioriteit:** Hoog

**Beschrijving:**
Alle invoer naar de webapplicatie wordt server-side gevalideerd en waar nodig gesanitized om injection aanvallen te voorkomen.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Alle invoer wordt server-side gevalideerd | Hoog |
| 02 | Content-Type header wordt gecontroleerd en alleen verwachte types worden geaccepteerd | Midden |
| 03 | Invoervalidatie is gebaseerd op een allow-list (whitelisting) | Hoog |
| 04 | Foutafhandeling geeft geen gevoelige informatie vrij | Midden |
| 05 | Gestructureerde invoer wordt geparsed en gevalideerd | Hoog |
| 06 | Client-side validatie wordt alleen gebruikt voor gebruikerservaring, niet voor beveiliging | Hoog |

**Zoekpatronen:**
```bash
# Input validation
grep -r "validate\|validator\|sanitize\|escape"
grep -r "req\.body\|req\.query\|req\.params\|request\."

# Schema validation
grep -r "Joi\|Yup\|Zod\|ajv\|schema"

# Content-Type checking
grep -r "Content-Type\|contentType\|application/json"

# Allow-list patterns
grep -r "whitelist\|allowlist\|allowList"
```

---

### U/WA.03 - Uitvoerbeveiliging

**Prioriteit:** Hoog

**Beschrijving:**
Alle uitvoer naar de client wordt beveiligd tegen injection aanvallen, met name XSS.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Dynamische uitvoer wordt context-afhankelijk geëscaped | Hoog |
| 02 | Content Security Policy (CSP) header wordt toegepast | Hoog |
| 03 | X-Content-Type-Options: nosniff wordt toegepast | Midden |
| 04 | Auto-escaping templating engine wordt gebruikt | Hoog |
| 05 | Inline JavaScript en CSS worden vermeden of via nonces/hashes toegestaan | Midden |

**Zoekpatronen:**
```bash
# XSS vectors
grep -r "innerHTML\|outerHTML\|document\.write\|v-html"
grep -r "dangerouslySetInnerHTML"

# Escaping
grep -r "escape\|encode\|sanitize"

# CSP
grep -r "Content-Security-Policy\|CSP"

# Security headers
grep -r "X-Content-Type-Options\|X-Frame-Options\|X-XSS-Protection"
grep -r "helmet"
```

---

### U/WA.04 - Beveiliging tegen SQL/NoSQL-injectie

**Prioriteit:** Hoog

**Beschrijving:**
De webapplicatie is beveiligd tegen SQL en NoSQL injection door gebruik van parameterized queries.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Alleen parameterized queries of prepared statements worden gebruikt | Hoog |
| 02 | ORM/ODM wordt gebruikt waar mogelijk | Midden |
| 03 | Database-accounts hebben minimale privileges (least privilege) | Hoog |
| 04 | Database-foutmeldingen worden niet aan gebruikers getoond | Midden |

**Zoekpatronen:**
```bash
# SQL queries
grep -r "SELECT.*FROM\|INSERT.*INTO\|UPDATE.*SET\|DELETE.*FROM"
grep -r "query(\|execute(\|exec("
grep -r '\$\{.*\}.*SELECT\|`.*\$.*`.*SELECT'

# NoSQL
grep -r "find(\|findOne(\|aggregate("
grep -r '\$where\|\$regex\|\$gt\|\$lt'

# ORM/ODM
grep -r "sequelize\|typeorm\|mongoose\|prisma"
```

---

### U/WA.05 - Beveiliging tegen OS command injection

**Prioriteit:** Hoog

**Beschrijving:**
De webapplicatie voorkomt OS command injection door geen shell commands uit te voeren met gebruikersinvoer.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Shell commands met gebruikersinvoer worden vermeden | Hoog |
| 02 | Indien onvermijdelijk: strikte validatie en escaping van argumenten | Hoog |
| 03 | API-aanroepen worden geprefereerd boven shell commands | Midden |

**Zoekpatronen:**
```bash
# Command execution
grep -r "exec(\|spawn(\|system(\|popen"
grep -r "child_process\|subprocess\|shell_exec"
grep -r "eval(\|Function("
```

---

### U/WA.06 - Beveiliging tegen path traversal

**Prioriteit:** Hoog

**Beschrijving:**
De webapplicatie voorkomt path traversal aanvallen bij bestandsoperaties.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Bestandsnamen van gebruikers worden gevalideerd tegen path traversal | Hoog |
| 02 | Canonicalisatie wordt toegepast voordat bestanden worden geopend | Hoog |
| 03 | Bestandsoperaties vinden plaats binnen een beperkte directory (chroot/jail) | Midden |

**Zoekpatronen:**
```bash
# File operations
grep -r "readFile\|writeFile\|fs\.\|open(\|path\."
grep -r "\.\.\/\|\.\.\\\\|path\.join\|path\.resolve"

# User input in paths
grep -r "req\.params.*path\|req\.query.*file\|req\.body.*filename"
```

---

### U/WA.07 - Beveiliging tegen Server-Side Request Forgery (SSRF)

**Prioriteit:** Hoog

**Beschrijving:**
De webapplicatie voorkomt SSRF door URL's van gebruikers te valideren.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | URLs van gebruikers worden gevalideerd tegen een allow-list | Hoog |
| 02 | Interne netwerkadressen worden geblokkeerd (localhost, 10.x, 172.16.x, 192.168.x) | Hoog |
| 03 | HTTP redirects worden niet automatisch gevolgd of gevalideerd | Midden |
| 04 | Response data wordt niet direct aan gebruikers doorgegeven | Midden |

**Zoekpatronen:**
```bash
# URL fetching
grep -r "fetch(\|axios\|request(\|http\.get\|https\.get"
grep -r "urllib\|requests\.get\|httpClient"

# URL from user input
grep -r "url.*=.*req\|url.*=.*params\|url.*=.*body"

# Internal addresses
grep -r "localhost\|127\.0\.0\.1\|0\.0\.0\.0\|::1"
grep -r "169\.254\|10\.\|172\.16\|192\.168"
```

---

### U/WA.08 - Cross-Site Request Forgery (CSRF) bescherming

**Prioriteit:** Hoog

**Beschrijving:**
De webapplicatie implementeert CSRF-bescherming voor state-changing operaties.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | CSRF-tokens worden gebruikt voor state-changing requests | Hoog |
| 02 | SameSite cookie attribute wordt ingesteld op Strict of Lax | Hoog |
| 03 | Origin/Referer header wordt gevalideerd | Midden |
| 04 | Gevoelige acties vereisen re-authenticatie | Midden |

**Zoekpatronen:**
```bash
# CSRF protection
grep -r "csrf\|CSRF\|xsrf\|XSRF"
grep -r "csurf\|lusca"

# SameSite
grep -r "sameSite\|SameSite"

# Origin/Referer validation
grep -r "origin\|referer\|Referer\|Origin"
```

---

### U/WA.09 - API-beveiliging

**Prioriteit:** Hoog

**Beschrijving:**
API's worden beveiligd met authenticatie, autorisatie en rate limiting.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Alle API-endpoints vereisen authenticatie (tenzij publiek) | Hoog |
| 02 | Autorisatie wordt per endpoint en actie gecontroleerd | Hoog |
| 03 | Rate limiting wordt toegepast per gebruiker/IP | Hoog |
| 04 | API-versioning wordt toegepast | Laag |
| 05 | Input/output wordt gevalideerd tegen een schema | Hoog |
| 06 | CORS wordt restrictief geconfigureerd | Hoog |

**Zoekpatronen:**
```bash
# API authentication
grep -r "Bearer\|Authorization\|api[Kk]ey\|apiKey"
grep -r "middleware\|authenticate\|authorize"

# Rate limiting
grep -r "rateLimit\|throttle\|express-rate-limit"

# CORS
grep -r "cors\|CORS\|Access-Control"

# Schema validation
grep -r "swagger\|openapi\|joi\|yup\|zod"
```

---

## U/PW: Platformen en Webservers

### U/PW.01 - HTTPS/TLS configuratie

**Prioriteit:** Hoog

**Beschrijving:**
Alle communicatie verloopt via HTTPS met actuele TLS-versie.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Alleen HTTPS wordt ondersteund (HTTP wordt geredirect) | Hoog |
| 02 | TLS 1.2 of hoger wordt vereist | Hoog |
| 03 | Sterke cipher suites worden geconfigureerd | Hoog |
| 04 | HSTS header wordt verstuurd met voldoende max-age | Hoog |
| 05 | Certificaten zijn geldig en correct geconfigureerd | Hoog |

**Zoekpatronen:**
```bash
# TLS configuration
grep -r "https\|HTTPS\|ssl\|SSL\|tls\|TLS"
grep -r "Strict-Transport-Security\|HSTS"

# Certificate handling
grep -r "cert\|certificate\|key\.pem\|cert\.pem"
```

---

### U/PW.02 - Security headers

**Prioriteit:** Hoog

**Beschrijving:**
Relevante HTTP security headers worden geconfigureerd.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Content-Security-Policy header is geconfigureerd | Hoog |
| 02 | X-Content-Type-Options: nosniff | Midden |
| 03 | X-Frame-Options: DENY of SAMEORIGIN | Midden |
| 04 | Referrer-Policy is geconfigureerd | Laag |
| 05 | Permissions-Policy beperkt browser features | Laag |
| 06 | Cache-Control headers voor gevoelige responses | Midden |

**Zoekpatronen:**
```bash
# Security headers
grep -r "Content-Security-Policy\|CSP"
grep -r "X-Content-Type-Options\|X-Frame-Options\|X-XSS-Protection"
grep -r "Referrer-Policy\|Permissions-Policy"
grep -r "Cache-Control\|no-store\|no-cache"
grep -r "helmet"
```

---

### U/PW.03 - Foutafhandeling

**Prioriteit:** Midden

**Beschrijving:**
Foutmeldingen geven geen gevoelige informatie prijs.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Stack traces worden niet aan eindgebruikers getoond | Hoog |
| 02 | Generieke foutpagina's worden gebruikt in productie | Midden |
| 03 | Foutdetails worden server-side gelogd | Midden |

**Zoekpatronen:**
```bash
# Error handling
grep -r "try.*catch\|\.catch(\|onError"
grep -r "stack\|stackTrace\|trace"
grep -r "NODE_ENV\|production\|development"

# Error display
grep -r "res\.status.*500\|InternalServerError"
```

---

### U/PW.04 - Logging en monitoring

**Prioriteit:** Hoog

**Beschrijving:**
Security-relevante events worden gelogd en gemonitord.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Authenticatiepogingen (succes en falen) worden gelogd | Hoog |
| 02 | Autorisatiefouten worden gelogd | Hoog |
| 03 | Invoervalidatiefouten worden gelogd | Midden |
| 04 | Logs bevatten geen gevoelige data (wachtwoorden, tokens) | Hoog |
| 05 | Log-integriteit wordt beschermd | Midden |
| 06 | Alerting is geconfigureerd voor kritieke events | Hoog |

**Zoekpatronen:**
```bash
# Logging
grep -r "logger\|log\.\|winston\|pino\|bunyan"
grep -r "console\.log\|console\.error\|console\.warn"

# Monitoring
grep -r "metrics\|telemetry\|monitor"
grep -r "sentry\|datadog\|newrelic\|applicationInsights"
```

---

### U/PW.05 - Server hardening

**Prioriteit:** Hoog

**Beschrijving:**
De webserver is gehardened volgens best practices.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Onnodige services en modules zijn uitgeschakeld | Hoog |
| 02 | Server versie-informatie wordt niet vrijgegeven | Midden |
| 03 | Directory listing is uitgeschakeld | Midden |
| 04 | Standaard credentials zijn gewijzigd | Hoog |
| 05 | Debug mode is uitgeschakeld in productie | Hoog |

**Zoekpatronen:**
```bash
# Server configuration
grep -r "X-Powered-By\|Server:\|nginx\|apache"
grep -r "express\.disable\|removeHeader"

# Debug settings
grep -r "DEBUG\|debug.*true\|development"
grep -r "verbose\|trace"
```

---

### U/PW.06 - Bestandsbeheer

**Prioriteit:** Midden

**Beschrijving:**
Bestanden worden veilig beheerd en geüpload.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Bestandsuploads worden gevalideerd (type, grootte, inhoud) | Hoog |
| 02 | Geüploade bestanden worden opgeslagen buiten de webroot | Hoog |
| 03 | Bestandsnamen worden gesanitized | Hoog |
| 04 | Bestanden worden gescand op malware indien applicable | Midden |

**Zoekpatronen:**
```bash
# File uploads
grep -r "upload\|multer\|formidable\|busboy"
grep -r "mimetype\|mimeType\|content-type"

# File size limits
grep -r "maxFileSize\|limit\|maxSize"
```

---

### U/PW.07 - Dependency management

**Prioriteit:** Hoog

**Beschrijving:**
Dependencies worden beheerd en gemonitord op kwetsbaarheden.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Dependencies komen van vertrouwde bronnen | Hoog |
| 02 | Dependency versies zijn vastgelegd (lock files) | Hoog |
| 03 | Dependencies worden regelmatig gecontroleerd op kwetsbaarheden | Hoog |
| 04 | Ongebruikte dependencies worden verwijderd | Midden |
| 05 | Automatische updates zijn geconfigureerd (Dependabot, Renovate) | Midden |

**Zoekpatronen:**
```bash
# Package files
cat package.json
cat package-lock.json
cat requirements.txt
cat go.mod

# Dependency scanning
npm audit
yarn audit
pip-audit
```

---

### U/PW.08 - Secrets management

**Prioriteit:** Hoog

**Beschrijving:**
Secrets worden veilig beheerd en niet in code opgeslagen.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Secrets staan niet in broncode of versiecontrole | Hoog |
| 02 | Environment variables of secret manager wordt gebruikt | Hoog |
| 03 | Secrets worden geroteerd | Midden |
| 04 | Toegang tot secrets is beperkt (least privilege) | Hoog |

**Zoekpatronen:**
```bash
# Hardcoded secrets
grep -r "password.*=\|secret.*=\|apiKey.*=\|api_key.*="
grep -r "PRIVATE_KEY\|SECRET_KEY\|ACCESS_KEY"

# Environment variables
grep -r "process\.env\|os\.environ\|getenv"

# Secret patterns
grep -r "sk_live\|pk_live\|ghp_\|gho_"
```

---

## U/NW: Netwerken

### U/NW.01 - Netwerksegmentatie

**Prioriteit:** Hoog

**Beschrijving:**
Netwerksegmentatie scheidt applicatiecomponenten.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Database is niet direct bereikbaar vanaf internet | Hoog |
| 02 | Interne services zijn gescheiden van externe | Hoog |
| 03 | Firewall regels volgen least privilege | Hoog |

**Zoekpatronen:**
```bash
# Network configuration
grep -r "host\|hostname\|port"
grep -r "docker-compose\|kubernetes\|k8s"

# Database connections
grep -r "mongodb://\|postgres://\|mysql://\|redis://"
```

---

### U/NW.02 - WAF/Reverse proxy

**Prioriteit:** Midden

**Beschrijving:**
Een WAF of reverse proxy biedt extra bescherming.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | WAF is geconfigureerd voor bekende aanvalspatronen | Midden |
| 02 | Reverse proxy verbergt backend details | Midden |
| 03 | DDoS-bescherming is geactiveerd | Midden |

**Zoekpatronen:**
```bash
# WAF/Proxy configuration
grep -r "nginx\|apache\|cloudflare\|akamai"
grep -r "proxy_pass\|upstream"
```

---

### U/NW.03 - DNS-beveiliging

**Prioriteit:** Midden

**Beschrijving:**
DNS is beveiligd met DNSSEC en CAA records.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | DNSSEC is geactiveerd | Midden |
| 02 | CAA records beperken certificaat-uitgifte | Laag |

---

### U/NW.04 - Ingress/Egress filtering

**Prioriteit:** Hoog

**Beschrijving:**
Inkomend en uitgaand verkeer wordt gefilterd.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Alleen noodzakelijke poorten zijn open | Hoog |
| 02 | Uitgaand verkeer is beperkt tot noodzakelijke bestemmingen | Midden |
| 03 | Egress filtering voorkomt data exfiltratie | Midden |

---

### U/NW.05 - Load balancing

**Prioriteit:** Midden

**Beschrijving:**
Load balancing zorgt voor beschikbaarheid en kan helpen bij DDoS-mitigatie.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Load balancer termineert TLS | Midden |
| 02 | Health checks zijn geconfigureerd | Midden |
| 03 | Session affinity is geconfigureerd indien nodig | Laag |

---

### U/NW.06 - Service mesh security

**Prioriteit:** Midden

**Beschrijving:**
In microservices architecturen wordt mTLS toegepast.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Service-to-service communicatie gebruikt mTLS | Midden |
| 02 | Service identiteit wordt geverifieerd | Midden |

**Zoekpatronen:**
```bash
# Service mesh
grep -r "istio\|linkerd\|envoy"
grep -r "mtls\|mTLS\|mutual"
```

---

### U/NW.07 - API Gateway

**Prioriteit:** Midden

**Beschrijving:**
API Gateway centraliseert security controls.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | API Gateway handelt authenticatie af | Midden |
| 02 | Rate limiting wordt centraal toegepast | Hoog |
| 03 | Request/response validatie vindt plaats | Midden |

**Zoekpatronen:**
```bash
# API Gateway
grep -r "kong\|tyk\|apigee\|aws.*gateway"
```

---

### U/NW.08 - Container network security

**Prioriteit:** Midden

**Beschrijving:**
Container netwerken zijn beveiligd.

**Maatregelen:**

| Nr | Maatregel | Prioriteit |
|----|-----------|------------|
| 01 | Containers draaien niet in host network mode | Hoog |
| 02 | Network policies beperken inter-container communicatie | Midden |
| 03 | Containers gebruiken non-root users | Hoog |

**Zoekpatronen:**
```bash
# Container configuration
grep -r "docker\|Dockerfile\|container"
grep -r "network_mode\|networkMode"
grep -r "USER\|user:"
```

---

## Solution Type Matrix

| Richtlijn | Frontend | Backend | Full-Stack | Library |
|-----------|----------|---------|------------|---------|
| U/TV.01 Authenticatie | Partial | Full | Full | N/A |
| U/WA.01 Sessiemanagement | Partial | Full | Full | N/A |
| U/WA.02 Invoervalidatie | Client-side | Full | Full | Depends |
| U/WA.03 Uitvoerbeveiliging | Full | API | Full | Depends |
| U/WA.04 SQL/NoSQL-injectie | N/A | Full | Full | Depends |
| U/WA.05 OS command injection | N/A | Full | Full | Depends |
| U/WA.06 Path traversal | N/A | Full | Full | Depends |
| U/WA.07 SSRF | N/A | Full | Full | Depends |
| U/WA.08 CSRF | Partial | Full | Full | N/A |
| U/WA.09 API-beveiliging | Partial | Full | Full | N/A |
| U/PW.01 HTTPS/TLS | Headers | Full | Full | N/A |
| U/PW.02 Security headers | Full | Full | Full | N/A |
| U/PW.03 Foutafhandeling | Limited | Full | Full | Depends |
| U/PW.04 Logging | Client | Full | Full | N/A |
| U/PW.05 Server hardening | N/A | Full | Full | N/A |
| U/PW.06 Bestandsbeheer | N/A | Full | Full | N/A |
| U/PW.07 Dependencies | Full | Full | Full | Full |
| U/PW.08 Secrets management | Limited | Full | Full | Full |
| U/NW.01-08 Netwerken | N/A | Full | Full | N/A |

---

## Prioriteit Levels

| Prioriteit | Beschrijving | Actie |
|------------|--------------|-------|
| **Hoog** | Fundamentele beveiligingsmaatregel | Direct implementeren |
| **Midden** | Belangrijke verbetering | Plannen binnen 30 dagen |
| **Laag** | Best practice | Opnemen in roadmap |

---

## OpenCRE Referenties

De NCSC richtlijnen zijn gekoppeld aan OpenCRE (Common Requirements Enumeration) voor cross-mapping naar andere standaarden:

- OWASP Top 10
- ASVS (Application Security Verification Standard)
- NIST Guidelines
- ISO 27001/27002

Zie: https://www.opencre.org/

---

*Bron: NCSC ICT-beveiligingsrichtlijnen voor webapplicaties, Juli 2024*
