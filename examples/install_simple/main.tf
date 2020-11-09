
data "google_compute_network" "forseti_network" {
  name    = var.network
  project = var.project_id
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  name                               = "cloud-nat-${var.project_id}"
  create_router                      = true
  network                            = var.network
  project_id                         = var.project_id
  region                             = var.region
  router                             = "router-${var.project_id}"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetworks = [
    {
      name                     = var.subnetwork
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    }
  ]
}

module "forseti-install-simple" {
  source = "../../"

  # General
  project_id = var.project_id
  org_id     = var.org_id
  domain     = var.domain
  network    = var.network
  subnetwork = var.subnetwork

  # Client VM
  client_instance_metadata = var.instance_metadata
  client_private           = var.private
  client_region            = module.cloud-nat.region
  client_tags              = var.instance_tags

  # CloudSQL
  cloudsql_private = var.private
  cloudsql_region  = var.region

  # Forseti
  forseti_email_recipient = var.forseti_email_recipient
  forseti_email_sender    = var.forseti_email_sender
  forseti_version         = var.forseti_version
  gsuite_admin_email      = var.gsuite_admin_email
  sendgrid_api_key        = var.sendgrid_api_key

  # GCS
  storage_bucket_location = var.region
  bucket_cai_location     = var.region

  # Server VM
  server_instance_metadata = var.instance_metadata
  server_private           = var.private
  server_region            = module.cloud-nat.region
  server_tags              = var.instance_tags
}
