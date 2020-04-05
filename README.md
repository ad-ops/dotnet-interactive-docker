# Dotnet Interactive Docker
Runs the dotnet-interactive in a docker container so it can be easily shared.

YOu can also use the provided `Dockerfile` in https://github.com/dotnet/interactive/tree/master/docker-image to use instead of this (which might be wiser:-)).

## How to use
`cd {your workspace}/dotnet-try-container`

`docker build --tag jupyter/dotnet .`

`docker run -p 8888:8888 --rm jupyter/dotnet`

Browse to http://localhost:8888 and start working. Don't forget that nothing you do will survive shuting down the container. Either download the notebooks or mount a local volume when running the image. Note that when mounting a volume it will overwrite the demo notebooks. You can upload them if you want them.

`docker run -v ${PWD}/work:/app -p 8888:8888 --rm jupyter/dotnet`

## Things to consider
- Set a default password to be used.
- Can we spin up a new container on demand for each user?
- Is it safe to run in a container?
