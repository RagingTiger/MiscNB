# Miscellaneous Notebooks
A collection of various `Jupyter` Notebooks related to machine learning and
data science in general.

## Project Organization

    ├── Makefile   <- Makefile with commands like `make data` or `make train`
    ├── README.md  <- The top-level README for developers using this project.
    │
    └── notebooks  <- Jupyter notebooks directory.

## Make
Here we will document the different `make` commands defined in the `Makefile`.
All *commands* (excluding the `all` command which is simply executed by
running `make`) are executed by the following format: `make [COMMAND]`. To see
the *contents* of a command that will be executed upon invocation of the
command, simply run `make -n [COMMAND]`.

### Commands
+ `all`: (*aka*: `make`) alias for `jupyter` command
+ `jupyter`: launches the Jupyter notebook development Docker image
+ `containers`: launch all Docker containers
+ `list-containers`: list all running containers
+ `stop-containers`: simply stops all running Docker containers
+ `restart-containers`: restart all containers
+ `clear-nb`: simply clears Jupyter notebook output
+ `clean`: combines all clearing commands into one

## Docker
This is the same Docker command that is defined in the `Makefile` as the
`jupyter` command. To run it outside of `make`, first `git clone` the repo:
```
git clone https://github.com/RagingTiger/MiscNB.git
```
Then `cd MiscNB` and run the following:
```
docker run -d \
           --rm \
           --name misc_nb \
           -e JUPYTER_ENABLE_LAB=yes \
           -p 8888 \
           -v $PWD:/home/jovyan \
           ghcr.io/ragingtiger/omega-notebook:master && \
sleep 5 && \
  docker logs misc_nb 2>&1 | \
    grep "http://127.0.0.1" | tail -n 1 | \
    sed "s/:8888/:$(docker port misc_nb | \
    grep '0.0.0.0:' | awk '{print $3'} | sed 's/0.0.0.0://g')/g"
```
Click the link (should look similar to:
http://127.0.0.1:RANDOM_PORT/lab?token=LONG_ALPHANUMERIC_STRING) which will
`automatically` log you in and allow you to start running the *notebooks*.

--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
