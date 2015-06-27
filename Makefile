#
# Tasks Makefile
# ==============
#
# Shortcuts for various tasks.
#

run:
	@(ansible-playbook -i stage site.yml -u support -s -K --private-key ~/Work/.ssh/id_rsa)

setup:
	@(ansible cloud -i stage -u support -m setup --private-key ~/Work/.ssh/id_rsa)

ping:
	@(ansible all -i stage -m ping -u support)

tasks:
	@(ansible-playbook -i stage site.yml --list-tasks)

hosts:
	@(ansible-playbook -i stage site.yml --list-hosts)