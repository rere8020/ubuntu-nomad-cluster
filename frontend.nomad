job "frontend" {
    datacenters = ["dc1"]
    type = "service"

    group "frontend" {
        scaling {
            enabled = true
            min = 5
            max = 10
            policy {
            }
        }
        task "frontend" {
            driver = "docker"

            config {
                image = "thedojoseries/frontend"
            }
            resources {
                network {
                    port "http" {}
                }
            }
            service {
                name = "frontend"
                port = "http"

                tags = [
                    "frontend",
                    "urlprefix-/"
                ] 

                check {
                    type = "http"
                    path = "/"
                    interval = "5s"
                    timeout = "2s"
                }
            }
        }
    }
}