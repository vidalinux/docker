#!/bin/bash

/usr/bin/gunicorn.py3 --pid /run/openuds/pid \
          --bind unix:/run/openuds/socket server.wsgi \
          --workers 5 --threads 8
