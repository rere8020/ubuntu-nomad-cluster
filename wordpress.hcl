job "get-wordpress" {
    datacenters = ["dc1"]
    type = "service"
    
    affinity {
      attribute = "${attr.unique.hostname}"
      value = "nomad-agent2"
      weight = 100
    }
    group "webs" {
        count = 2 

        network {
            port "http" {
                static = 80
            }
        }
        
        task "frontend" {
            driver = "docker"

            artifact {
                source = "https://wordpress.org/wordpress-5.6.tar.gz"
                destination = "local/wordpress"
                options {
                    checksum = "md5:cfc30949a5cd2d3b52151cb78bfa1a70"  
                }
            }
            config {
                image = "httpd"
            }

            service {
                port = "http"
            }

            env {
                DB_HOST = "db01.example.com"
                DB_USER = "web"
                DB_PASS = "password"
            }
        }    
    }
}
