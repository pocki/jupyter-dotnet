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
docker run -p 8888:8888 ghcr.io/pocki/jupyter-dotnet:r-dotnet8-latest -v "$PWD":/home/jovyan/Notebooks
```

All images contain some .NET sample notebooks in folder `/home/jovyan/Notebooks`.

# .NET 8

New: Docker Images have new name and changed to ghcr.io

Check available images on [Packages](https://github.com/pocki/jupyter-dotnet/pkgs/container/jupyter-dotnet):

* ghcr.io/pocki/jupyter-dotnet:minimal-dotnet8-latest
* ghcr.io/pocki/jupyter-dotnet:scipy-dotnet8-latest
* ghcr.io/pocki/jupyter-dotnet:r-dotnet8-latest

Every image type is also available with the build date in the tag do use static/fixed versions. Ex.:  
* ghcr.io/pocki/jupyter-dotnet:minimal-dotnet8-20240202
* ghcr.io/pocki/jupyter-dotnet:scipy-dotnet8-20240202
* ghcr.io/pocki/jupyter-dotnet:r-dotnet8-20240202

On build there is always the latest available version of base image, .NET and dotnet interactive used.

# .NET 6/.NET 7

.NET 6 kernel in tag 20220210 and later  
.NET 7 kernel in tag 20230315 and later  

Docker Images are on Docker Hub

## Following images are created:
* [minimal-dotnet](https://hub.docker.com/r/pocki/minimal-dotnet) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/pocki/minimal-dotnet) based on jupyter/minimal-notebook
* [scipy-dotnet](https://hub.docker.com/r/pocki/scipy-dotnet)![Docker Image Version (latest by date)](https://img.shields.io/docker/v/pocki/scipy-dotnet) based on jupyter/scipy-notebook
* [r-dotnet](https://hub.docker.com/r/pocki/r-dotnet) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/pocki/r-dotnet) based on jupyter/r-notebook

### Usage: 
Like above but images are on Docker Hub: 
```
docker run -p 8888:8888 pocki/minimal-dotnet:latest
```

