# Put any command that doesn't create a file here (almost all of the commands)
.PHONY: \
	help \
	beat_servers \
	database_servers \
	default_celery_worker_servers \
	django_servers \
	webapp_servers \
	rabbit_servers \
	renew_ssl \
	scoring_worker_servers \

usage:
	@echo "Available commands:"
	@echo "help 				Display available commands"
	@echo "beat_servers			Push ansible config to beat_servers"
	@echo "database_servers			Push ansible config to database servers"
	@echo "default_celery_worker_servers	Push ansible config to default celery worker servers"
	@echo "django_servers			Push ansible config to django servers"
	@echo "webapp_servers			Push ansible config to webapp servers"
	@echo "rabbit_servers			Push ansible config to rabbit servers"
	@echo "renew_ssl			Renew SSL certificates and push to required servers"
	@echo "scoring_worker_servers		Push ansible config to scoring worker servers"

help:
	$(MAKE) usage

beat_servers:
	@ansible-playbook ansible/beat_servers.yml -i ansible/inventories/${ENV}/beat --vault-id ansible/password.txt

database_servers:
	@ansible-playbook ansible/database_servers.yml -i ansible/inventories/${ENV}/database --vault-id ansible/password.txt

default_celery_worker_servers:
	@ansible-playbook ansible/default_celery_worker_servers.yml -i ansible/inventories/${ENV}/default_celery_worker --vault-id ansible/password.txt

scoring_worker_servers:
	@ansible-playbook ansible/scoring_worker_servers.yml -i ansible/inventories/${ENV}/scoring_worker --vault-id ansible/password.txt

django_servers:
	@ansible-playbook ansible/django_servers.yml -i ansible/inventories/${ENV}/django --vault-id ansible/password.txt
	$(MAKE) default_celery_worker_servers ${ENV}
	$(MAKE) scoring_worker_servers ${ENV}
	$(MAKE) beat_servers ${ENV}

webapp_servers:
	@ansible-playbook ansible/webapp_servers.yml -i ansible/inventories/${ENV}/webapp --vault-id ansible/password.txt

rabbit_servers:
	@ansible-playbook ansible/rabbit_servers.yml -i ansible/inventories/${ENV}/rabbit --vault-id ansible/password.txt

renew_ssl:
	@certbot renew --dns-cloudflare-credentials /cloudflare/cloudflare.ini
	$(MAKE) django_servers ${ENV}
	$(MAKE) webapp_servers ${ENV}
