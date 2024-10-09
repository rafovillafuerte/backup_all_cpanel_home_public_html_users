#!/bin/bash
#==============================================================================
#TITLE:            public_html_backup.sh
#DESCRIPTION:      Script para automatizar las copias de seguridad diarias de los usuarios de CPANEL dentro del directorio /home, sólo la carpeta public_html
#AUTHOR:           Rafael Villafuerte
#DATE:             2024-10-09
#VERSION:          0.1
#USAGE:            ./public_html_backup.sh
#IMPORTANTE:       El servidor debe tener instalado PV Pipe Viewer para poder visualizar progressbar
#CRON:
  # Ej. para cron job, copias diarias a las  @ 9:15 am
  # min  hr mday month wday command
  # 15   9  *    *     *    /[path]/scripts/public_html_backup.sh

#RESTAURAR la copia de seguridad de la carpeta public_html
# tar -xvf archivo.tar.gz

#==============================================================================
# CONFIGURACION
#==============================================================================

# DIRECTORIO DONDE SE ALMACENARAN LOS BACKUP
BACKUP_DIR=/home/perudalia/public_html/backups_files

# Número de días para mantener las copias de seguridad
KEEP_BACKUPS_FOR=30 #dias

#==============================================================================
# METODOS // FUNCIONES
#==============================================================================

# YYYY-MM-DD
TIMESTAMP=$(date +%F)

function delete_old_backups()
{
  echo "Borrando $BACKUP_DIR/*.tar.gz con antiguedad de $KEEP_BACKUPS_FOR dias"
  find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +$KEEP_BACKUPS_FOR -exec rm {} \;
}

function backup_files(){
  #cd /home
  #for udir in *; do
  for udir in /home/*/public_html; do
     IFS=/ read -r _ _ user _ <<<"$udir"
     backup_file="$BACKUP_DIR/$TIMESTAMP.${user}.tar.gz"  
     #find /home/$udir -type d -name 'public_html' -exec tar -czf $backup_file {} \;
     cd /home/${user}
     #tar -czf $backup_file "public_html"
     echo "...respaldando directorio public_html del usuario ${user}" 
     tar cf - public_html -P | pv -s $(du -sb public_html | awk '{print $1}') | gzip > $backup_file
  done 
}

function hr(){
  printf '=%.0s' {1..100}
  printf "\n"
}

#==============================================================================
# EJECUTAR SCRIPT BASH
#==============================================================================
delete_old_backups
hr
backup_files
hr
printf "Todo respaldado!\n\n"
