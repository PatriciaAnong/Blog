#CREATE TNS ENTRY ON SOURCE ORACLE DB

WONDERWOMAN =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = dccomics.chfghaffqaya.us-east-1.rds.amazonaws.com)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = DCCOMICS)
    )
  )

  
  
# CREATE DBLINK

#!/usr/bin/python

import os
import sys
from subprocess import Popen, PIPE

sql = """
set linesize 400
col owner for a10
col object_name for a30

CREATE PUBLIC DATABASE LINK RDS_ORACLE
CONNECT TO DPRINCE IDENTIFIED BY dccomics
USING 'WONDERWOMAN';
"""

proc = Popen(["sqlplus", "-S", "/", "as", "sysdba"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
proc.stdin.write(sql)
(out, err) = proc.communicate()

if proc.returncode != 0:
  print err
  sys.exit(proc.returncode)
else:
  print out
