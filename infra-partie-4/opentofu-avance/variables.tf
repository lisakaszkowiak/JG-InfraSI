# Var Postgres
    variable "Prostgres_user" {
    type = string
    default = "simple"
    }

    variable "Prostgres_password" {
    type = string
    default = "simple"
    }

    variable "Prostgres_DB" {
    type = string
    default = "simple"
    }

    variable "Prostgres_port_internal" {
    type = number
    default = 5432
    }

    variable "Prostgres_port_external" {
    type = number
    default = 5432
    }

# Var Gitea
    variable "Gitea_uid" {
    type = number
    default = 1000
    }

    variable "Gitea_gid" {
    type = number
    default = 1000
    }

    variable "Gitea_port_internal" {
    type = number
    default = 3000
    }   

    variable "Gitea_port_external" {
    type = number
    default = 3000
    }   

# Var Jenkins
    variable "Jenkins_port_internal" {
    type = number
    default = 8080
    }   

    variable "Jenkins_port_external" {
    type = number
    default = 8080
    }

    variable "Jenkins_agent_internal" {
    type = number
    default = 5000
    }   

    variable "Jenkins_agent_external" {
    type = number
    default = 5000
    }

 # Var SonarQube
    variable "SonarQube_port_internal" {
    type = number
    default = 9000
    }   

    variable "SonarQube_port_external" {
    type = number
    default = 9000
    }