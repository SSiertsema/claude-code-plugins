# Contributing

<!--
TEMPLATE INSTRUCTIONS:
Guide external or team contributors on how to contribute to the project.
Investigate: existing CONTRIBUTING.md, PR templates, code style configs.
-->

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone <your-fork-url>`
3. Set up the development environment (see [Development Setup](./development-setup.md))
4. Create a branch for your changes

## Development Workflow

### Branch Naming

Use descriptive branch names:

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/description` | `feature/add-user-auth` |
| Bug fix | `fix/description` | `fix/login-validation` |
| Docs | `docs/description` | `docs/api-examples` |
| Refactor | `refactor/description` | `refactor/simplify-db-queries` |

### Making Changes

1. Create a new branch from `main`:
   ```bash
   git checkout -b feature/your-feature
   ```

2. Make your changes with clear, focused commits

3. Write/update tests for your changes

4. Ensure all tests pass:
   ```bash
   npm test
   ```

5. Ensure code passes linting:
   ```bash
   npm run lint
   ```

## Commit Messages

<!--
Document commit message conventions.
-->

Follow conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add password reset functionality
fix(api): handle null response from external service
docs(readme): update installation instructions
```

## Pull Requests

### Before Submitting

- [ ] Tests pass locally
- [ ] Linting passes
- [ ] Documentation updated (if applicable)
- [ ] Commit messages follow conventions
- [ ] Branch is up to date with `main`

### PR Description

Include in your PR description:
- **What**: What changes does this PR make?
- **Why**: Why are these changes needed?
- **How**: How were these changes implemented?
- **Testing**: How did you test these changes?

### Review Process

1. Submit your PR
2. Automated checks will run (tests, linting)
3. A maintainer will review your code
4. Address any feedback
5. Once approved, your PR will be merged

## Code Style

<!--
Document code style expectations.
Reference style configs (.eslintrc, .prettierrc, etc.)
-->

This project uses automated formatting and linting:

- **Formatter**: Prettier
- **Linter**: ESLint

Run before committing:
```bash
npm run format
npm run lint
```

### Style Guidelines

-
-
-

## Testing Requirements

<!--
Document testing expectations for contributions.
-->

- All new features must include tests
- Bug fixes should include a test that would have caught the bug
- Maintain or improve code coverage

See [Testing](./testing.md) for details on writing tests.

## Documentation

<!--
When should contributors update docs?
-->

Update documentation when:
- Adding new features
- Changing existing behavior
- Modifying configuration options
- Updating dependencies with breaking changes

## Getting Help

<!--
How can contributors get help?
-->

- Open an issue for bugs or feature requests
- Start a discussion for questions
-

## Code of Conduct

<!--
Reference or include code of conduct.
-->

This project follows [Contributor Covenant](https://www.contributor-covenant.org/). Please be respectful and inclusive in all interactions.
