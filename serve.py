#!/usr/bin/env python3
"""SPA-aware static server: serves index.html for any path that isn't a real file."""
import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

BUILD_DIR = os.path.join(os.path.dirname(__file__), "build", "web")

class SPAHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=BUILD_DIR, **kwargs)

    def do_GET(self):
        # Strip query string for file lookup
        path = self.path.split("?")[0].split("#")[0]
        full = os.path.join(BUILD_DIR, path.lstrip("/"))
        # If the file doesn't exist, serve index.html (SPA fallback)
        if not os.path.exists(full) or os.path.isdir(full):
            self.path = "/index.html"
        return super().do_GET()

    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)

if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 5000
    server = HTTPServer(("0.0.0.0", port), SPAHandler)
    print(f"Serving {BUILD_DIR} on port {port}", flush=True)
    server.serve_forever()
