# Aid to re-hosting modoboa+roundcubemail to new server with latest Modoboa

## Install Modoboa on *NEW* server

Follow the [Modoboa install instructions](https://github.com/modoboa/modoboa/blob/master/doc/installation.rst)

## Install Modoboa on *NEW* server

Follow the [roundcubemail install instructions](https://github.com/roundcube/roundcubemail/wiki/Installation).

Roundcube install is so "one and done" (like Modoboa) in my experience. [This article](https://github.com/roundcube/roundcubemail/wiki/Installation) was helpful.

## Create `~/.pgpass` on *NEW* and *OLD* servers with 4 entries

```
localhost:5432:roundcubemail:roundcube:CHANGEME
localhost:5432:modoboa:modoboa:CHANGEME
localhost:5432:amavis:amavis:CHANGEME
localhost:5432:spamassassin:spamassassin:CHANGEME
```

### Where to find passwords on *OLD* and *NEW* server

- modoboa, amavis: `/srv/modoboa/instance/instance/settings.py`

## Stop services on *NEW* server

```bash
make stop-services
```

## Stop services on *OLD* server

```bash
make stop-services
```

## Dump databases on *OLD* server and copy to *NEW* server

```bash
make dump
rsync -azP vmail@OLD:modoboa-mail-migration/dumps .
```

## Restore databases (with workaround for 1.17.0 -> 2.0.0)

See [Upgrade from 1.17.0 to 2.0.0 fails - psycopg2.errors.FeatureNotSupported: cannot alter type of a column used by a view or rule](https://github.com/modoboa/modoboa/issues/2508). 

```shell
make drop-dkim-view
make restore
make create-dkim-view
```

## Complete Modoboa upgrade on *NEW* servier

See [Modoboa upgrade instructions](https://github.com/modoboa/modoboa/blob/master/doc/upgrade.rst) for reference. Since the *NEW* server is built with latest Modoboa you should just need

```shell
sudo -u <modoboa_user> -i bash
source <virtuenv_path>/bin/activate
cd <modoboa_instance_dir>
python manage.py migrate
python manage.py collectstatic
python manage.py check --deploy
```

## Sync vmail from *OLD* server to *NEW* server

You can rerun this as needed if mail is still being delivered to *OLD* server

```bash
make sync-mail
```

## Debug, debug, debug

Likely something will be broken with Modoboa and/or Roundcubemail. Places to look:

- `/var/log/mail.log`
- `/var/log/nginx/*.log`
- `/var/log/uwsgi/app/*.log`

You might need to _temporarily_ change `DEBUG = True` in `-/srv/modoboa/instance/instance/settings.py` and `sudo systemctl restart uwsgi` to get debug messages in the browser. Be sure to _revert_ asap when done.

## DNS

For debug, it's useful to iron things out with a scratch domain, like `mail-test.domain.com`. For the live migration, you'll need to change MX for the domains to the *NEW* server.
