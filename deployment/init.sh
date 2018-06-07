if [[ -z "$NODE_ENV" ]]; then
  echo -e "This script requires a NODE_ENV variable to be set...!"
  exit 1
fi

# cd /app
# rm -rf test-full-consensus
# rm -rf main-full-consensus
# wget https://aschen.ovh/nimiq/$NODE_ENV/$NODE_ENV-full-consensus.tar
# tar -xvf $NODE_ENV-full-consensus.tar && rm $NODE_ENV-full-consensus.tar

node index.js --config=$NODE_ENV.json
