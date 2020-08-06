# Put any command that doesn't create a file here (almost all of the commands)
.PHONY: \
	help \
	database_servers \
	default_celery_worker_servers \
	django_servers \
	webapp_servers \

usage:
	@echo "Available commands:"
	@echo "help 								Display available commands"
	@echo "database_servers						Push ansible config to database servers"
	@echo "default_celery_worker_servers		Push ansible config to default celery worker servers"
	@echo "django_servers						Push ansible config to django servers"
	@echo "webapp_servers						Push ansible config to webapp servers"

help:
	$(MAKE) usage

database_servers:
	@ansible-playbook ansible/database_servers.yml -i ansible/inventories/staging/database --vault-id ansible/password.txt

default_celery_worker_servers:
	@ansible-playbook ansible/default_celery_worker_servers.yml -i ansible/inventories/staging/default_celery_worker --vault-id ansible/password.txt

django_servers:
	@ansible-playbook ansible/django_servers.yml -i ansible/inventories/staging/django --vault-id ansible/password.txt
	$(MAKE) default_celery_worker_servers

django_servers:
	@ansible-playbook ansible/webapp_servers.yml -i ansible/inventories/staging/webapp --vault-id ansible/password.txt
