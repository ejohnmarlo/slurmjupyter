#export username="pat_zamora"
#export jupyterport="8888"
#export jupyterpassword="tanongmokaykarisse"

export username=$1
export jupyterport=$2
export jupyterpassword=$3
export userid=$(id -u $username)

rm -f $username.yml temp.yml
( echo "cat <<EOF >$username.yml";
  cat template.yml;
  echo "EOF";
) >temp.yml
. temp.yml
cat $username.yml
docker-compose -f $username.yml up -d
