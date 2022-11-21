from datetime import datetime, timezone
import requests
import sqlite3
import sys

# Read the plug IP addresses (e.g. '20 21') from the command line
plugips = sys.argv[1:]

CMDFMT = "http://192.168.1.{ip}/cm?cmnd=Status 8"

ts = datetime.now(timezone.utc).isoformat(sep=" ", timespec="seconds")
powers = {"date": f'"{ts}"'}

for plugip in plugips:
    cmd = CMDFMT.format(ip=plugip)
    try:
        res = requests.post(cmd).json()
    except requests.ConnectionError:
        #res = {"StatusSNS": {"ENERGY": {"Power": 0}}}
        continue

    power = {f"sp{int(plugip):02d}": str(res["StatusSNS"]["ENERGY"]["Power"])}

    powers = powers | power

sql = (f"INSERT INTO spdata ({','.join(powers.keys())})"
       f" VALUES ({','.join(powers.values())});")

# Write to the sqlite database
conn = sqlite3.connect("/data/smartplugmon.sqlite")
cur = conn.cursor()
cur.execute(sql)
conn.commit()
conn.close()
