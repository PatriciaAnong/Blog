#BOOTSTRAP AWS CLI 
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install awscli


#CONFIRM AWSCLI INSTALLED
aws --version

#INSTALL BOTO3 -PYTHON INTERFACE TO AWS CLI 
pip install awscli boto3 -U --ignore-installed six

#VERIFY BOTO3 INSTALLATION: IF NOTHING HAPPENS, THE INTALLATION WAS SUCCESSFUL 
python -c "import boto3" 

#CONFIGURE AWS
aws configure
AWS Access Key ID [None]: *************CRMA
AWS Secret Access Key [None]: *********************************91O4X
Default region name [None]: us-east-1
Default output format [None]: json