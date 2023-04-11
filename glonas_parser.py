import thriftpy2
dispatch_back = thriftpy2.load("thrift_files/dispatchbackend.thrift")
dispatch_common = thriftpy2.load("thrift_files/dispatchCommon.thrift")

from thriftpy2.rpc import make_client
from thriftpy2.transport import TFramedTransportFactory

client = make_client(dispatch_back.DispatchBackend, "monitoring.aoglonass.ru", 19990,
                     trans_factory=TFramedTransportFactory())

s = client.login("smart", "IkF9mf", False)
pos_req_fields = dispatch_common.PositionRequestFields(["received_timestamp"])

positions = client.getRecentPositions(s, ["d7c92395-e830-4eb7-bcd0-e38c16aba4b1"], pos_req_fields)

# for pos in positions:
#     for value in pos.position.values:
#         print(value)
print(positions)
