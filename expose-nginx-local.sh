#!/usr/bin/env bash

NS="localicity-app"
SERVICE="nginx-service"
LOCAL_PORT=54123
REMOTE_PORT=80
PID_FILE=".nginx-forward.pid"
LOG_FILE=".nginx-forward.log"

function status_msg() { echo "[expose-nginx-local] $*"; }

if [ "$1" = "stop" ]; then
  if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    status_msg "Stopping port-forward PID $PID..."
    kill "$PID" 2>/dev/null || true
    rm -f "$PID_FILE"
    status_msg "Stopped."
  else
    status_msg "No PID file found ($PID_FILE). Nothing to stop."
  fi
  exit 0
fi

# Check that kubectl can see the service
if ! kubectl get svc "$SERVICE" -n "$NS" >/dev/null 2>&1; then
  status_msg "Service $SERVICE not found in namespace $NS. Please create it first."
  exit 1
fi

# Check local port availability
if lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | grep -q ":${LOCAL_PORT}\b"; then
  status_msg "Local port $LOCAL_PORT is already in use. Choose another port or stop the process using it."
  exit 1
fi

status_msg "Starting kubectl port-forward svc/$SERVICE $LOCAL_PORT:$REMOTE_PORT -n $NS"
# Start in background, write logs and pid
kubectl port-forward svc/$SERVICE ${LOCAL_PORT}:${REMOTE_PORT} -n ${NS} > "$LOG_FILE" 2>&1 &
PF_PID=$!
echo "$PF_PID" > "$PID_FILE"
status_msg "Port-forward started with PID $PF_PID. Logs: $LOG_FILE"
status_msg "You can stop it with: bash ./expose-nginx-local.sh stop"
status_msg "Frontend available at: http://127.0.0.1:${LOCAL_PORT}"

exit 0
