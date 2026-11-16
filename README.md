# phpMyAdmin on Railway

This repo is the source of the **phpMyAdmin** Railway template. It deploys:

| Service | Source | What it does |
|---|---|---|
| `phpMyAdmin` | this repo (`Dockerfile`) | phpMyAdmin **5.2.3** (official image `phpmyadmin:5.2.3-apache`, pinned by digest), PHP 8.3, Apache on Railway's `PORT`, public HTTPS domain |
| `MySQL` | Railway's MySQL database | MySQL server with its data on a volume |

Log in with a MySQL user. For the bundled database that is `root` with the `MYSQL_ROOT_PASSWORD` from the MySQL service's **Variables** tab. There is no default password, and passwordless logins are refused.

## Variables (phpMyAdmin service)

| Variable | Default | Purpose |
|---|---|---|
| `PMA_HOST` | `${{MySQL.MYSQLHOST}}` | MySQL host phpMyAdmin connects to (private network) |
| `PMA_PORT` | `${{MySQL.MYSQLPORT}}` | MySQL port |
| `PMA_BLOWFISH_SECRET` | `${{secret(32)}}` | Cookie encryption secret (32 characters) |
| `PORT` | `8080` | Port Apache listens on |

Optional, set them yourself when you need them:

- Manage another MySQL or MariaDB server instead: point `PMA_HOST` / `PMA_PORT` at it (for example `${{MyDB.RAILWAY_PRIVATE_DOMAIN}}` and `3306`).
- Several servers: unset `PMA_HOST` and set `PMA_HOSTS=host1,host2` (and `PMA_PORTS`).
- Let users type any server on the login page: `PMA_ARBITRARY=1` (off by default, since it lets anyone with the URL probe hosts on your private network).
- Upload limit: `UPLOAD_LIMIT` (default `512M`), plus `MEMORY_LIMIT` and `MAX_EXECUTION_TIME`.

All other variables of the [official image](https://docs.phpmyadmin.net/en/latest/setup.html#docker-environment-variables) work too.

## What the wrapper adds

- `railway-start.sh`: sets `APACHE_PORT` from `PORT`, sets `PMA_ABSOLUTE_URI` to `https://$RAILWAY_PUBLIC_DOMAIN/`, writes `PMA_BLOWFISH_SECRET` into `config.secret.inc.php`, then runs the image's own entrypoint.
- `conf.d/railway.inc.php`: refuses passwordless logins and turns off the in-app version check.

## Updates

The Dockerfile pins phpMyAdmin by version and digest. A new release is a change to this repo: the pin is bumped on a branch, tested on Railway, noted in `CHANGELOG.md` and merged to `main`. Railway then shows an "update available" notice on projects deployed from this template, and you choose when to apply it. Read `CHANGELOG.md` before you apply one. phpMyAdmin keeps no data of its own, so updating it never touches your databases.
