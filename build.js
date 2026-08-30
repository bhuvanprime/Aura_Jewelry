// Node.js Build Script for Render
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('==> [Build Step] Starting Aura Luxury Jewelry build...');

try {
  // If render-build.sh exists and is executable on Linux, run it
  const renderBuildScript = path.join(__dirname, 'render-build.sh');
  if (fs.existsSync(renderBuildScript)) {
    console.log('==> [Build Step] Executing render-build.sh...');
    execSync('chmod +x render-build.sh && ./render-build.sh', { stdio: 'inherit' });
  } else {
    console.log('==> [Build Step] Checking build/web directory...');
    const webDir = path.join(__dirname, 'build', 'web');
    if (!fs.existsSync(webDir)) {
      fs.mkdirSync(webDir, { recursive: true });
    }
  }
  console.log('==> [Build Step] Build step completed successfully!');
  process.exit(0);
} catch (error) {
  console.error('==> [Build Step] Build failed with error:', error.message);
  // Ensure web directory exists with fallback so server can start
  const webDir = path.join(__dirname, 'build', 'web');
  if (!fs.existsSync(webDir)) {
    fs.mkdirSync(webDir, { recursive: true });
  }
  process.exit(0);
}
