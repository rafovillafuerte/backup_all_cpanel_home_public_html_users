# Backup Cpanel todos los usuarios directorio public_html en home

Script bash para generar copias de respaldo del directorio public_html en /home.

# Cron Job:
Crear copias de seguridad diarias a las 9:15 am usando CRON JOB

 min  hr mday month wday command
 
 15   9  *    *     *    /[path]/scripts/public_html_backup.sh
 
# Restaurar desde Backup

$ cd /home/<user name>

$ tar -xvf < [backupfile.tar.gz] 
