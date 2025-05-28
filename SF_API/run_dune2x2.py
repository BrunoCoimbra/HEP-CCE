import requests
from authlib.integrations.requests_client import OAuth2Session
from authlib.oauth2.rfc7523 import PrivateKeyJWT
import json, time

token_url = "https://oidc.nersc.gov/c2id/token"
client_id = "Please add your client ID Here"

from authlib.jose import jwt, JsonWebKey

# Load the private key from a PEM file
with open('Please add path to the private key in PEM format', 'rb') as key_file:
    private_key = key_file.read()


session = OAuth2Session(
    client_id,
    private_key,
    PrivateKeyJWT(token_url),
    grant_type="client_credentials",
    token_endpoint=token_url
)
access_token = session.fetch_token()['access_token']
#print(session.fetch_token())
#print("access tocken is ---->>>>")
#print(access_token)

###################################################
#Call Superfacility API
print("################################################### ")
print("Call Superfacility API")
r = requests.get("https://api.nersc.gov/api/v1.2/tasks?tags=%20", headers={ "accept": "application/json", "Authorization": access_token})
print(r.json())
print(" ")

###################################################
#Check Perlmutter Status
print("################################################### ")
print("Check perlmutter status")
system = "perlmutter"
r = session.get("https://api.nersc.gov/api/v1.2/status/"+system)
perlmutter_status = r.json()
print(perlmutter_status)
print(" ")

###################################################
#Listing Directory Contents
print("################################################### ")
print("Listing Directory Contents")
system = "perlmutter"
home = "/global/homes/o/okilic"
r = session.get("https://api.nersc.gov/api/v1.2/utilities/ls/"+system+home)
home_ls = r.json()
print(json.dumps(home_ls, indent=2))
print(" ")

###################################################
#Retrieving File Information
print("################################################### ")
print("Retrieving File Information")
system = "perlmutter"
filename = "/global/homes/o/okilic/run_dune2x2.py"
r = session.get("https://api.nersc.gov/api/v1.2/utilities/ls/"+system+filename)
file_ls = r.json()
print(json.dumps(file_ls, indent=2))
print(" ")

###################################################
#Running a Command on a Login Node
print("################################################### ")
print("Running a Command on a Login Node")
system = "perlmutter"
cmd = "cat /global/homes/o/okilic/run_dune2x2.py" # (e.g., "cat /global/homes/u/username/script.sh")
task = session.post("https://api.nersc.gov/api/v1.2/utilities/command/"+system,
                  data = {"executable": cmd})
taskid=task.json()['task_id']
print(task.json())
print(" ")

###################################################
#Getting Task Information and Output
print("################################################### ")
print("Getting Task Information and Output")
time.sleep(10)
r = session.get(f"https://api.nersc.gov/api/v1.2/tasks/{taskid}")
print(r.json())
print(" ")

###################################################
#Batch Job Submission
print("################################################### ")
print("Batch Job Submission")
system = "perlmutter"
submit_script = "/global/homes/o/okilic/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/submit.sh" # (e.g., /global/homes/u/username/script.sub)
r = session.post("https://api.nersc.gov/api/v1.2/compute/jobs/"+system,
                  data = {"job": submit_script, "isPath": True})
print(r.json())
print(" ")
taskid=r.json()['task_id']

###################################################
#Getting Job Status and Information
print("################################################### ")
print("Getting Job Status and Information")
time.sleep(60)
r = session.get(f"https://api.nersc.gov/api/v1.2/tasks/{taskid}")
print(r.json())





