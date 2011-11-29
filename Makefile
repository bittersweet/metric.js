SRC_DIR = src
BUILD_DIR = build

all:
	@@coffee -o ${BUILD_DIR} -c ${SRC_DIR}/api.coffee
	@@echo "api.coffee built"

test:
	@@jasmine-node --coffee .
