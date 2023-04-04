import thriftpy2
dispatch_thrift = thriftpy2.load("dispatchbackend.thrift", module_name="dispatch_thrift")

from thriftpy2.http import make_client
from thriftpy2.protocol.apache_json import TApacheJSONProtocolFactory

client = make_client(dispatch_thrift.DispatchBackend, host="monitoring.aoglonass.ru", port=443, scheme="https",
                     proto_factory=TApacheJSONProtocolFactory())

s = client.login("smart", "IkF9mf", False)

print(s.id)
