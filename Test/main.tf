# Networking Resources
resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "default" {
  name    = "default-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Load Balancer Resources
resource "google_compute_http_health_check" "default" {
  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_backend_service" "backend_service" {
  name                    = "backend-service"
  health_checks           = [google_compute_http_health_check.default.self_link]
  protocol                = "HTTP"
  port_name               = "http"
  timeout_sec             = 10
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}

# Autoscaling Resources
resource "google_compute_instance_template" "template" {
  name_prefix  = "instance-template-"
  machine_type = var.machine_type

  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc.self_link
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2 php php-mysql
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php
  EOT

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance_group_manager" "manager" {
  name               = "instance-group-manager"
  base_instance_name = "instance"
  zone               = var.zone
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.manager.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60
  }
}

# Secret Manager
resource "google_secret_manager_secret" "secret" {
  secret_id = "db-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.db_password
}

# Autoscaling Resources
resource "google_compute_instance_template" "template1" {
  name_prefix  = "instance-template-"
  machine_type = var.machine_type

   disk {
    source_image = "debian-cloud/debian-11"
    disk_size_gb = 250
  }

  network_interface {
    network = google_compute_network.vpc.self_link
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2 php php-mysql
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php
  EOT

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance_group_manager" "manager1" {
  name               = "instance-group-manager"
  base_instance_name = "instance"
  zone               = var.zone
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "autoscaler1" {
  name   = "autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.manager.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60
  }
}

# MySQL Database
resource "google_sql_database_instance" "instance" {
  name             = "database-instance"
  database_version = "MYSQL_5_7"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}


# Secret Manager
resource "google_secret_manager_secret" "secret1" {
  secret_id = "db-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "version1" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.db_password
}