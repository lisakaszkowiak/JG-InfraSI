
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
resource "docker_network" "catalogue_net" {
    name = "catalogue_net"
}



# Volume PostgreSQL
resource "docker_volume" "pg_data" {
    name = "pg_data"
}

resource "docker_container" "postgres" {
    name = "catalogue_postgre"
    image = "postgres:15-alpine"

    env = [
        "POSTGRES_USER=catalogue",
        "POSTGRES_PASSWORD=catalogue",
        "POSTGRES_DB=catalogue",
    ]

    networks_advanced {
        name = docker_network.catalogue_net.name
    }

    mounts {
        target = "/var/lib/postgresql/data"
        source = docker_volume.pg_data.name
        type   = "volume"
    }

    ports {
        internal = 5432
        external = 5432
    }
}



# Volume Redis
resource "docker_container" "redis" {
  name  = "catalogue-redis"
  image = "redis:7-alpine"

  networks_advanced {
    name = docker_network.catalogue_net.name
  }

  ports {
    internal = 6379
    external = 6379
  }
}



# Build API
resource "docker_image" "catalogue_api" {
  name = "catalogue-api:latest"

  build {
    context = "${path.module}/api"
  }
}

resource "docker_container" "catalogue_api" {
  name  = "catalogue-api"
  image = docker_image.catalogue_api.image_id

  networks_advanced {
    name = docker_network.catalogue_net.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "PORT=3000",
    "PGHOST=catalogue-postgres",
    "PGUSER=catalogue",
    "PGPASSWORD=catalogue",
    "PGDATABASE=catalogue",
    "REDIS_HOST=catalogue-redis",
    "REDIS_PORT=6379"
  ]

  depends_on = [
    docker_container.postgres,
    docker_container.redis
  ]
}


