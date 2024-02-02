# Jupyter Docker Stacks with .NET kernel

Extending the [Jupyter Docker Stack images](https://github.com/jupyter/docker-stacks) with .NET 8 kernel to run notebooks in C#, F# and Powershell

.NET kernel is provided by [.NET Interactive](https://github.com/dotnet/interactive)

## Get started

This images can be started as the original Jupyter Docker Stack images (see the Jupyter Docker Stacks [ReadTheDocs](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html))

```
docker run -p 8888:8888 ghcr.io/pocki/jupyter-dotnet:minimal-dotnet8-latest
```

To persistant the notebooks mount the directory: `/home/jovyan/Notebooks`
```
docker run -p 8888:8888 ghcr.io/pocki/jupyter-dotnet:scipy-dotnet8-latest -v "$PWD":/home/jovyan/Notebooks
```

All images contain some .NET sample notebooks.

# .NET 8

New: Docker Images have new name and changed to ghcr.io



# .NET 6/.NET 7

.NET 6 kernel in tag 20220210 and later  
.NET 7 kernel in tag 20230315 and later  

Docker Images are on Docker Hub

## Following images are created:
* [minimal-dotnet](https://hub.docker.com/r/pocki/minimal-dotnet) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/pocki/minimal-dotnet) based on jupyter/minimal-notebook
* [scipy-dotnet](https://hub.docker.com/r/pocki/scipy-dotnet)![Docker Image Version (latest by date)](https://img.shields.io/docker/v/pocki/scipy-dotnet) based on jupyter/scipy-notebook
* [r-dotnet](https://hub.docker.com/r/pocki/r-dotnet) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/pocki/r-dotnet) based on jupyter/r-notebook


