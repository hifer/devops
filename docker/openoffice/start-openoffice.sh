#!/bin/bash
host=${HOST:-'127.0.0.1'}
/opt/openoffice4/program/soffice -headless -accept="socket,host=$host,port=8100;urp;" -nofirststartwizard
