#CREATE THE NECESSARY TABLESPACE ON TARGET DB
#!/usr/bin/python

import os
import sys
from subprocess import Popen, PIPE

sql = """
set linesize 120
col owner for a10
col object_name for a30
set wrap off

CREATE TABLESPACE WONDERWOMAN_DATA
    DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
"""

proc = Popen(["sqlplus", "panong/dbalady@WONDERWOMAN"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
proc.stdin.write(sql)
(out, err) = proc.communicate()

if proc.returncode != 0:
  print err
  sys.exit(proc.returncode)
else:
  print out