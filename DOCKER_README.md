# Running New Sanctuary Asylum in a Docker Container

## Installing Docker:
[For Mac](https://docs.docker.com/docker-for-mac/install/)
[For Windows](https://docs.docker.com/docker-for-windows/install/)

Confirm docker is installed by typing `docker info` in your terminal.

## Using Docker

### Building The Image
The first time you run the application in docker, you need to build the docker-compose image. This will create a static artifact that will be used to start the containers. You only need to build once, or if you change the Dockerfile, docker-compose.yml file, or make changes to the database.

Run:
```
docker-compose -f docker-compose.yml build
```

On a mac, you can shorten this by running `make build`, which is defined in the [Makefile]('Makefile').

### To Start and Run the Containers
Now that the image has been build, we need to start the containers for the web application and the database. We do this with the `up` command.

Run: `docker-compose -f docker-compose.yml up` or `make up` (for macs).

### To Stop the Containers
To stop your running container process, press `ctrl+c`. To bring down the containers cleanly, run `docker-compose -f docker-compose.yml down` or `make down` (for macs).

To confirm the containers have stopped, you can take a look with `docker ps` -- the output should be empty.

## Docker Workflow
While you're developing, you should be able to work in your text editor and see your changes to the application while the container is up and running.

The server may need to be restarted at times, such as after adding new migrations or adding or updating gems. If you previously would have had to restart the rails server to see changes, instead you'll have to `down` and `up` the docker container. 

### Running Commands inside a Container
To run the rails console or rspec, you have to `exec` into a running container. This application has two: a `web` container, which contains the rails application, and a `db` container, which contains the postgres database.

#### To Run Rails Console
Run: `docker exec -it sanctuary_web /bin/bash` then `rails c`.

#### To Run Rspec
To interactively run tests, run: `docker exec -it sanctuary_web /bin/bash` then `rspec .`.
To just see test results, run: `docker exec -it sanctuary_web rspec` or `make test` (for macs).

#### To Open a PSQL Console
Run: `docker exec -it sanctuary_db psql -U postgres`

Some shortcuts for using PSQL: [cheatsheet](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546)


## Docker Troubleshooting
To start from scratch completely and eliminate previously-built images, run `docker-compose -f docker-compose.yml down --rmi all` or `make down_clean` (for macs).

If you get the error `A server is already running. Check /tmp/sanctuary/tmp/pids/server.pid`, in another tab run 

```
docker start sanctuary_web; docker exec sanctuary_web rm /sanctuary/tmp/pids/server.pid
```
and the container should restart with a new pid.

