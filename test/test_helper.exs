ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MySqrft.Repo, :manual)

# Note: Storybook modules are excluded from test coverage calculations.
# Storybook files in the `storybook/` directory and related modules like
# `Storybook.*`, `Mix.Tasks.MySqrft.Storybook.*`, and `MySqrftWeb.Storybook`
# are development/documentation tools and should not be included in coverage metrics.
