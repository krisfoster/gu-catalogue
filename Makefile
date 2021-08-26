.PHONY: help

PWD=$$PWD
GRAAL_VER=21.2.0.1
JAVA_VER=11
### DEMO ENV VARS for use in creating the specific catalogue from the templated one
URL=http://localhost
PORT=8080
OS_NAME=macos
OS=darwin
ARCH=amd64
JDK_VER=11

#CATALOGUE=http://localhost:8080/$(GRAAL_VER)/graal-updater-ee-component-catalog-java11.properties
CATALOGUE=http://localhost:8080/$(GRAAL_VER)/gu-catalog-$(GRAAL_VER)-jkdk$(JAVA_VER).properties
INSTALLABLE?=TruffleRuby



help:
	@echo "This makefile has targets for all the activities that we want to demonstrate:"
	@echo "**********************************************************************************************************"
	@echo ""
	@echo "* build-config: Builds the gu catalogue from a template, using environment variables"
	@echo ""
	@echo ""
	@echo "* show-config: Prints the current config, such as the cutom catalogue URL for gu"
	@echo ""
	@echo "* server: this starts the custom catalogue server. Do this first, before running list or install"
	@echo ""
	@echo "* list: lists the components available in the catalogue"
	@echo ""
	@echo "* list: lists the components available in the catalogue, but making use of an ENV variable to set catalogue"
	@echo ""
	@echo "* install: This installs a component. By default this is ruby, but you can specify what to install as below:"
	@echo "		\$$ make install INSTALABLE=llvm"

build-config:
	# The env var are defined on one line here... but normally you would want these set within a shell
	# Again, note that this must all be on 1 line, as separate lines create child shells in which the variables il be set
	# whihc will then just return.... and the var is then not set in the shell running the command
	export URL=$(URL) && \
    export PORT=$(PORT) && \
    export OS_NAME=$(OS_NAME) && \
    export OS=$(OS) && \
    export ARCH=$(ARCH) && \
    export JDK_VER=$(JDK_VER) && \
    export GRAAL_VER=$(GRAAL_VER) && \
    envsubst < catalogues/$(GRAAL_VER)/graal-updater-ee-component-catalog-java$(JDK_VER)-TEMPLATE.properties \
             > catalogues/$(GRAAL_VER)/gu-catalog-$(GRAAL_VER)-jdk$(JDK_VER).properties

show-config:
	@echo "Java Version   : $(JAVA_VER)"
	@echo "GraalVM Version: $(GRAAL_VER)"
	@echo "Catalogue URL  : $(CATALOGUE)"

server:
	@echo "Starting catalogue server..."
	# -d
	docker run -it --rm -d -p 8080:80 --name web -v $$(PWD)/catalogues/:/usr/share/nginx/html nginx

list:
	@echo "Listing available components in the custom catalogue"
	gu --custom-catalog $(CATALOGUE) list

list-using-env:
	@echo "Listing available components in the custom catalogue, which is defined using a ENV variable"
	# Important : the shell var needs to be defined on the same line as each line is run in a separate child process
	# Which means that you set the variable in a child shell that exist after the varibale is set :)
	export GRAALVM_CATALOG=$(CATALOGUE) && gu list

install:
	@echo "Installing component : $(INSTALLABLE)"
	gu --custom-catalog $(CATALOGUE) install $(INSTALLABLE)
