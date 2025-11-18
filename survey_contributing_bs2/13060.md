# Contributing to Awesome Windsurf

Thank you for your interest in contributing to Awesome Windsurf! We welcome all contributions, big or small:

- Found a typo? Please fix it! (Though this shouldn't be possible because of [CHECKS.md](CHECKS.md))
- Have an idea for improvement? Open an issue!
- Want to add your prompts? We'd love to see them!
- Something unclear? Help us improve the docs!

Every contribution makes Windsurf better for everyone. Don't hesitate to:

- Open issues for questions or suggestions
- Submit pull requests for any improvements
- Start discussions on Discord or GitHub Discussions

## General Guidelines

1. Ensure your contribution adds value to the Windsurf community
2. Follow the existing style and format of the repository
3. Keep descriptions clear and concise
4. Test any code or commands before submitting
5. Follow our [quality check guidelines](CHECKS.md) for consistency

## How to contribute

1. Fork the repository to your GitHub account

2. Clone your fork locally:

   ```bash
   git clone https://github.com/YOUR_USERNAME/awesome-windsurf.git
   cd awesome-windsurf
   ```

3. Install dependencies and set up Git hooks:

   ```bash
   npm install
   ```

   This will install all required dependencies and set up Git hooks through Husky automatically.

4. Create a new branch for your changes:

   ```bash
   git checkout -b your-branch-name
   ```

5. Make your changes and commit them using conventional commits:

   ```bash
   git add .
   git commit -m "type: description"
   ```

   Example commit messages:

   - `git commit -m "add: add link to windsurf docs"`
   - `git commit -m "update: improve clarity of installation steps"`
   - `git commit -m "remove: remove old documentation"`
   - `git commit -m "fix: correct typos in README"`
   - `git commit -m "meta: update commitlint configuration"`
   - `git commit -m "release: added significant new section X"`

6. Push to your fork:

   ```bash
   git push origin your-branch-name
   ```

7. Open a Pull Request from your fork to our main branch

### Pull Request Requirements

1. **PR Content**:

   - Write a clear title and description explaining your changes
   - Link to any related issues

2. **Markdown Quality**: All markdown files must pass the markdownlint checks

   - This is automatically checked by GitHub Actions
   - It's also enforced by the pre-commit hook

3. **Release Notes**: Changes are automatically tracked
   - Release notes are generated automatically by GitHub
   - Changes are categorized automatically based on commit types and PR content

## Development

All code quality checks (formatting, linting, link checking) are automatically run when you commit changes through our pre-commit hooks. Just make your changes and commit - the hooks will ensure everything is properly formatted and validated.

For GitHub Actions workflow details, see [CHECKS.md](CHECKS.md).

## Release Process

Our releases are managed automatically by [semantic-release](https://semantic-release.gitbook.io/semantic-release). This means:

1. **Version Numbers**: We follow [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH)

   - PATCH (e.g., 1.0.0 -> 1.0.1): Backwards-compatible bug fixes
   - MINOR (e.g., 1.0.0 -> 1.1.0): New content/features, backwards-compatible
   - MAJOR (e.g., 1.0.0 -> 2.0.0): Breaking changes

2. **Commit Messages**: Your commit type determines the next version

   - `fix: message` -> Patch release
   - `feat: message` -> Minor release
   - Any commit with `BREAKING CHANGE:` in its footer -> Major release

   Examples:

   ```bash
   # Patch release (1.0.0 -> 1.0.1)
   git commit -m "fix: correct typo in installation guide"

   # Minor release (1.0.0 -> 1.1.0)
   git commit -m "feat: add new section on windsurfing spots"

   # Major release (1.0.0 -> 2.0.0)
   git commit -m "feat: reorganize entire documentation structure

   BREAKING CHANGE: All sections have been reorganized with a new structure"
   ```

3. **Release Process**:

   - Merging to `main` triggers a release check
   - Changes are analyzed automatically
   - Release notes are generated from commit messages
   - A new GitHub release is created with the appropriate version
   - Git tags are created automatically

4. **What Gets Released**:
   - Documentation fixes -> Patch version
   - New content/sections -> Minor version
   - Major reorganizations -> Major version
   - Purely technical changes (like workflow updates) -> No version change

Note: All version management and releases are handled entirely by semantic-release through GitHub Actions. This ensures consistency across all contributors.

## Contributing Prompts

For detailed information about contributing prompts, including:

- Directory structure
- Standard files and naming
- Documentation requirements

Please see [memories/README.md](memories/README.md).

## Git Hooks

We use [husky](https://github.com/typicode/husky) to manage our Git hooks. These hooks ensure code quality and consistency:

### commit-msg

- Validates commit message format
- Ensures messages follow pattern: `type: description`
- Valid types: `add`, `update`, `remove`, `fix`, `meta`, `release`

### pre-commit

- Runs linting checks via lint-staged
- Ensures code style consistency
- Validates markdown files

Note: All version management, changelog updates, and releases are handled entirely by GitHub Actions through our auto-release workflow, not local hooks. This ensures consistency across all contributors.

## Need Help?

If you have questions or need help with your contribution:

1. Check existing issues and pull requests
2. Join the Discord community at the top of [README.md](README.md)
3. Open a new issue for discussion

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Follow the project's code style and guidelines

Thank you for contributing to making Windsurf better for everyone!
