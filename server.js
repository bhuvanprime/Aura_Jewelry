const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Path to compiled Flutter web build
const buildPath = path.join(__dirname, 'build', 'web');

// Serve static assets with caching
app.use(express.static(buildPath, {
  maxAge: '1d',
  setHeaders: (res, filePath) => {
    if (filePath.endsWith('.html')) {
      res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    }
  }
}));

// SPA history fallback routing for Flutter Web
app.get('*', (req, res) => {
  res.sendFile(path.join(buildPath, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Aura Luxury Jewelry server is running on port ${PORT}`);
});
