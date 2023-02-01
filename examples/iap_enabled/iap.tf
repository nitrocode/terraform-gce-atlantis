# These are the resources needed specifically in order to get IAP to
# function. Note that some are used as inputs to the atlantis module in
# main.tf.

# Note that you can only have a single IAP brand per project; if you are
# already using IAP in this project you will not need this resource.
resource "google_iap_brand" "example" {
  support_email     = "you@example.com"
  application_title = "Atlantis"
  project           = local.project_id
}

resource "google_iap_client" "atlantis" {
  display_name = "Atlantis"
  brand        = google_iap_brand.example.name
  project      = local.project_id
}

# This resource allows access to Atlantis. Note that a binding resource
# is canonical for this specific role for the project, and overrides any
# other controls for the project. If that isn't desirable, you may want
# to grant these permissions with another resource.
resource "google_iap_web_backend_service_iam_binding" "atlantis" {
  web_backend_service = module.atlantis.iap_backend_service_name
  role                = "roles/iap.httpsResourceAccessor"
  members = [
    "user:you@example.com",
  ]
  project = local.project_id
}
