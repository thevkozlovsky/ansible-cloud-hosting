#
# Tasks Makefile
# ==============
#
# Shortcuts for various tasks.
#

PRIVATE_KEY=~/.ssh/id_rsa
SWARM_IP=178.62.232.38:8000
CA_CERTS_DIR=certs/ca
CONSUL_CERTS_DIR=certs/consul
DOCKER_CERTS_DIR=certs/docker

run:
	@(ansible-playbook -i stage site.yml -u root --private-key $(PRIVATE_KEY))

setup:
	@(ansible cloud -i stage -u root -m setup --private-key $(PRIVATE_KEY))

ping:
	@(ansible all -i stage -m ping -u root)

tasks:
	@(ansible-playbook -i stage site.yml --list-tasks)

hosts:
	@(ansible-playbook -i stage site.yml --list-hosts)

gen-ca:
	@(mkdir -p $(CA_CERTS_DIR))
	@(openssl genrsa -aes256 -out $(CA_CERTS_DIR)/ca-key.pem 4096)
	@(openssl req -new -x509 -days 365 -key $(CA_CERTS_DIR)/ca-key.pem -sha256 -out $(CA_CERTS_DIR)/ca.pem)

gen-consul-certs:
	@(touch $(CONSUL_CERTS_DIR)/certindex)
	@(cd $(CONSUL_CERTS_DIR) && openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -out ca.cert)
	@(cd $(CONSUL_CERTS_DIR) && openssl req -newkey rsa:1024 -nodes -out consul.csr -keyout consul.key)
	@(cd $(CONSUL_CERTS_DIR) && openssl ca -batch -config myca.conf -notext -in consul.csr -out consul.cert)


swarm:
	@(docker -H tcp://$(SWARM_IP) --tlsverify=true --tlscacert=$(CA_CERTS_DIR)/ca.pem --tlscert=$(DOCKER_CERTS_DIR)/cert.pem --tlskey=$(DOCKER_CERTS_DIR)/key.pem info)
