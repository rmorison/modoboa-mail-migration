include domains.make

LAST := $(DOMAINS:=.last-sync)
DRYRUN := #--dry-run

.PHONY: clean $(DOMAINS) $(LAST)

all: $(LAST)

$(LAST): %.last-sync: %
	sudo -u vmail bash -c 'cd ~ && rsync $(DRYRUN) --owner --group -azP vmail@morison.io:./$< . && touch $@'

clean:
	rm -f $(LAST)
