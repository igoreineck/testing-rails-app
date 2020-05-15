#!/bin/bash

set -e

rm -f /testing-app/tmp/pids/server.pid

exec "$@"