.PHONY: help

PWD=$$PWD
GRAAL_VER=21.2.0.1
JAVA_VER=11
CATALOGUE=http://localhost:8080/$(GRAAL_VER)/graal-updater-ee-component-catalog-java11.properties
INSTALLABLE?=TruffleRuby

help:
	@echo "This makefile has targets for all the activities that we want to demonstrate:"
	@echo "**********************************************************************************************************"
	@echo ""
	@echo "* show-config: Prints the current config, such as the cutom catalogue URL for gu"
	@echo ""
	@echo "* server: this starts the custom catalogue server. Do this first, before running list or install"
	@echo ""
	@echo "* list: lists the components available in the catalogue"
	@echo ""
	@echo "* install: This installs a component. By default this is ruby, but you can specify what to install as below:"
	@echo "		\$$ make install INSTALABLE=llvm"

show-config:
	@echo "Java Version   : $(JAVA_VER)"
	@echo "GraalVM Version: $(GRAAL_VER)"
	@echo "Catalogue URL  : $(CATALOGUE)"

server:
	@echo "Starting catalogue server..."
	# -d
	docker run -it --rm -p 8080:80 --name web -v $$(PWD)/catalogues/:/usr/share/nginx/html nginx

list:
	@echo "Listing available components in the custom catalogue"
	gu --custom-catalog $(CATALOGUE) list

install:
	@echo "Installing component : $(INSTALLABLE)"
	gu --custom-catalog $(CATALOGUE) install $(INSTALLABLE)
