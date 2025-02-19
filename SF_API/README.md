# Running Dune on Perlmutter using Superfacility API

This guide outlines the steps to run Dune on Perlmutter using the Superfacility API.

## Step 1: Create Superfacility API Clients in IRIS

1. **Create an API Client in IRIS**:
   - A client (RED) was created using Perlmutter as the IP.
   - This client is only valid for 48 hours but is necessary for running tasks.
   - The API provides a public and private key upon creation. **Make sure to save them.**

2. **Generate a Session Token Using the Private Key**:
   - A Python script was created to generate an access token using the provided documentation.
   - The access token is only active for 10 minutes.
   - Script location:
     ```
     /global/homes/o/okilic/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/get_access_token.py
     ```

3. **Call the Superfacility API with the Access Token**:
   - Use the generated token to make API calls.
   - Script location:
     ```
     /global/homes/o/okilic/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/call_superfacilityAPI.py
     ```
   - If the call returns:
     ```json
     {"detail": "Not authenticated"}
     ```
     it may indicate an expired or invalid access token.

## Running from a Local Computer

The same steps apply when running from a local machine. However, ensure that:
- **IP masking or security measures around your IP address are disabled**, as the registered IP must match the one used in the IRIS API client creation.

Following these steps will enable successful interaction with the Superfacility API on Perlmutter.

