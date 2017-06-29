#Create a directory for all the packages
mkdir /opt/oracle
cd /opt/oracle
unzip /home/panong/Downloads/instantclient-basic-linux.x64-12.2.0.1.0.zip
unzip /home/panong/Downloads/java_ee_sdk-7u3.zie

#TAR.GZ FOR cx_oracle
tar -zxvf /home/panong/Downloads/cx_Oracle-6.0rc1.tar.gz
#OR RPM
rpm -ivh cx_Oracle-6.0rc1-py27-1.x86_64.rpm

Configure Instant Client:

cd /opt/oracle/instantclient_12_2
ln -s libclntsh.so.12.1 libclntsh.so


#Download dependencies for cx_Oracle
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip
yum install python-devel


#Install cx_Oracle
export LD_RUN_PATH=/opt/oracle/instantclient_12_2
export ORACLE_HOME=/opt/oracle/instantclient_12_2
pip install cx_Oracle



#Add the Library Path to .bash_profile:

export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2



#TEST YOUR CONNECTION:

#!/usr/bin/env python

import cx_Oracle

def query():
    import cx_Oracle
    db = cx_Oracle.connect("dprince", "dccomics", "192.142.0.1/WonderWoman")
    cursor = db.cursor()
    cursor.execute("select dbid,log_mode,open_mode from v$database")
    #return cursor.fetchone()[0]
    #print cursor.description
    for row in cursor:
        print row
    db.close()

query()

