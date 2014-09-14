Docker Rbenv with Debian
====

## Setup

### Build rbenv Debian image

```bash
$ docker build -t rds13/debian-rbenv .
```

Run

```bash
$ docker run -t -i rds13/debian-rbenv /bin/bash -l
```

## Configure ruby versions

Install multiple versions of ruby by [rbenv](https://github.com/sstephenson/rbenv). 
You can define ruby version which you want to use in `versions.txt`.

## Reference

- Based on work from [Taichi Nakashima] (see http://github.com/tcnksm/docker-rbenv).

