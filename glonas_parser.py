import thriftpy2
dispatch_thrift = thriftpy2.load("thrift_files/dispatchbackend.thrift")

from thriftpy2.rpc import make_client
from thriftpy2.protocol.apache_json import TApacheJSONProtocolFactory

client = make_client(dispatch_thrift.DispatchBackend, "monitoring.aoglonass.ru", port=19991,
                     proto_factory=TApacheJSONProtocolFactory())

s = client.login("smart", "IkF9mf", False)

print(s.id)
