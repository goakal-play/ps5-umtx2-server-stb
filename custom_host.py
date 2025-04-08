import http.server, ssl, time, re, threading
from http.server import SimpleHTTPRequestHandler, HTTPServer

class RequestHandler(SimpleHTTPRequestHandler):
    def replace_locale(self):
        self.path = re.sub(r'^/document/\w{2}/ps5', '/document/en/ps5', self.path)

    def do_GET(self):
        if self.path in ['/', '', '/index.html']:
            self.send_response(302)
            self.send_header('Location', '/document/en/ps5/')
            self.end_headers()
            return
        self.replace_locale()
        return super().do_GET()

    def do_POST(self):
        self.replace_locale()
        tn = self.path.lstrip('/document/en/ps5/')
        print('!POST!: tn:\n'  + tn)
        fn = tn
        if not tn.startswith("T_"):
            if fn != "a.bin":
                print('!POST!: INFO: '  + str(self.rfile.read(int(self.headers['Content-length']))), "utf-8")
                return
            else:
                fn = time.strftime("%Y%m%d-%H%M%S") + ".bin"
        print('!POST!: ' + self.path + ' -->> ' + fn)
        print('test: %d' % int(self.headers['Content-length']))
        data = self.rfile.read(int(self.headers['Content-length']))
        open(fn, "wb").write(data)

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

def run_http():
    server_address = ('0.0.0.0', 80)
    httpd = HTTPServer(server_address, RequestHandler)
    print('Running HTTP server on port 80')
    httpd.serve_forever()

def run_https():
    server_address = ('0.0.0.0', 443)
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certfile='localhost.pem')
    httpd = HTTPServer(server_address, RequestHandler)
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
    print('Running HTTPS server on port 443')
    httpd.serve_forever()

# Jalankan HTTP dan HTTPS secara paralel
threading.Thread(target=run_http, daemon=True).start()
run_https()  # Biarkan HTTPS di foreground agar log tampil dan systemd bisa monitor