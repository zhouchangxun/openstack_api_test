#!/bin/sh  

export OS_AUTH_URL='http://10.157.0.216:5000/v2.0'  
export OS_TENANT_NAME='demo'  
export OS_USERNAME='admin'  
export OS_PASSWORD='123456'  


# Get Token  
curl  -X POST ${OS_AUTH_URL}/tokens -H "Content-Type: application/json" -d '{  
	"auth": {  
		"tenantName": "'"${OS_TENANT_NAME}"'",   
			"passwordCredentials": {  
				"username": "'"${OS_USERNAME}"'",   
				"password": "'"${OS_PASSWORD}"'"  
			}  
	}  
}' | python -m json.tool > token.txt 2>&1   

TOKEN=`python parse_token_file.py --token_file ./token.txt --get_token`  

OS_COMPUTE_URL=`python parse_token_file.py --token_file ./token.txt --get_service_url nova`
OS_NETWORK_URL=`python parse_token_file.py --token_file ./token.txt --get_service_url neutron`
OS_BARBICAN_URL=`python parse_token_file.py --token_file ./token.txt --get_service_url barbican`

echo "export TOKEN=$TOKEN" > mytoken.txt  
echo "export OS_COMPUTE_URL=$OS_COMPUTE_URL" >> mytoken.txt 
echo "export OS_NETWORK_URL=$OS_NETWORK_URL" >> mytoken.txt
echo "export OS_BARBICAN_URL=$OS_BARBICAN_URL" >> mytoken.txt
