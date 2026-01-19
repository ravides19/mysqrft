# This file defines Postgres types with PostGIS extension support.
# `Postgrex.Types.define/3` must be called at the top level, outside of any
# module or function, so it is defined once at compile time instead of on init.
Postgrex.Types.define(
  MySqrft.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
