import requests
from thrift_converter import ThriftJsonConverter
import json

data = '[1,"login",1,0,{"1":{"str":"smart"},"2":{"str":"IkF9mf"},"3":{"tf":0}}]'
print(data)

headers = {"Content-Type": "application/x-thrift"}

res = requests.post("https://monitoring.aoglonass.ru", data=data)

print(res.headers)
print(res.text)
