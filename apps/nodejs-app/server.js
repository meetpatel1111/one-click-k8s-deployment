const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

// Base path for the Node.js app (matches Ingress path)
const basePath = "/nodejs";

// Serve static files relative to basePath
app.use(basePath, express.static(path.join(__dirname, "public")));

// Route for the base path → serve index.html
app.get(basePath, (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

// Optional: catch-all route for subpaths under /nodejs
app.get(`${basePath}/*`, (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.listen(PORT, () => {
  console.log(`Node.js app running at http://localhost:${PORT}${basePath}`);
});
