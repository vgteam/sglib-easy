# libbdsg-easy

Easy installation for libbdsg

### Instructions

This repository coordinates the installation of [`libbdsg`](https://github.com/vgteam/libbdsg) along with its dependencies. Further documentation about `libbdsg` can be found in its repository. The following commands will build these repositories locally:

```
git clone --recursive https://github.com/vgteam/libbdsg-easy.git
cd libbdsg-easy
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
