# role-postgresql-backup
Ansible role to automaticcally backup your postgresql database you created with ansible

```
WÖRK IN PROGRESS, obviously!
```

 Configuration
------------------

* required packages to create postgres dump and add a cronjob
```yaml
postgresql_backup:
  required_packages:
    - postgresql-client
    - cron
```

* Where do we store our database backups:
```yaml
postgresql_backup:
  backup_dir: /var/backup/postgresql
```

+ Dateformat we use to create daily backup folder
```yaml
postgresql_backup:
  date_format: '%Y-%m-%d_%H-%M'
```

+ Create cronjob to run backup script?
```yaml
postgresql_backup:
  cron: true
```

+ User that should run the backup script as cronjob
```yaml
postgresql_backup:
  user: root
```

* Minute and hour to run the cronjob
```yaml
postgresql_backup:
  cron_minute: '*'
  cron_hour: '0'
```

+ Which database*(s)* do we want to backup` *(example)*
  *The values for host and port are optional!*
```yaml
postgresql_backup:
  databases:
   - name: psql_database_name
     user: psql_database_user
     password: Topf_Secret1
     host: localhost
     port: 5432
```

+ Export Option for pg_dump.
> - ``p`` – plain-text SQL script
> - ``c`` – custom-format archive
> - ``d`` – directory-format archive
> - ``t`` – tar-format archive
```yaml
postgresql_backup:
  export_option: "p"
```

+ save backup as tar.gz
```yaml
postgresql_backup:
  create_tar_gz: true
```

+ Perform basic versionscheck *(true is recomended)*
```
submodules_versioncheck: false
```
