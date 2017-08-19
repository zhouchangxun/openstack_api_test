#!/bin/sh  
#source get_token.sh
source ./mytoken.txt  

# Try Nova API  
#curl -X GET ${OS_COMPUTE_URL}/servers -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -s  | python -m json.tool

echo url: ${OS_BARBICAN_URL}/v1/secrets
echo token: ${TOKEN}
ret=`curl  -X GET  "${OS_BARBICAN_URL}/v1/secrets/41270574-52ba-4423-878a-d9bb24c2fbff/payload" \
    -H "Content-Type: application/json" \
    -H "X-Auth-Token: ${TOKEN}" -s ` 
    echo ret:$ret 
    echo ret | python -m json.tool
# Send a request to store the key in Barbican
    curl -vv -H "X-Auth-Token: $TOKEN" -H 'Accept: application/json' \
	    -H 'Content-Type: application/json' \
	    -d '{"name": "AES encryption key",
		    "secret_type": "opaque",
		    "payload": "changxun",
		    "payload_content_type": "text/plain",
		    "algorithm": "AES",
		    "bit_length": 256,
		    "mode": "CBC"}' \
	    ${OS_BARBICAN_URL}/v1/secrets 
