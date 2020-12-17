job "consul" {
    datacenters = ["dc1"]
    group "consul" {
        count = 1
        task "consul" {
            driver = "exec"
            
            config {
                command = "consul"
                args = ["agent", "-dev"]
            }
            
            artifact {
                source = "https://releases.hashicorp.com/consul/1.9.0/consul_1.9.0_linux_amd64.zip"
                destination = "/usr/local/bin"
                options {
                    checksum = "sha256:409b964f9cec93ba4aa3f767fe3a57e14160d86ffab63c3697d188ba29d247ce"
                }
            }
        }
    }
}