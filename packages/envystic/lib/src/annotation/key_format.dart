/// The format of key names in the environment file (e.g., `.env` file).
enum KeyFormat {
  /// No specific formatting applied to key names.
  none,

  /// Key names in `kebab-case` format.
  kebab,

  /// Key names in `snake_case` format.
  snake,

  /// Key names in `PascalCase` format.
  pascal,

  /// Key names in `SCREAMING_SNAKE_CASE` format.
  screamingSnake,
}
