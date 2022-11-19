# bupserver

## Introduction
You know [bup](https://github.com/bup/bup)? In case you want to host backups for different machines, you can either use a diferent repository or a different branch. However, if you want some level of isolation, you must run the servers in virtual machines or docker containers. I was looking for the latter and found that nobody did it, so here it is.

This image is based on `ubuntu`, which is uncool; turns out there's no `bup` package on the Alpine repositories. If someone (you) adds one that would be great!

## Tags
`jlxip/bupserver` follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html), so its tags are done accordingly:
- `latest`, `1`, `1.0`, `1.0.1`.
- `1.0.0`.

## Quick start
`jlxip/bupserver` is a container that runs two things: an SSH server (for making bup work), and `bup web`. You can disable the latter setting the environment variable `NO_WEB` to anything.

It exposes two ports: 22 for SSH, and 8080 for `bup web`.

It also needs two volumes:
- One for `/home/user/.bup`, which will keep the bup repository, owned by `user` (UID 1000)
- Another for `/etc/ssh`, which will keep the SSH server keys and configuration

Regarding SSH:
- The first time you run the container, the keys are destroyed and new ones are created
- The SSH configuration is made secure-by-default by copying the `sshd_config` from this repo
- `ssh-keygen` is ran for creating the `user`'s SSH key (ed25519, no passphrase). It is saved in `/etc/ssh/yourssh/key` so you can extract it from the container easily.

That's everything you need to know about the set up. When doing backups, remember to not set the remote repository location, since it's the default:
```bash
# bup index orders would be here
# ...
bup save -r mybupserver: -n main /
```

You also need, as with any other bup remote, to set `~/.ssh/config` on your machine to be able to authenticate through SSH.
