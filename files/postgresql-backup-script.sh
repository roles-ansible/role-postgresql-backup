#!/usr/bin/env bash
# this file is managed by ansible!

set -o pipefail


BACKUP_DIR_BASE="{{ postgresql_backup.backup_dir | default( '/var/backup/postgresql/' ) }}"
DATE_FORMAT="{{ postgresql_backup.date_format | default( '%Y-%m-%d_%H-%M' ) }}"
PG_HOSTNAME
PG_USERNAME
PG_PORT
PG_DATABASE

create_backup_dir() {
	local backup_dir="${BACKUP_DIR_BASE%/}/$(date "+$DATE_FORMAT")"
	mkdir -p "$backup_dir"
	echo "$backup_dir"
}


backup_databases() {
  local filename="${PG_DATABASE}.psql"
  if (umask 077 && pg_dump -F c -h "$PG_HOSTNAME" -U "$PG_USERNAME" -p "$PG_PORT" "$PG_DATABASE" -f "${filename}.in_progress"); then
	  mv "${filename}.in_progress" "$filename"
  else
	  return 1
  fi;
	done <<< "$databases"
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
