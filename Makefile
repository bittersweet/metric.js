SRC_DIR = src
BUILD_DIR = build

all:
	@@coffee -o ${BUILD_DIR} -c ${SRC_DIR}/api.coffee
	@@uglifyjs -o ${BUILD_DIR}/api.min.js ${BUILD_DIR}/api.js
	@@echo "api.coffee built and packaged"

test:
	@@jasmine-node --verbose --coffee spec
