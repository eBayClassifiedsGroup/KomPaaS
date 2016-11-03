# KomPaaS

Compact PaaS - PoC - playgroud mode - small based golang app PaaS closed in one container

* Requirements:
  * docker 1.9 or higher
  * `docker pull python:alpine` #(only for an example)

* Components:
  * Nomad
  * Consul
  * Fabio
  * Nomad-ui (with docker-compose only)

* Most important ports:
  * Consul ui: 8500
  * Fabio  ui: 9998
  * Nomad  ui: 80
  * Fabio router: 9999

## Build image or get it
```bash
$ ./build.it
```
or
```bash
$ docker pull kompaas/kompaas
```

## Usage:
### interactive:
(tmux knowledge required)
```bash
$ docker run \
  --net=host \
  --privileged \
  --volume "/var/run/docker.sock:/var/run/docker.sock" \
  --volume "/tmp:/tmp" \
  -ti kompaas/kompaas tmux attach
```
### docker compose:
```bash
$ docker-compose up -d
Creating kompaas_consul_1
Creating kompaas_nomad_1
Creating kompaas_fabio_1
Creating kompaas_nui_1
```

## Start example
if you run tmux:
```bash
$ nomad run example.nomad
```
else:
```bash
$ docker exec -ti kompaas_nomad_1 nomad run example.nomad
==> Monitoring evaluation "cbbea755"
    Evaluation triggered by job "example"
    Allocation "b00798bf" created: node "4522e2f4", group "python"
    Allocation "64a73a0f" created: node "4522e2f4", group "python"
    Allocation "669afa7b" created: node "4522e2f4", group "python"
    Allocation "80de4c42" created: node "4522e2f4", group "python"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "cbbea755" finished with status "complete"

$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                                                  NAMES
5920ecba205e        python:alpine            "/bin/sh -c 'echo $HO"   7 seconds ago       Up 6 seconds        127.0.0.1:31873->8000/tcp, 127.0.0.1:31873->8000/udp   server-64a73a0f-5999-fcc2-6aa6-b1cf228d1b74
91a51e1ced32        python:alpine            "/bin/sh -c 'echo $HO"   7 seconds ago       Up 6 seconds        127.0.0.1:42008->8000/tcp, 127.0.0.1:42008->8000/udp   server-80de4c42-4786-2c09-40c9-69002c7f79b4
f1ea7b8984ef        python:alpine            "/bin/sh -c 'echo $HO"   7 seconds ago       Up 6 seconds        127.0.0.1:28821->8000/tcp, 127.0.0.1:28821->8000/udp   server-b00798bf-8b32-c40a-a5fb-6496c7112748
66df4804ee1e        python:alpine            "/bin/sh -c 'echo $HO"   7 seconds ago       Up 6 seconds        127.0.0.1:55579->8000/tcp, 127.0.0.1:55579->8000/udp   server-669afa7b-8f33-9dbd-0f21-c83ccf369485
557511c14cf5        kompaas/kompaas          "fabio"                  17 seconds ago      Up 16 seconds                                                              kompaas_fabio_1
b538488d26ac        kompaas/kompaas          "consul agent -client"   17 seconds ago      Up 16 seconds                                                              kompaas_consul_1
0f643244ef92        kompaas/kompaas          "nomad agent -dev"       17 seconds ago      Up 16 seconds                                                              kompaas_nomad_1
e30d12884ce5        chuyskywalker/nomad-ui   "apache2-foreground"     17 seconds ago      Up 16 seconds                                                              kompaas_nui_1
```

## Test example
```bash
$ while true; do
    curl -H 'Host: python.service.consul' http://localhost:9999
  done
```
