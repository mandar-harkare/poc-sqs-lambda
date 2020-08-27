from locust import HttpLocust, TaskSet, task
import boto3
import requests
import json
import time
import math
import random
import datetime
import hashlib
import hmac
from enum import Enum
from urllib.parse import urlparse
 
 
class WebsiteTasks(TaskSet):
    def sign(self, key, msg):
        return hmac.new(key, msg.encode("utf-8"), hashlib.sha256).digest()
     
    def getSignatureKey(self, key, date_stamp, regionName, serviceName):
        kDate = self.sign(('AWS4' + key).encode('utf-8'), date_stamp)
        kRegion = self.sign(kDate, regionName)
        kService = self.sign(kRegion, serviceName)
        kSigning = self.sign(kService, 'aws4_request')
        return kSigning
     
    def create_auth(self, json_payload, agw_url, service='execute-api', region="us-east-2"):
        """
        Create signed aws4 header.
        :param json_payload: payload we want to hash for the signature
        :param agw_url: endpoint url
        :param service: aws service name
        :param region: aws region where the service is located
        :return: signed aws4 headers
        """
 
        # stamps for signing requests
        timestamp_in_utc = datetime.datetime.utcnow()
        amz_date = timestamp_in_utc.strftime('%Y%m%dT%H%M%SZ')
        date_stamp = timestamp_in_utc.strftime('%Y%m%d')
     
        parsed_uri = urlparse(agw_url)
        host = '{uri.netloc}'.format(uri=parsed_uri)
        method = 'POST'
        access_key = "user_key"
        secret_key = "user_secret"
        sts_token = "user_session_token"
        canonical_uri = '{uri.path}'.format(uri=parsed_uri)
        canonical_querystring = ''
        canonical_headers = 'host:' + host + '\n' + 'x-amz-date:' + amz_date + '\n'
        signed_headers = 'host;x-amz-date'
     
        payload = json.dumps(json_payload)
     
        # generating sha256 hash from payload
        payload_hash = hashlib.sha256(payload.encode('utf-8')).hexdigest()
     
        canonical_request = (method + '\n' +
                             canonical_uri + '\n' +
                             canonical_querystring + '\n' +
                             canonical_headers + '\n' +
                             signed_headers + '\n' +
                             payload_hash)
        algorithm = 'AWS4-HMAC-SHA256'
        credential_scope = date_stamp + '/' + region + '/' + service + '/' + 'aws4_request'
     
        # creating string to sign
        string_to_sign = (algorithm + '\n' +
                          amz_date + '\n' +
                          credential_scope + '\n' +
                          hashlib.sha256(canonical_request.encode('utf-8')).hexdigest())
        signing_key = self.getSignatureKey(secret_key, date_stamp, region, service)
        signature = hmac.new(signing_key, (string_to_sign).encode('utf-8'), hashlib.sha256).hexdigest()
     
        # creating signed auth header
        authorization_header = (algorithm + ' ' +
                                'Credential=' + access_key + '/' +
                                credential_scope + ', ' +
                                'SignedHeaders=' + signed_headers + ', ' + 'Signature=' + signature)
     
        # creating request header
        headers = {'x-amz-content-sha256': payload_hash,
                   'X-Amz-Date': amz_date,
                   'Authorization': authorization_header}
        if sts_token:
            headers['X-Amz-Security-Token'] = sts_token
         
        return headers
         
    # def on_start(self):
    #     infrastructure = {
    #         "infra_id": "59e0f964-ae88-4a86-97ea-551abd080700",
    #         "tenantId": "e29b82a5-8fec-4e53-8a4b-e9e51ce53dd1",
    #         "type": "NGFW",
    #         "instanceId": "3548248c-e79b-4422-a77e-f35b2afa54c1",
    #         "region": "us-east-2"
    #     }
    #     with open('getInfrastructure.graphql', 'r') as graphql_file:
    #         query = graphql_file.read()
    #         if infrastructure:
    #             json = {
    #                 'query': query,
    #                 'variables': infrastructure
    #             }
    #         else:
    #             json = {
    #                 'query': query
    #             }
    #     headers = self.create_auth(json, "https://infrastructure-fa3819.msvokxavdlwatqovcwze.com/graphql", 'execute-api', "us-east-2")
    #     self.client.post("https://infrastructure-fa3819.msvokxavdlwatqovcwze.com/graphql", json=json, headers=headers)
     
    @task
    def index(self):
        infrastructure = {
            "infra_id": "59e0f964-ae88-4a86-97ea-551abd080700",
            "tenantId": "e29b82a5-8fec-4e53-8a4b-e9e51ce53dd1",
            "type": "NGFW",
            "instanceId": "3548248c-e79b-4422-a77e-f35b2afa54c1",
            "region": "us-east-2"
        }
        with open('getInfrastructure.graphql', 'r') as graphql_file:
            query = graphql_file.read()
            if infrastructure:
                json = {
                    'query': query,
                    'variables': infrastructure
                }
            else:
                json = {
                    'query': query
                }
        headers = self.create_auth(json, "https://infrastructure-fa3819.msvokxavdlwatqovcwze.com/graphql", 'execute-api', "us-east-2")
        self.client.post("https://infrastructure-fa3819.msvokxavdlwatqovcwze.com/graphql", json=json, headers=headers)
 
 
class WebsiteUser(HttpLocust):
    task_set = WebsiteTasks
    min_wait = 5000
    max_wait = 15000