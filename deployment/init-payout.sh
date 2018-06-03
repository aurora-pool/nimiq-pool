if [[ -z "$NODE_ENV" ]]; then
  echo -e "This script requires a NODE_ENV variable to be set...!"
  exit 1
fi

NODE_ENV=payout.$NODE_ENV node index.js --config=irrelevant
