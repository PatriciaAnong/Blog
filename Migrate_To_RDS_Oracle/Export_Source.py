#####CREATE DATABASE PUMP OF FULL DATABASE

####@export.sql
set scan off
set serveroutput on
set escape off
whenever sqlerror exit 
DECLARE
    h1 number;
    errorvarchar varchar2(100):= 'ERROR';
    tryGetStatus number := 0;
begin
    h1 := dbms_datapump.open (operation => 'EXPORT', job_mode => 'FULL', job_name => 'EXPORT_ORACLE_MIGRATION', version => 'COMPATIBLE'); 
    tryGetStatus := 1;
    dbms_datapump.set_parallel(handle => h1, degree => 1); 
    dbms_datapump.add_file(handle => h1, filename => 'EXPDAT.LOG', directory => 'DATA_PUMP_DIR', filetype => 3); 
    dbms_datapump.set_parameter(handle => h1, name => 'KEEP_MASTER', value => 0); 
    dbms_datapump.add_file(handle => h1, filename => 'EXPDAT%U.DMP', directory => 'DATA_PUMP_DIR', filesize => '10G', filetype => 1, reusefile => 1); 
    dbms_datapump.set_parameter(handle => h1, name => 'INCLUDE_METADATA', value => 1); 
    dbms_datapump.set_parameter(handle => h1, name => 'FLASHBACK_SCN', value => dbms_flashback.get_system_change_number);
    dbms_datapump.set_parameter(handle => h1, name => 'DATA_ACCESS_METHOD', value => 'AUTOMATIC'); 
    dbms_datapump.set_parameter(handle => h1, name => 'ESTIMATE', value => 'BLOCKS'); 
    dbms_datapump.start_job(handle => h1, skip_current => 0, abort_step => 0); 
    dbms_datapump.detach(handle => h1); 
    errorvarchar := 'NO_ERROR'; 
EXCEPTION
    WHEN OTHERS THEN
    BEGIN 
        IF ((errorvarchar = 'ERROR')AND(tryGetStatus=1)) THEN 
            DBMS_DATAPUMP.DETACH(h1);
        END IF;
    EXCEPTION 
    WHEN OTHERS THEN 
        NULL;
    END;
    RAISE;
END;
/


#RUN THE EXPORT SCRIPT VIA PYTHON
#!/usr/bin/python

import os
import sys
from subprocess import Popen, PIPE

sql = """
set linesize 400
col owner for a10
col object_name for a30

@export.sql
"""

proc = Popen(["sqlplus", "-S", "/", "as", "sysdba"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
proc.stdin.write(sql)
(out, err) = proc.communicate()

if proc.returncode != 0:
  print err
  sys.exit(proc.returncode)
else:
  print out
