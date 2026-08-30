#!/usr/bin/env bash
# Exit on error
set -o errexit

echo "==> [Render Build] Setting up Flutter SDK..."

# Download and extract stable Flutter SDK if not cached
if [ ! -d "$HOME/flutter" ]; then
  cd "$HOME"
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
  cd -
fi

export PATH="$HOME/flutter/bin:$PATH"

echo "==> [Render Build] Flutter Version:"
flutter --version

echo "==> [Render Build] Fetching Flutter dependencies..."
flutter pub get

echo "==> [Render Build] Building Release Web Application..."
flutter build web --release --base-href="/"

echo "==> [Render Build] Web build completed successfully!"
