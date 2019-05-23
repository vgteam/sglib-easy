# sglib-easy
Easy installation for sglib

### Instructions

This repository coordinates the installation of [`sglib`](https://github.com/vgteam/sglib) along with its dependencies. The following commands will build these repositories locally:

```
git clone --recursive https://github.com/vgteam/sglib-easy.git
cd sglib-easy
make -j8
```

To install the libraries systemwide (in `/usr/local/`):

```
make install
```

Or to install the libraries in another location:

```
INSTALL_PREFIX=/somewhere/else/ make install
```