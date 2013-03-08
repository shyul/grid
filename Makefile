LOPHILO_DIR:=${HOME}/lophilo
FIRMWARE_BINARIES:=${LOPHILO_DIR}/firmware-binaries

all: firmware

firmware: output/grid.rbf
	cp output/grid.rbf ${FIRMWARE_BINARIES}
	git describe --always > ${FIRMWARE_BINARIES}/grid.txt
