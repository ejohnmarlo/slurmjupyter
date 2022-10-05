export website=$1 #"hpc.eee.upd.edu.ph"
export username=$2
export jupyterport=$3 #8888-9999
export jupyterpassword=$4
export userid=$(id -u $username)


#Create directory for docker-compose
sudo mkdir -p files
TARGET="files/$username.yml"

#Shutdown existing docker container
docker-compose -f $TARGET down

#Create directory for username before starting the container
sudo su - $username -c 'mkdir -p /home/$username'

rm -f $TARGET temp.yml
( echo "cat <<EOF >$TARGET";
  cat template.yml;
    echo "EOF";
) >temp.yml
. temp.yml
cat $TARGET
docker-compose -f $TARGET up -d
sleep 5 #Wait for a while until all logs are printed
docker-compose -f $TARGET logs
