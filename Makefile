.PHONY: all jupyter containers stop-containers restart-containers clear-nb clean

# Usage:
# make                    # just alias to jupyter command
# make jupyter            # startup Docker container running Jupyter server
# make containers         # launch all Docker containers
# make stop-containers    # simply stops all running Docker containers
# make restart-containers # restart all containers
# make clear-nb           # simply clears Jupyter notebook output
# make clean              # combines all clearing commands into one

################################################################################
# GLOBALS                                                                      #
################################################################################

# make cli args
DCTNR := $(notdir $(PWD))
INTDR := notebooks

# notebook-related variables
CURRENTDIR := $(PWD)
NOTEBOOKS  := $(shell find ${INTDR} -name "*.ipynb" -not -path "*/.ipynb_*/*")

# docker-related variables
JPTCTNR = jupyter.${DCTNR}
DCKRIMG = ghcr.io/ragingtiger/omega-notebook:master
DCKRRUN = docker run --rm -v ${CURRENTDIR}:/home/jovyan -it ${DCKRIMG}

# jupyter nbconvert vars
NBCLER = jupyter nbconvert --clear-output --inplace

################################################################################
# COMMANDS                                                                     #
################################################################################

# launch jupyter
all: jupyter

# launch jupyter notebook development Docker image
jupyter:
	@ echo "Launching Jupyter in Docker container -> ${JPTCTNR} ..."
	@ docker run -d \
	           --rm \
	           --name ${JPTCTNR} \
	           -e JUPYTER_ENABLE_LAB=yes \
	           -p 8888 \
	           -v ${CURRENTDIR}:/home/jovyan \
	           ${DCKRIMG} && \
	sleep 5 && \
	  echo "Server address: $$(docker logs ${JPTCTNR} 2>&1 | \
	    grep http://127.0.0.1 | tail -n 1 | \
	    sed s/:8888/:$$(docker port ${JPTCTNR} | \
	    grep '0.0.0.0:' | awk '{print $$3}' | sed 's/0.0.0.0://g')/g | \
			tr -d '[:blank:]')" && \
	echo "${JPTCTNR}" >> .running_containers

# launch all docker containers
containers: jupyter

# stop all containers
stop-containers:
	@ if [ -f ${CURRENTDIR}/.running_containers ]; then \
	  echo "Stopping Docker containers ..."; \
	  while read container; do \
	    echo "Container $$(docker stop $$container) stopped."; \
	  done < ${CURRENTDIR}/.running_containers; \
	  rm -f ${CURRENTDIR}/.running_containers; \
	else \
	  echo "${CURRENTDIR}/.running_containers file not found."; \
	fi

# restart all containers
restart-containers: stop-containers containers

# remove output from executed notebooks
clear-nb:
	@ echo "Removing all output from Jupyter notebooks."
	@ ${DCKRRUN} ${NBCLER} ${NOTEBOOKS}

# cleanup everything
clean: clear-nb
