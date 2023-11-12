.PHONY := roundcube modoboa amavis spamassassin

DUMP := pg_dump --no-password --format=c --host=localhost

dump: roundcube modoboa amavis spamassassin

roundcube:
	$(DUMP) -U $@ roundcubemail > dumps/$@.dump

modoboa:
	$(DUMP) -U $@ $@ > dumps/$@.dump

amavis:
	$(DUMP) -U $@ $@ > dumps/$@.dump

spamassassin:
	$(DUMP) -U $@ $@ > dumps/$@.dump

clean:
	rm -f dumps/*.dump
