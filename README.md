# Custom GU Catalogues for GraalVM

## Overview
Sometimes we would like to be able to use a custom catalogue location to control what components
we install into a distribution GraalVM and from where they are installed. As `gu`, the GraalVM
Updater tool, doesn't wok very well with authenticated proxies the ability to do this is super
useful.

This repo is a very simple demonstration of how to set this up and how to use this.

## Setting Cutom Catalogue URLs
They can either be passed to the `gu` tool or can be defined by an environment variable, `GRAALVM_CATALOG`. The
`Makefile` has two examples using both scenarios. The target in the makefile, `list-using-env`, demonstrates 
using environment variables to set the custom catalogue.

## Installtion of Components
This works for any Java version, but this demo is set up for JDK 11

1. Install GraalVM EE 21.2.0.1 Java 11 [link]([https://www.oracle.com/downloads/graalvm-downloads.html?selected_tab=1)
2. Download the following components, you will need to login and accept the license alert box:
  1. [llvm component](https://www.oracle.com/downloads/graalvm-downloads.html?selected_tab=1#license-lightbox)
  2. [Ruby component](https://www.oracle.com/downloads/graalvm-downloads.html?selected_tab=1#license-lightbox)
3. Place the downloaded components into the folder : `catalogues/21.2.0.1/11/`

## Usage
All of the parts of this demo are run through a `Makefile`. There are targets defined for each activity.
Running `make help` will list these and give a full description.

NOTE: This demo uses the EE components, and you need to download them manually and place them in adirectory for
the web server, as in the setion above.

Typical usage will be as follows (once you have done the setup steps defined in the section above):

```shell
# Run the web server that will host the catalogue
$ make server

# List the components available within the custom catalogue
$ make list

# Install a component from the custom catalogue
$ make install TruffleRuby
```

