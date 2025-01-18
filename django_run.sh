#!/bin/env bash

# Gracefully wait for postgres
echo "Waiting for postgres..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "PostgreSQL started"


python manage.py makemigrations books
echo ========


python manage.py migrate
echo ========


python manage.py runserver 0.0.0.0:8000