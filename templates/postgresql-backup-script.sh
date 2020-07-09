#!/usr/bin/env bash
# {{ ansible_managed }}

set -o pipefail


BACKUP_DIR_BASE="{{ postgresql_backup.backup_dir | default( '/var/backup/postgresql/' ) }}"
DATE_FORMAT="{{ postgresql_backup.date_format | default( '%Y-%m-%d_%H-%M' ) }}"

create_backup_dir() {
	local backup_dir="${BACKUP_DIR_BASE%/}/$(date "+$DATE_FORMAT")"
	mkdir -p "$backup_dir"
	echo "$backup_dir"
}

backup_databases() {
  {% for db in postgresql_backup.databases %}
  {% if db.password %}
  export PGPASSWORD="{{ db.password }}"
  {% endif %}
  if (umask 077 && pg_dump -F c -h "{{ db.host | default( 'localhost' ) }}" -U "{{ db.user | default( 'postgres' ) }}" -p "{{ db.port | default( '5432' ) }}" "{{ db.name }}" -f "{{ db.name }}.in_progress.psql"); then
  {% if postgresql_backup.compress %}
    tar -czvf  "{{ db.name }}.psql.tar.gz" "{{ db.name }}.in_progress.psql"
  {% else %}
	  mv "{{ db.name }}.in_progress.psql" "{{ db.name }}.psql"
  {% endif %}
    echo "backup of {{ db.name }} successful"
  else
    echo "failed to export {{ db.name }}"
	  return 1
  fi;
  {% endfor %}
	return 0
}




main() {
	backup_dir="$(create_backup_dir)"
	echo "Created backup directory \"${backup_dir}\"."

	pushd . >/dev/null
	cd "$backup_dir"

	echo "Starting databases backup."
	if backup_databases; then
		echo "Databases backup is done."
	else
		echo "Databases backup failed. Exiting."
		exit 1;
	fi;

	popd >/dev/null
}


main
