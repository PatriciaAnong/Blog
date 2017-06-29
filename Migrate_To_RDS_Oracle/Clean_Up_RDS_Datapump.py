#CLEAN UP RDS DATAPUMP DIRECTORY:
#LIST FILES IN DATAPUMP DIRECTORY

#!/usr/bin/python

import os
import sys
from subprocess import Popen, PIPE

sql = """
set linesize 400
col owner for a10
col object_name for a30

select * from table(RDSADMIN.RDS_FILE_UTIL.LISTDIR('DATA_PUMP_DIR')) order by mtime;
"""

proc = Popen(["sqlplus", "-S", "/", "as", "sysdba"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
proc.stdin.write(sql)
(out, err) = proc.communicate()

if proc.returncode != 0:
  print err
  sys.exit(proc.returncode)
else:
  print out
  

  
#DELETE THE FILES NO LONGER NEEDED

#!/usr/bin/python

import os
import sys
from subprocess import Popen, PIPE

sql = """
set linesize 400
col owner for a10
col object_name for a30

exec utl_file.fremove('DATA_PUMP_DIR','DB_COPY.DMP');
"""

proc = Popen(["sqlplus", "-S", "/", "as", "sysdba"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
proc.stdin.write(sql)
(out, err) = proc.communicate()

if proc.returncode != 0:
  print err
  sys.exit(proc.returncode)
else:
  print out