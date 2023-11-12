.PHONY := roundcube modoboa amavis spamassassin

RESTORE := pg_restore --no-password --host=localhost
PSQL := psql --no-password --host=localhost

sudo -u postgres psql -c "drop database if exists roundcubemail"
sudo -u postgres psql -c "create database roundcubemail with owner 'roundcube'"
sudo -u postgres psql -c "drop database if exists amavis"
sudo -u postgres psql -c "create database amavis with owner 'amavis'"
sudo -u postgres psql -c "drop database if exists modoboa"
sudo -u postgres psql -c "create database modoboa with owner 'modoboa'"
sudo -u postgres psql -c "drop database if exists spamassassin"
sudo -u postgres psql -c "create database spamassassin with owner 'spamassassin'"


restore: roundcube modoboa amavis spamassassin

roundcube:
	$(PSQL) -c "drop database if exists roundcubemail"
	$(PSQL) -c "create database roundcubemail with owner 'roundcube'"
	$(RESTORE) -U $@ --dbname roundcubemail dumps/$@.dump

modoboa:
	$(PSQL) -c "drop database if exists $@"
	$(PSQL) -c "create database $@ with owner '$@'"
	$(RESTORE) -U $@ --dbname $@ dumps/$@.dump

amavis:
	$(PSQL) -c "drop database if exists $@"
	$(PSQL) -c "create database $@ with owner '$@'"
	$(RESTORE) -U $@ --dbname $@ dumps/$@.dump

spamassassin:
	$(PSQL) -c "drop database if exists $@"
	$(PSQL) -c "create database $@ with owner '$@'"
	$(RESTORE) -U $@ --dbname $@ dumps/$@.dump

clean:
	rm -f dumps/*.dump
