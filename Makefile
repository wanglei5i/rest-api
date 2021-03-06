ifndef RELEASE_DIR
	RELEASE_DIR = $(PWD)/build
endif
export RELEASE_DIR
compile_dir=${PWD}
APP_NAME = rest-api
CONFIG_DIR = usr/local/${APP_NAME}
version = $(shell git rev-list --all|wc -l )
pom_version = $(shell git rev-list --all pom.xml|wc -l )

build_dir:
	rm -rf ${RELEASE_DIR}
	mkdir -p $(RELEASE_DIR)/$(CONFIG_DIR)/conf
	mkdir -p $(RELEASE_DIR)/$(CONFIG_DIR)/lib
	mkdir -p $(RELEASE_DIR)/$(CONFIG_DIR)/bin
	mkdir -p $(RELEASE_DIR)/$(CONFIG_DIR)/log
install: build_dir
	rm -rf ${APP_NAME}-1.0-r*.tgz
	mvn clean package -Dmaven.test.skip=true
	cp -a target/${APP_NAME}-1.0.jar.original $(RELEASE_DIR)/$(CONFIG_DIR)/lib/${APP_NAME}-1.0.jar.original
	unzip target/${APP_NAME}-1.0.zip -d target/
	cp -rf target/${APP_NAME}-1.0/lib/* $(RELEASE_DIR)/$(CONFIG_DIR)/lib
	cp -a  target/${APP_NAME}-1.0/config/* $(RELEASE_DIR)/$(CONFIG_DIR)/conf
	cp -a shell/${APP_NAME} $(RELEASE_DIR)/$(CONFIG_DIR)/bin
	cp -a shell/health_check $(RELEASE_DIR)/$(CONFIG_DIR)/bin
	cp -a shell/install $(RELEASE_DIR)
	cp -a shell/initx $(RELEASE_DIR)/$(CONFIG_DIR)/bin
	cp -a shell/rest_service.cfg $(RELEASE_DIR)/$(CONFIG_DIR)/conf
	echo "$(version)" > $(RELEASE_DIR)/$(CONFIG_DIR)/version
	chmod +x $(RELEASE_DIR)/$(CONFIG_DIR)/bin/${APP_NAME}
	chmod +x $(RELEASE_DIR)/$(CONFIG_DIR)/bin/health_check
	chmod +x $(RELEASE_DIR)/$(CONFIG_DIR)/bin/initx
	chmod +x  $(RELEASE_DIR)/install
	cd ${RELEASE_DIR}  && tar zcf ../${APP_NAME}-1.0-r${version}.tgz ./*
	ls -lh ${APP_NAME}-1.0-r${version}.tgz | awk -F ' ' '{print $$5}'> $(RELEASE_DIR)/$(CONFIG_DIR)/package.info
	echo "r${version}" >> $(RELEASE_DIR)/$(CONFIG_DIR)/package.info
	rm -rf ${APP_NAME}-1.0-r${version}.tgz
	cd ${RELEASE_DIR}  && tar zcf ../${APP_NAME}-1.0-r${version}.tgz ./*
ifneq (${version},${pom_version})
	rm -rf $(RELEASE_DIR)/$(CONFIG_DIR)/lib/*
	cp -a target/${APP_NAME}-1.0.jar.original $(RELEASE_DIR)/$(CONFIG_DIR)/lib/${APP_NAME}-1.0.jar.original
	cd ${RELEASE_DIR}  && tar zcf ../${APP_NAME}-1.0-r${version}-fup\(r${pom_version}\).tgz ./* 
	ls -lh ${APP_NAME}-1.0-r${version}-fup\(r${pom_version}\).tgz | awk -F ' ' '{print $$5}'> $(RELEASE_DIR)/$(CONFIG_DIR)/package.info
	echo "r${version}" >> $(RELEASE_DIR)/$(CONFIG_DIR)/package.info
	rm -rf ${APP_NAME}-1.0-r${version}-fup\(r${pom_version}\).tgz
	cd ${RELEASE_DIR}  && tar zcf ../${APP_NAME}-1.0-r${version}-fup\(r${pom_version}\).tgz ./*
endif
	rm -rf target
	rm -rf ${RELEASE_DIR}
clean:
	rm -rf target
	rm -rf $(RELEASE_DIR)

