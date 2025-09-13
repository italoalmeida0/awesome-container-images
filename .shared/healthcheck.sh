 #!/bin/sh

PORT=${PORT:-8080}
HEALTH_ENDPOINT=${HEALTH_ENDPOINT:-/}

HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:${PORT}${HEALTH_ENDPOINT})

case $HTTP_CODE in
    200|401|403)
        echo "Health check passed: HTTP $HTTP_CODE on port $PORT"
        exit 0
        ;;
    *)
        echo "Health check failed: HTTP $HTTP_CODE on port $PORT"
        exit 1
        ;;
esac