#!/bin/bash
set -e

# Run the database migrations
rails db:create db:migrate

# Execute the main container command
exec "$@"
