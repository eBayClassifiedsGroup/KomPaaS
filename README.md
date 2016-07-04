# KomPaaS

Compact PaaS - PoC - playgroud mode - for small based golang app PaaS closed in one container

Requirements:
* docker 1.9
* docker pull ubuntu:14.04 (for demo example)

Components:
* Nomad
* Consul
* Fabio
* Nomad-ui (with docker-compose only)


## Build image or get it
```bash
./build.it
```
or
```bash
docker pull kompaas/kompaas
```

## Usage:
### interactive:
(tmux knowledge required)
```bash
docker run \
  --net=host \
  --privileged \
  --volume "/var/run/docker.sock:/var/run/docker.sock" \
  --volume "/tmp:/tmp" \
  -ti kompaas tmux attach
```
### docker compose:
```
# docker-compose up -d
Creating kompaas_consul_1
Creating kompaas_nomad_1
Creating kompaas_fabio_1
Creating kompaas_nui_1
```

## Start example
```
# docker exec -ti kompaas_nomad_1 nomad run example.nomad
==> Monitoring evaluation "daaac916-5ba2-12b4-7991-7670451e662c"
    Evaluation triggered by job "example"
    Allocation "042f2327-0e0b-555f-c131-9f44fc5dd572" created: node "b8ac357a-10cb-d2c3-8032-b2102f071455", group "python"
    Allocation "6622c917-4535-7644-eaab-af79680af3d1" created: node "b8ac357a-10cb-d2c3-8032-b2102f071455", group "python"
    Allocation "a9f83225-5459-cb3a-3cb8-c16d432431cb" created: node "b8ac357a-10cb-d2c3-8032-b2102f071455", group "python"
    Allocation "c93bc1c6-0c46-293e-b99e-e341c85db66f" created: node "b8ac357a-10cb-d2c3-8032-b2102f071455", group "python"
    Allocation "6622c917-4535-7644-eaab-af79680af3d1" status changed: "pending" -> "running" ({"server":{"State":"running","Events":[{"Type":"Started","Time":1448355157694202511,"DriverError":"","ExitCode":0,"Signal":0,"Message":"","KillError":""}]}})
    Allocation "042f2327-0e0b-555f-c131-9f44fc5dd572" status changed: "pending" -> "running" ({"server":{"State":"running","Events":[{"Type":"Started","Time":1448355157507603871,"DriverError":"","ExitCode":0,"Signal":0,"Message":"","KillError":""}]}})
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "daaac916-5ba2-12b4-7991-7670451e662c" finished with status "complete"
# docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                                                  NAMES
4b01aa6c79e1        ubuntu:14.04             "/bin/bash -c 'echo $"   5 seconds ago       Up 3 seconds        127.0.0.1:57262->8000/tcp, 127.0.0.1:57262->8000/udp   server-a9f83225-5459-cb3a-3cb8-c16d432431cb
b25c0a9a5a91        ubuntu:14.04             "/bin/bash -c 'echo $"   5 seconds ago       Up 3 seconds        127.0.0.1:43309->8000/tcp, 127.0.0.1:43309->8000/udp   server-6622c917-4535-7644-eaab-af79680af3d1
136137132dcf        ubuntu:14.04             "/bin/bash -c 'echo $"   5 seconds ago       Up 3 seconds        127.0.0.1:42451->8000/tcp, 127.0.0.1:42451->8000/udp   server-c93bc1c6-0c46-293e-b99e-e341c85db66f
856b5d8f9089        ubuntu:14.04             "/bin/bash -c 'echo $"   5 seconds ago       Up 3 seconds        127.0.0.1:38457->8000/udp, 127.0.0.1:38457->8000/tcp   server-042f2327-0e0b-555f-c131-9f44fc5dd572
24daa5af2a3f        kompaas                  "fabio"                  41 seconds ago      Up 40 seconds                                                              kompaas_fabio_1
baeecafd7bfe        kompaas                  "nomad agent -dev"       41 seconds ago      Up 41 seconds                                                              kompaas_nomad_1
c3bd6561c6c4        kompaas                  "consul agent -client"   42 seconds ago      Up 41 seconds                                                              kompaas_consul_1
```

## Test example
```bash
while true; do
  curl -H 'Host: python.service.consul' http://localhost:9999
done
```
