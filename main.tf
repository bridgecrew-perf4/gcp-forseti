


module "forseti" {
    source                      =   "./modules/forseti"
    project_id                  =   var.project_id
    org_id                      =   var.org_id
    domain                      =   var.domain
    folder_id                   =   var.folder_id
    cloudsql_type               =   var.cloudsql_type
    client_type                 =   var.client_type
    server_type                 =   var.server_type
    violations_slack_webhook    =   var.violations_slack_webhook
    
}