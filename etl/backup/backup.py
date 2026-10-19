import delegator
import datetime
import os

async def backup_mysql():
    """Realiza un backup de la base de datos MySQL 'probando_stock'."""
    mysqldump_path = r"C:\laragon\bin\mysql\mysql-8.0.30-winx64\bin\mysqldump.exe"
    username = "root"
    host = "localhost"
    port = 3306
    database_name = "probando_stock"
    backup_dir = r"backups\erp"
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = os.path.join(backup_dir, f"backup_mysql_{timestamp}.backup")

    command = [mysqldump_path, "-u", username,"-h", host, "-P", str(port), database_name]

    try:
        result = delegator.run(command + [">", backup_file])
        if result.return_code == 0:
            print(f"Backup de MySQL exitoso. Guardado en: {backup_file}")
            return True
        else:
            print(f"Error al realizar el backup de MySQL. Código de salida: {result.return_code}")
            return False
    except Exception as e:
        print(f"Ocurrió una excepción al ejecutar el comando de MySQL: {e}")
        return False


async def backup_postgresql():
    """Realiza un backup de la base de datos 'postgres' en localhost."""
    pg_dump_path = r"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe"
    username = "postgres"
    host = "localhost"
    port = 5432
    database_name = "postgres"
    backup_dir = r"backups\bi"
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = os.path.join(backup_dir, f"backup_postgres_{timestamp}.backup")

    command = [pg_dump_path,"-h",host,"-p", str(port),"-U",username,"-f", backup_file]

    try:
        os.environ['PGPASSWORD'] = 'olap22'
        result = delegator.run(command)
        if result.return_code == 0:
            print(f"Backup de PostgreSQL exitoso. Guardado en: {backup_file}")
            return True
        else:
            print(f"Error al realizar el backup de PostgreSQL. Código de salida: {result.return_code}")
            return False
    except Exception as e:
        print(f"Ocurrió una excepción al ejecutar el comando de PostgreSQL: {e}")
        return False