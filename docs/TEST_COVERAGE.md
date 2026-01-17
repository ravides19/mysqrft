# Test Coverage Configuration

## Storybook Files Exclusion

Storybook files are excluded from test coverage calculations because they are development/documentation tools, not production code that requires test coverage.

### Files/Modules Excluded:
- All files in the `storybook/` directory
- `Storybook.*` modules (auto-generated storybook component modules)
- `Mix.Tasks.MySqrft.Storybook.*` (Mix tasks for storybook)
- `MySqrftWeb.Storybook` (Storybook configuration module)
- `MySqrftWeb.Storybook.ComponentDefaults` (Component defaults helper)

### How to Filter Coverage

When calculating test coverage, you can manually filter out storybook-related modules from the coverage report. The `.coverignore` file documents which modules should be excluded.

### Running Tests with Coverage

```bash
# Run tests with coverage
mix test --cover

# Coverage reports are generated in the `cover/` directory
# Open cover/index.html to view detailed coverage reports
```

### Calculating Coverage Percentage (Excluding Storybook)

When reviewing coverage reports, exclude storybook-related modules from your calculations. The coverage tool itself doesn't automatically exclude these files, so manual filtering is required when analyzing coverage metrics.
