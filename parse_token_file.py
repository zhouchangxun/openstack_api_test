import argparse  
import json
import sys  

# Return a dict representing json  
def get_auth_result(TOKEN_FILE):  
    try:
        with open(TOKEN_FILE, "r") as token_file:
            body = token_file.read()
            json_body = json.loads(body)
    except Exception as ex:
        print("Error: %s" % ex)
        json_body = None
    finally:
        return json_body


def get_token(json_body):  
    try:
        token = json_body['access']['token']['id']
    except Exception as ex:
        print("Error: %s" % ex)
        token = None
    finally:
        return token

def get_service_url(type, json_body):
    service_url = None
    try:
        service_catalog = json_body['access']['serviceCatalog']
        for service in service_catalog:
            if service.get('name', None) == type:
                service_url = service['endpoints'][0]['publicURL']
                break
    except Exception as ex:
        print("Error: %s" % ex)
    finally:
        return service_url

def main():
    parser = argparse.ArgumentParser(prog="python %s" % sys.argv[0])
    parser.add_argument("--token_file", dest='token_file', required=True,
            help="Specify the token file which is generated by curl command")
    parser.add_argument("--get_token", dest='need_token', action='store_true', default=False,
            help="Parse the token file and return the token")

    parser.add_argument("--get_service_url", dest='type', required=False,
            help="Specify service type such as [nova,neutron,barbican]")
    args = parser.parse_args()

    token_file = args.token_file
    need_token = args.need_token
    service_type = args.type

    json_body = get_auth_result(token_file)
    if json_body is None:
        return

    token = get_token(json_body)
    if token is None:
        print("Error: Token is none")
        return -1

    if need_token:
        print(token)
    if service_type:
        service_url = get_service_url(service_type, json_body)
        if service_url is not None:
            print(service_url)
        else:
            print("Error: "+service_type+" URL is None")

if __name__ == "__main__":
    main()
