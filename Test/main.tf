# Networking Resources
resource "google_compute_network" "vpc1" {
  name                    = "vpc1"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "default1" {
  name    = "default-firewall1"
  network = google_compute_network.vpc1.name

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
resource "google_compute_http_health_check" "default1" {
  name               = "http-health-check1"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_backend_service" "backend_service1" {
  name                    = "backend-service1"
  health_checks           = [google_compute_http_health_check.default1.self_link]
  protocol                = "HTTP"
  port_name               = "http"
  timeout_sec             = 10
}

resource "google_compute_url_map" "url_map1" {
  name            = "url-map1"
  default_service = google_compute_backend_service.backend_service1.self_link
}

resource "google_compute_target_http_proxy" "http_proxy1" {
  name    = "http-proxy1"
  url_map = google_compute_url_map.url_map1.self_link
}

resource "google_compute_global_forwarding_rule" "forwarding_rule1" {
  name       = "forwarding-rule1"
  target     = google_compute_target_http_proxy.http_proxy1.self_link
  port_range = "80"
}

# Autoscaling Resources
resource "google_compute_instance_template" "template1" {
  name_prefix  = "instance-template-1"
  machine_type = var.machine_type

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc1.self_link
  }



  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance_group_manager" "manager5" {
  name               = "instance-group-manager4"
  base_instance_name = "new-instance"
  zone               = var.zone
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.template1.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "autoscaler9" {
  name   = "autoscaler9"
  zone   = var.zone
  target = google_compute_instance_group_manager.manager5.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60
  }
}

# MySQL Database
resource "google_sql_database_instance" "instance1" {
  name             = "database-instance1"
  database_version = "MYSQL_5_7"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database1" {
  name     = var.db_name
  instance = google_sql_database_instance.instance1.name
}

resource "google_sql_user" "users1" {
  name     = var.db_user
  instance = google_sql_database_instance.instance1.name
  password = var.db_password
}

# Secret Manager
resource "google_secret_manager_secret" "secret5" {
  secret_id = var.secret_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "version1" {
  secret      = google_secret_manager_secret.secret5.id
  secret_data = var.db_password
}