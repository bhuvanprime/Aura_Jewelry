#!/usr/bin/env bash
# Exit on error
set -o errexit

echo "==> Setting up Flutter on Render environment..."

# Download and extract stable Flutter SDK if not cached
if [ ! -d "$HOME/flutter" ]; then
  cd $HOME
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
  cd -
fi

export PATH="$HOME/flutter/bin:$PATH"

echo "==> Verifying Flutter version..."
flutter --version

echo "==> Installing Flutter dependencies..."
flutter pub get

echo "==> Building optimized Flutter Web application..."
flutter build web --release --base-href="/"

echo "==> Installing Node.js server dependencies..."
npm install

echo "==> Build completed successfully!"
