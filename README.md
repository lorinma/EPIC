# EPIC - simulation of emergent production in construction
This is an open source (LGPL) academic project for agent-based construction workflow simulation.
It is written in python, all the simulation setup data are pulled from an excel file.
The simulation process is recorded in a postgresql database.

## Dependencies:

### First:
$ conda install sqlalchemy psycopg2 pandas xlrd

### Then:
setup a postgresql database. host: localhost, user: postgres, pwd: 000000, database: epic, port: 5432

## Run the simulation
$ python epic.py

run the epic.process.sql in postgresql environment
