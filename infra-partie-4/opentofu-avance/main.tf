# Provider
terraform{
    required_providers{
        docker = {
            source = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

provider "docker" {}

# Réseau Docker
    resource "docker_network" "devops_net" {
        name = "devops_net"
    }



# Volume PostgreSQL
    resource "docker_volume" "pg_data" {
        name = "pg_data"
    }

    resource "docker_container" "pg_container" {
        name = "pg_container"
        image = "postgres:15-alpine"
        

        env = [
            "POSTGRES_USER      =${var.Prostgres_user}",
            "POSTGRES_PASSWORD  =${var.Prostgres_password}",
            "POSTGRES_DB        =${var.Prostgres_DB}",
        ]

        networks_advanced {
            name = docker_network.devops_net.name
        }

        mounts {
            target = "/var/lib/postgresql/data"
            source = docker_volume.pg_data.name
            type   = "volume"
        }

        ports {
            internal = var.Prostgres_port_internal
            external = var.Prostgres_port_external
        }
    }


# Volume Gitea
    resource "docker_volume" "gitea_volume" {
        name = "gitea_volume"
    }

    resource "docker_container" "gitea_container" {
        name  = "gitea_container"
        image = "gitea/gitea:latest"

        env = [
            "USER_UID                       =${var.Gitea_uid}",
            "USER_GID                       =${var.Gitea_gid}",
#            "GITEA__database__DB_TYPE       =postgres",
#            "GITEA__database__HOST          =db:${var.Prostgres_port_internal}",
#            "GITEA__database__NAME          =${var.Prostgres_DB}",
#            "GITEA__database__USER          =${var.Prostgres_user}",
#            "GITEA__database__PASSWD        =${var.Prostgres_password}",
            "GITEAserverDOMAIN              =localhost",
            "GITEAserverROOT_URL            =http://localhost:${var.Gitea_port_external}/"
        ]

        networks_advanced {
            name = docker_network.devops_net.name
        }

        mounts {
            target = "/data"
            source = docker_volume.gitea_volume.name
            type   = "volume"
        }

        ports {
            internal = var.Gitea_port_internal
            external = var.Gitea_port_external
        }
    }
        
# Volume Jenkins
    resource "docker_volume" "jenkins_volume" {
        name = "jenkins_volume"
    }

    resource "docker_container" "jenkins_container" {
        name  = "jenkins_container"
        image = "jenkins/jenkins:lts-jdk21"

        networks_advanced {
            name = docker_network.devops_net.name
        }

        mounts {
            target = "/var/jenkins_home"
            source = docker_volume.jenkins_volume.name
            type   = "volume"
        }

        depends_on = [
            docker_network.devops_net
        ]

        ports {
            internal = var.Jenkins_port_internal
            external = var.Jenkins_port_external
        }

        ports {
            internal = var.Jenkins_agent_internal
            external = var.Jenkins_agent_external
        }

    }

# Volume SonarQube
    resource "docker_volume" "sonarqube_volume" {
        name = "sonarqube_volume"
      
    }
    
    resource "docker_container" "sonarqube_container" {
        name  = "sonarqube_container"
        image = "sonarqube:community"

        env=[
            "SONARQUBE_JDBC_URL=jdbc:postgresql://db:${var.Prostgres_port_internal}/${var.Prostgres_DB}",
            "SONARQUBE_JDBC_USERNAME=${var.Prostgres_user}",
            "SONARQUBE_JDBC_PASSWORD=${var.Prostgres_password}"
        ]

        networks_advanced {
            name = docker_network.devops_net.name
        }

        mounts {
            target = "/opt/sonarqube/data"
            source = docker_volume.sonarqube_volume.name
            type   = "volume"
        }

        ports {
            internal = var.SonarQube_port_internal
            external = var.SonarQube_port_external
        }
      
    }
