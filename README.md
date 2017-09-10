# EPIC - simulation of emergent production in construction
This is an open source (LGPL) academic project for agent-based construction workflow simulation.
It is written in python, all the simulation setup data are pulled from an excel file.
The simulation process is recorded in a postgresql database.

## Dependencies:

### First:
$ sudo conda install sqlalchemy psycopg2 pandas xlrd -y

### Then get postgresql:
setup a postgresql database. host: localhost, user: epic, pwd: epic, database: epic, port: 5432

## Run the simulation
$ python epic.py

run the epic.process.sql in postgresql environment


## On mac, get postgresql using homebrew:
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
brew install postgresql;
### start server
pg_ctl -D /usr/local/var/postgres start && brew services start postgresql;
### run postgresql script
psql postgres;
postgres=# CREATE ROLE epic WITH LOGIN PASSWORD 'epic';
postgres=# ALTER ROLE epic CREATEDB;
postgres=# \q;
psql postgres -U epic;
postgres=> CREATE DATABASE epic;
postgres=> GRANT ALL PRIVILEGES ON DATABASE epic TO epic;
