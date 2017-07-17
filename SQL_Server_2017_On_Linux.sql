--CONFIGURE YOUR HOSTS FILE ON THE WINDOWS SERVER ON WHICH SSMS IS INSTALLED AND ON THE LINUX SERVERS HOSTING YOUR REPLICAS:

sudo vi /etc/hosts 

/* e.g. add to the bottom of the file */
162.108.0.3 Minions
162.108.0.4 EvilMinions


--INSTALL SQL SERVER ON ALL NODES:

--AS ROOT:
--DOWNLOAD THE MICROSOFT SQL SERVER RED HAT REPOSITORY CONFIGURATION FILE:

curl https://packages.microsoft.com/config/rhel/7/mssql-server.repo > /etc/yum.repos.d/mssql-server.repo
exit

--INSTALL MSSQL SERVER
sudo yum install -y mssql-server


--AFTER THE PACKAGE INSTALLATION FINISHES, RUN MSSQL-CONF SETUP AND FOLLOW THE PROMPTS:

sudo /opt/mssql/bin/mssql-conf setup

--ONCE THE CONFIGURATION IS DONE, VERIFY THAT THE SERVICE IS RUNNING:

systemctl status mssql-server


/* TO ALLOW REMOTE CONNECTIONS, OPEN THE SQL SERVER PORT ON THE FIREWALL ON RHEL:
The default SQL Server port is TCP 1433. */

sudo firewall-cmd --zone=home --add-port=1433/tcp --permanent
sudo firewall-cmd --reload


--INSTALL SQLCMD COMMAND LINE TOOL
--AS ROOT
curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
exit

--UPDATE PACKAGES AND INSTALL unixODBC PACKAGES
sudo yum update
sudo yum install mssql-tools unixODBC-devel


--To make sqlcmd/bcp accessible from the bash shell for login sessions
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile


--INSTALL SQL SERVER AGENT
sudo yum install mssql-server-agent
sudo systemctl restart mssql-server


/* Note - Repeat above steps for all replica nodes */

--CONFIGURE ALWAYSON: 

--ENABLE ALWAYSON USING mssql-conf
sudo /opt/mssql/bin/mssql-conf set hadr.hadrenabled  1
systemctl restart mssql-server.service

/* NOTE: REPEAT ON ALL SECONDARY NODES */


--ENABLE ALWAYSON_HEALTH EVENT SESSION: USING SSMS OR SQLCMD:
sqlcmd -S localhost -U SA -P TwinsiesDruGru -Q "ALTER EVENT SESSION  AlwaysOn_health ON SERVER WITH (STARTUP_STATE=ON);"
GO

--CREATE DB MIRRORING ENDPOINT USER
CREATE LOGIN dbm_login WITH PASSWORD = 'FeloniusGru';
CREATE USER dbm_user FOR LOGIN dbm_login;

--Create a certificate on PRIMARY
--SQL Server service on Linux uses certificates to authenticate communication between the mirroring endpoints.

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Freedonia';
CREATE CERTIFICATE dbm_certificate WITH SUBJECT = 'dbm';
BACKUP CERTIFICATE dbm_certificate
   TO FILE = '/var/opt/mssql/data/dbm_certificate.cer'
   WITH PRIVATE KEY (
           FILE = '/var/opt/mssql/data/dbm_certificate.pvk',
           ENCRYPTION BY PASSWORD = 'Freedonia'
       );
	   
	   
--COPY CERTIFICATES TO SECONDARY NODES
cd /var/opt/mssql/data
scp dbm_certificate.* root@EvilMinions:/var/opt/mssql/data/


--On the secondary server(s), give permission to mssql user to access the certificate.
cd /var/opt/mssql/data
chown mssql:mssql dbm_certificate.*


--CREATE THE DBM USER
CREATE LOGIN dbm_login WITH PASSWORD = 'DruGru';
CREATE USER dbm_user FOR LOGIN dbm_login;


--CREATE MIRRORING ENDPOINT ON ALL REPLICAS
CREATE ENDPOINT [Anti_Villain_League]
    AS TCP (LISTENER_IP = (0.0.0.0), LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
        ROLE = ALL,
        AUTHENTICATION = CERTIFICATE dbm_certificate,
        ENCRYPTION = REQUIRED ALGORITHM AES
        );
ALTER ENDPOINT [Anti_Villain_League] STATE = STARTED;
GRANT CONNECT ON ENDPOINT::[Anti_Villain_League] TO [dbm_login];

--To allow remote connections, open the SQL Server port on the firewall on RHEL. 
--The SQL Server port used for the ENDPOINT is 5022. If you are using FirewallD for your firewall, you can use the following commands:
--RUN ON ALL REPLICAS

sudo firewall-cmd --zone=home --add-port=5022/tcp --permanent
sudo firewall-cmd --reload


--CREATE THE AVAILABILITY GROUP
CREATE AVAILABILITY GROUP [DespicableMe3]
    WITH (CLUSTER_TYPE = NONE)
    FOR REPLICA ON
        N'Minions' WITH (
            ENDPOINT_URL = N'tcp://Minions:5022',
            AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
            FAILOVER_MODE = MANUAL,
            SEEDING_MODE = AUTOMATIC,
                    SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
            ),
        N'Minions' WITH ( 
            ENDPOINT_URL = N'tcp://EvilMinions:5022', 
            AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
            FAILOVER_MODE = MANUAL,
            SEEDING_MODE = AUTOMATIC,
            SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
            );

ALTER AVAILABILITY GROUP [DespicableMe] GRANT CREATE ANY DATABASE;

--JOIN SECONDARY TO AVAILABILITY GROUP
ALTER AVAILABILITY GROUP [DespicableMe] JOIN WITH (CLUSTER_TYPE = NONE);

ALTER AVAILABILITY GROUP [DespicableMe] GRANT CREATE ANY DATABASE;

--CREATE USER AND DATABASE
sqlcmd -S localhost -U SA -P TwinsiesDruGru 

--Create LOGIN
CREATE LOGIN DespicableMe WITH PASSWORD='Good0rEv1l';
GO

--CREATE USER FOR LOGIN
CREATE USER minions FOR LOGIN DespicableMe;
GO

--GRANT PERMISSIONS
GRANT ALTER TO minions;
GO
GRANT CONTROL TO minions; GO
GO
GRANT CREATE ANY DATABASE TO DespicableMe;
GO

--TEST LOGIN
--EXIT AS SA
sqlcmd -S localhost -U DespicableMe -P Good0rEv1l

--CREATE DATABASE
CREATE DATABASE Lucy_Margo_Edith
GO

ALTER DATABASE [Lucy_Margo_Edith] SET RECOVERY FULL;

--TAKE DUMMY BACKUP OF DATABASE TO MEET THE PREREQUISITES FOR ADDING A DATABASE TO AN AVAILABILITY GROUP
BACKUP DATABASE [Lucy_Margo_Edith] 
   TO DISK = 'nul';

   
--VERIFY THE DB WAS CREATED

sqlcmd -S localhost -U SA -P Despicable!
SELECT * FROM sys.databases WHERE name = 'Lucy_Margo_Edith'
FOR JSON AUTO
GO
SELECT DB_NAME(database_id) AS 'database', synchronization_state_desc FROM sys.dm_hadr_database_replica_states
GO


--ADD DATABASE TO AVAILABILITY GROUP:
ALTER AVAILABILITY GROUP [DespicableMe] ADD DATABASE [Lucy_Margo_Edith];

/* ONCE THE DATABASE AND THE CERTIFICATES AE CREATED AND COPIED TO ALL NODES, YOU COULD ALSO CHOOSE TO USE SSMS GUIs TO CONFIGURE ALWAYSON. */