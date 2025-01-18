#!/bin/env bash
python manage.py makemigrations books
echo ========


python manage.py migrate
echo ========


python manage.py runserver