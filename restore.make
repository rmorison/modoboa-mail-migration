.PHONY := roundcube modoboa amavis spamassassin

RESTORE := pg_restore --no-password --host=localhost
POSTGRES_PSQL := sudo -u postgres psql

restore: roundcube modoboa amavis spamassassin

roundcube:
	$(POSTGRES_PSQL) -c "drop database if exists roundcubemail"
	$(POSTGRES_PSQL) -c "create database roundcubemail with owner 'roundcube'"
	$(RESTORE) -U $@ --dbname roundcubemail dumps/$@.dump

modoboa:
	$(POSTGRES_PSQL) -c "drop database if exists $@"
	$(POSTGRES_PSQL) -c "create database $@ with owner '$@'"
	$(RESTORE) -U $@ --dbname $@ dumps/$@.dump

amavis:
	$(POSTGRES_PSQL) -c "drop database if exists $@"
	$(POSTGRES_PSQL) -c "create database $@ with owner '$@'"
	$(RESTORE) -U $@ --dbname $@ dumps/$@.dump

spamassassin:
	$(POSTGRES_PSQL) -c "drop database if exists $@"
	$(POSTGRES_PSQL) -c "create database $@ with owner '$@'"
	$(RESTORE) -U $@ --dbname $@ dumps/$@.dump

clean:
	rm -f dumps/*.dump
