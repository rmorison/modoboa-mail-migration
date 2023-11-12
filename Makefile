.PHONY: stop-services start-services dump restore drop-view create-view sync-mail

PSQL := psql --no-password --host=localhost
SERVICES := amavis clamav-daemon clamav-freshclam dovecot nginx postfix uwsgi opendkim

stop-services:
	sudo systemctl stop $(SERVICES)

start-services:
	sudo systemctl start $(SERVICES)

dump:
	make -f dump.make

restore:
	make -f restore.make

drop-dkim-view:
	$(PSQL) -U modoboa --dbname modoboa -f $@.sql

create-dkim-view:
	$(PSQL) -U modoboa --dbname modoboa -f $@.sql

sync-mail:
	make -f sync-mail.make
