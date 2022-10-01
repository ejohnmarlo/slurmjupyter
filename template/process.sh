#export username="pat_zamora"
#export jupyterport="8888"
#export jupyterpassword="tanongmokaykarisse"

export website=$1
export username=$2
export jupyterport=$3
export jupyterpassword=$4
export userid=$(id -u $username)

docker-compose -f $username.yml down

#Create directory for username before starting the container
sudo su - $username -c 'mkdir -p /home/$username'

rm -f $username.yml temp.yml
( echo "cat <<EOF >$username.yml";
  cat template.yml;
  echo "EOF";
) >temp.yml
. temp.yml
#rm -f temp.yml
cat $username.yml
docker-compose -f $username.yml up -d
#docker-compose -f $username.yml up --force-recreate --build -d
