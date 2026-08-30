// Zero-dependency production HTTP static server for Flutter Web on Render
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 8080;
const WEB_DIR = path.join(__dirname, 'build', 'web');

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.mjs': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.wasm': 'application/wasm',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.txt': 'text/plain; charset=utf-8',
};

function serveFile(res, filePath, contentType) {
  fs.readFile(filePath, (err, content) => {
    if (err) {
      // If file read fails, serve index.html (SPA Fallback)
      serveIndex(res);
    } else {
      res.writeHead(200, {
        'Content-Type': contentType || 'application/octet-stream',
        'Cache-Control': filePath.endsWith('.html') ? 'no-cache' : 'public, max-age=86400',
        'X-Frame-Options': 'SAMEORIGIN',
        'X-Content-Type-Options': 'nosniff',
      });
      res.end(content);
    }
  });
}

function serveIndex(res) {
  const indexPath = path.join(WEB_DIR, 'index.html');
  fs.readFile(indexPath, (err, content) => {
    if (err) {
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end('<!DOCTYPE html><html><head><title>Aura Luxury Jewelry</title></head><body style="background:#F8F1E0;font-family:sans-serif;text-align:center;padding:50px;"><h1 style="color:#5C0F1E;">Aura Luxury Jewelry</h1><p>Application is initializing...</p></body></html>');
    } else {
      res.writeHead(200, {
        'Content-Type': 'text/html; charset=utf-8',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
      });
      res.end(content);
    }
  });
}

const server = http.createServer((req, res) => {
  // Normalize request URL
  const cleanUrl = req.url.split('?')[0];
  let safePath = path.normalize(cleanUrl).replace(/^(\.\.[\/\\])+/, '');
  if (safePath === '/' || safePath === '\\') {
    safePath = '/index.html';
  }

  const filePath = path.join(WEB_DIR, safePath);

  fs.stat(filePath, (err, stats) => {
    if (!err && stats.isFile()) {
      const ext = path.extname(filePath).toLowerCase();
      const mime = MIME_TYPES[ext] || 'application/octet-stream';
      serveFile(res, filePath, mime);
    } else {
      // Fallback to SPA index.html for Flutter routes
      serveIndex(res);
    }
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`==> Aura Luxury Jewelry Web Server running on port ${PORT}`);
});
