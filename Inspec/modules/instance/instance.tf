resource "google_compute_instance" "inspec_instance" {
  count        = var.enabled == true ? 1 : 0
  name         = "${var.name}-${var.environment}-${var.namespace}-instance"
  machine_type = var.machine_type
  zone         = var.zone

  tags = [
  "http-server",
  "https-server"
]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }

  metadata = {
    startup-script = <<SCRIPT
    sudo apt-get -y update
    # Install Nginx, Docker Engine, Docker-Compose, and PreReqs
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get -y install nginx docker-ce docker-ce-cli containerd.io
    export HOSTNAME=$(hostname | tr -d '\n')
    export PRIVATE_IP=$(curl -sf -H 'Metadata-Flavor:Google' http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip | tr -d '\n')
    echo "Welcome to $HOSTNAME - $PRIVATE_IP" > /usr/share/nginx/www/index.html
    service nginx start
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
    # Enable docker
    sudo service docker start
    sudo docker run hello-world
    SCRIPT
  }

  service_account {
    email = "patriciaanong@inspecplaygroundgcp.iam.gserviceaccount.com"
    scopes = var.scopes
  }
}

resource "google_compute_firewall" "http-server" {
  #depends_on  = [ google_compute_instance.inspec_instance[0] ]
  count       = var.enabled == true ? 1 : 0
  name        = "default-allow-http"
  network     = var.network

  allow {
    protocol = "tcp"
    ports    = [ "80" ]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = var.http_source_ips
  target_tags   = [ "http-server" ]
}

resource "google_compute_firewall" "https-server" {
  #depends_on  = [ google_compute_instance.inspec_instance[0] ]
  count       = var.enabled == true ? 1 : 0
  name        = "default-allow-https"
  network     = var.network

  allow {
    protocol = "tcp"
    ports    = [ "443" ]
  }

  // Allow traffic from everywhere to instances with an https-server tag
  source_ranges = var.https_source_ips
  target_tags   = [ "https-server" ]
}