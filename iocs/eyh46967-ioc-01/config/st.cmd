cd "$(TOP)"

dbLoadDatabase "dbd/ioc.dbd"
ioc_registerRecordDeviceDriver(pdbbase)

# simDetectorConfig(portName, maxSizeX, maxSizeY, dataType, maxBuffers, maxMemory)
simDetectorConfig("BL01T.CAM", 2560, 2160, 1, 50, 0)

# NDPvaConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, pvName, maxMemory, priority, stackSize)
NDPvaConfigure("BL01T.PVA", 2, 0, "BL01T.CAM", 0, "BL01T-EA-TST-01:IMAGE", 0, 0, 0)
startPVAServer

# instantiate Database records for Sim Detector
dbLoadRecords (simDetector.template, "P=BL01T-EA-TST-01, R=:CAM:, PORT=BL01T.CAM, TIMEOUT=1, ADDR=0")
dbLoadRecords (NDPva.template, "P=BL01T-EA-TST-01, R=:PVA:, PORT=BL01T.PVA, ADDR=0, TIMEOUT=1, NDARRAY_PORT=BL01T.CAM, NDARRAY_ADR=0, ENABLED=1")
# also make Database records for DEVIOCSTATS
dbLoadRecords(iocAdminSoft.db, "IOC=BL01T-EA-IOC-01")
dbLoadRecords(iocAdminScanMon.db, "IOC=BL01T-EA-IOC-01")

# start IOC shell
iocInit

# poke some records
dbpf "BL01T-EA-TST-01:CAM:AcquirePeriod", "0.1"
