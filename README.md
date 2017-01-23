# EPIC - simulation of emergent production in construction
This is an open source (LGPL) academic project for agent-based construction workflow simulation.
It is written in python, all the simulation setup data are pulled from an excel file.
The simulation process is recorded in a sqlite database, and the result is exported in a csv file.

## Dependencies:

### First:
$ conda install sqlalchemy psycopg2 pandas xlrd requests

### Then:
$ pip install -U https://github.com/RandomOrg/JSON-RPC-Python/zipball/master

## Run the simulation
$ python simcon.py

## Other interesting things:

### online sqlite:
https://sqliteonline.com/#fiddle-583c426547fb1518c230cd865cb8c9f448ea93066a6e390846

### Web-based SQLite database browser written in Python
$ pip install sqlite-web
$ sqlite_web simcon.db -H 0.0.0.0