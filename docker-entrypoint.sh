#!/bin/bash
set +x

what=${1:-start}
how=${2:-coffee}

case $what in
  'start' )
    if [ "$how" != "coffee" ]
    then
      npm build && npm start
    else
      npm run start:coffee
    fi
    ;;
  'test' )
    # Testing implies that we can actually compile coffeescript to javascript
    # So go straight through the whole compilation process...
    npm test
    ;;
  * )
    echo "Running custom command: $*"
    exec $*
esac
