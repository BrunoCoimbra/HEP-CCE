from authlib.integrations.requests_client import OAuth2Session
from authlib.oauth2.rfc7523 import PrivateKeyJWT

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
session.fetch_token()
