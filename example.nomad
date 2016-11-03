job "example" {
	datacenters = ["dc1"]
	#constraint {
	#	attribute = "$attr.kernel.name"
	#	value = "linux"
	#}
	update {
		stagger = "10s"
		max_parallel = 2
	}
	group "python" {
		count = 4
		restart {
			interval = "5m"
			attempts = 10
			delay = "2s"
			mode = "delay"
		}
		task "server" {
			driver = "docker"
			config {                        
				image = "python:alpine"
				command= "/bin/sh"
                                args = ["-c", "echo $HOSTNAME >index.html && python3 -m http.server 8000"]
				port_map {                                                                      
					myhttp = 8000                                                               
				}                                                                         
			}
			service {
				tags = ["global", "urlprefix-python/", "urlprefix-python.service.consul/"]
				port = "myhttp"
				check {
					name = "alive"
					type = "tcp"
					interval = "10s"
					timeout = "2s"
				}
			}
			resources {
				cpu = 500 # 500 Mhz
				memory = 256 # 256MB
				network {
					mbits = 10
					port "myhttp" {
					}
				}
			}
		}
	}
}
