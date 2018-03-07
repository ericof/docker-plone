# Plone (pip based)

[Plone](https://plone.org) is a free and open source content management system built on top of the Zope application server.

A Docker image using a pip installation of Plone. Inspired by [Plone-pip](https://github.com/datakurre/plone-pip)


## Features

- Images for Plone 5.1.
- Installed with pip, not unified installer.

### Supported tags and respective `Dockerfile` links

- [`5.1.0`, `latest` (*5.1.0/Dockerfile*)](https://github.com/plone/plone.docker/blob/master/Dockerfile)


## Prerequisites

Make sure you have Docker installed and running for your platform. You can download Docker from https://www.docker.com.

## Usage


### Standalone Plone Instance

Plone standalone instances are best suited for testing Plone and development.

Download and start the latest Plone 5 container, based on [Debian](https://www.debian.org/).

```console
docker run -p 8080:8080 ericof/plone:latest
```

This image includes `EXPOSE 8080` (the Plone port), so standard container linking will make it automatically available to the linked containers. Now you can add a Plone Site at http://localhost:8080 - default Zope user and password are **`admin/admin`**.

### Extending from this image

In a folder, create a Dockerfile, i.e.:

```
FROM ericof/plone:5.1.0

COPY requirements.txt requirements.txt
RUN ./bin/pip install -r requirements.txt

```

Also add a requirements.txt file, with additional packages

```
plone.restapi
plone.tiles>=1.8.3
plone.subrequest>=1.8.1
plone.app.tiles>=3.0.3
plone.app.standardtiles>=2.2.0
plone.app.blocks>=4.1.1
plone.app.drafts>=1.1.2
plone.app.mosaic>=2.0rc8
plone.formwidget.multifile>=2.0
plone.jsonserializer>=0.9.5

```

Build your new image

```console
docker build -t site .
```

And start the container

```console
docker run -d -p 8080:8080 -e ADMIN_USER=admin -e ADMIN_PASSWD=foo site
```

## Environment variables

* `ADMIN_USER`: Username for the main account. Default: admin
* `ADMIN_PASSWD`: Password for the main account. Default: admin


## Default configuration

This image packages a zope.conf file, located at /plone/etc/zope.conf.

```
clienthome $(PWD)
debug-mode off
default-zpublisher-encoding utf-8
enable-product-installation off
http-header-max-length 8192
instancehome $(PWD)
lock-filename $(PWD)/instance1.lock
pid-filename $(PWD)/instance1.pid
python-check-interval 1000
security-policy-implementation C
verbose-security off
zserver-threads 2

<environment>
  Z3C_AUTOINCLUDE_DEPENDENCIES_DISABLED on
</environment>

<eventlog>
  level INFO

  <logfile>
    level INFO
    path $(PWD)/logs/instance1.log
  </logfile>
</eventlog>

<http-server>
  address 8080
</http-server>

<logger access>
  level WARN

  <logfile>
    format %(message)s
    path $(PWD)/logs/instance1-Z2.log
  </logfile>
</logger>

<warnfilter>
  action ignore
  category exceptions.DeprecationWarning
</warnfilter>

<zodb_db main>
  cache-size 40000
  mount-point /

  <blobstorage>
    blob-dir /data/blobstorage

    <filestorage>
      path /data/Data.fs
    </filestorage>
  </blobstorage>
</zodb_db>

<zodb_db temporary>
  container-class Products.TemporaryFolder.TemporaryContainer
  mount-point /temp_folder

  <temporarystorage>
    name temporary storage for sessioning
  </temporarystorage>
</zodb_db>

```

To override this, add a file named zope.conf to your local folder, change the Dockerfile to copy it over the default config

```
FROM ericof/plone:5.1.0

COPY zope.conf /plone/etc/zope.conf
COPY requirements.txt requirements.txt
RUN ./bin/pip install -r requirements.txt

```

And rebuild your image.

## License

The project is licensed under the GPLv2.
