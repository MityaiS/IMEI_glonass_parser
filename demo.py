#!/usr/bin/python3

from operator import truediv
import sys
import time
import json

if sys.version_info[0] < 3:
    print("Sorry, this program requires python-3.x")
    sys.exit(1)

from dispatchapi.thrift.client import Client as ThriftClient
from dispatchapi.dispatch.server.thrift.backend.ttypes import ReportRequest

import logging

logger = logging.getLogger(__name__)

def __main():
    import argparse
    from urllib.error import URLError

    parser = argparse.ArgumentParser(
        prog='Demo getting report wia thrift api',
        formatter_class=lambda prog: argparse.ArgumentDefaultsHelpFormatter(prog, max_help_position=200)
    )

    parser.add_argument('-l', '--login', help="DS user", required=True)
    parser.add_argument('-p', '--password', help="password", required=True)
    parser.add_argument('-t', '--thrift-host', help="DS Thrift API host", required=True)
    parser.add_argument('-T', '--thrift-port', help="DS Thrift API port", required=True, default=19990)
    parser.add_argument('--log-config', help="logger configuration")

    args = parser.parse_args()

    if args.log_config:
        from logging.config import fileConfig
        fileConfig(args.log_config, disable_existing_loggers=False)
    else:
        logging.basicConfig(level = logging.INFO, format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S')

    thrift_client = ThriftClient(args.thrift_host, int(args.thrift_port))
    thrift_session = thrift_client.login(args.login, args.password, False)

    repReq = ReportRequest(
        type="general",
        title="TitleReport",
        format=0, # SCREEN
        language="ru_RU",
        timezone="UTC+07:00",
        fromTimestamp=1664557200,
        toTimestamp=1667235600,
        #columns=["startMonth","moveTime","stopTime","lostSignalTime","kilometresTravelled","totalFuelConsumption","fuelRate","avgMoveSpeed","avgSpeed","maxSpeed","id","startTime","endTime"],
        columns=['fuelPer100Km', 'totalFueling', 'engineHours', 'kilometresTravelled', 'maxSpeed', 'avgMoveSpeed', 'stopTime'],
        groupBy="gb_month",
        argumentType=0, # VEHICLE
        argumentIds=["5ea4e584-a3f6-4beb-81bd-84dbfa51f3ba"]
    )

    repReq2 = ReportRequest(
        type="eventsDetailedReport",
        title="TitleReport",
        format=0, # SCREEN
        language="ru_RU",
        timezone="UTC+07:00",
        fromTimestamp=1664557200,
        toTimestamp=1667235600,
        argumentType=0, # VEHICLE
        argumentIds=["3ab627fb-973a-42c0-8027-a911d81133ad"]
    )

    repReq3 = ReportRequest(
        type="pairEventsSummaryReport",
        title="TitleReport",
        format=0, # SCREEN
        language="ru_RU",
        timezone="UTC+07:00",
        fromTimestamp=1666803600,
        toTimestamp=1666890000,
        argumentType=0, # VEHICLE
        argumentIds=["ea203952-4b47-4321-828b-3fa1d8dd7825"]
    )

    repReq4 = ReportRequest(
        type="eventsByPeriodGeneralReport",
        title="Сводный отчет по событиям за период",
        format=0, # SCREEN
        language="ru_RU",
        timezone="UTC+07:00",
        fromTimestamp=1666803600,
        toTimestamp=1666890000,
        argumentType=0, # VEHICLE
        argumentIds=["d465d24d-8e08-47d6-82ca-820fed555ca6"]
    )

    repReq5 = ReportRequest(
        type="eventsByPeriodGeneralReport",
        title="Сводный отчет по событиям за период",
        format=0, # SCREEN
        language="ru_RU",
        timezone="UTC+07:00",
        fromTimestamp=1666803600,
        toTimestamp=1666890000,
        argumentType=0, # VEHICLE
        argumentIds=["d465d24d-8e08-47d6-82ca-820fed555ca6"]
    )

    try:
        print("request general report build with params: {}".format(repReq))
        repResp = thrift_client.buildScreenReport(thrift_session, repReq)
        print("received report response: {}".format(repResp))

        print("request eventsDetailedReport report build with params: {}".format(repReq2))
        repResp2 = thrift_client.buildScreenReport(thrift_session, repReq2)
        print("received report response: {}".format(repResp2))

        print("request pairEventsSummaryReport report build with params: {}".format(repReq3))
        repResp3 = thrift_client.buildScreenReport(thrift_session, repReq3)
        print("received report response: {}".format(repResp3))

        print("request eventsByPeriodGeneralReport report build with params: {}".format(repReq4))
        repResp4 = thrift_client.buildScreenReport(thrift_session, repReq4)
        print("received report response: {}".format(repResp4))

    except Exception as e:
        logger.error("Cannot build report due to error: '%s'", repr(e))


if __name__ == '__main__':
    __main()

