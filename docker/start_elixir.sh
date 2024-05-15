#!/bin/sh

until pg_isready -h $POSTGRES_HOST -p $PGPORT -U $POSTGRES_USER; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "PostgreSQL is ready"

echo "Checking and creating database if it doesn't exist..."
/app/bin/mai eval "Mai.Release.create_database"

echo "Running migrations..."
/app/bin/mai eval "Mai.Release.migrate"

echo "Starting the Elixir application..."
/app/bin/server
