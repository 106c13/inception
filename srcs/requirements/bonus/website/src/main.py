from flask import Flask, render_template

app = Flask(__name__)

STACK = {
    "services": [
        {
            "name": "nginx",
            "role": "reverse-proxy / TLS",
            "ports": ["8443:443"],
            "links_to": ["wordpress"]
        },
        {
            "name": "wordpress",
            "role": "php-fpm / app",
            "ports": ["9000:9000"],
            "links_to": ["mariadb"]
        },
        {
            "name": "mariadb",
            "role": "database",
            "volumes": ["/var/lib/mariadb:/var/lib/mysql (host -> container)"],
            "links_to": []
        },
        {
            "name": "ftp",
            "role": "ftpd (passive)",
            "ports": ["2121:21"],
            "notes": "use passive ports in your Docker config",
            "links_to": []
        }
    ],
    "network": "docker-network",
    "notes": [
        "nginx listens on 8443 and proxies requests to wordpress:9000 (php-fpm).",
        "mariadb runs with persisted volume(s).",
        "ftp exposed on 2121; consider passive data ports and firewall rules."
    ]
}

@app.route("/")
def index():
    return render_template("index.html", stack=STACK)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
