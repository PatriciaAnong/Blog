#MOVE DATAPUMP FILE USING DBLINK 

#!/usr/bin/python

import os
import sys
from subprocess import Popen, PIPE

sql = """
set linesize 120
col owner for a10
col object_name for a30
set wrap off

BEGIN
DBMS_FILE_TRANSFER.PUT_FILE(
source_directory_object       => 'DATA_PUMP_DIR',
source_file_name              => 'EXPDAT01.DMP',
destination_directory_object  => 'DATA_PUMP_DIR',
destination_file_name         => 'DB_COPY.DMP',
destination_database          => 'RDS_ORACLE'
);
END;
/
"""

proc = Popen(["sqlplus", "dprince/sourceDCComics"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
proc.stdin.write(sql)
(out, err) = proc.communicate()

if proc.returncode != 0:
  print err
  sys.exit(proc.returncode)
else:
  print out
