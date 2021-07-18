waterdoc
========

This `bash` script is intended to add a watermark on identity documents before being
sent to third parties.

The aim of this watermark is to reduce the risk of identity theft.


Usage
-----

Usage example:

```
./waterdoc.sh ./data/myid.png "THE INTERNETS"
```

This will convert the following image:

![Source ID image](data/myid.jpg)

into this watermarked one:

![Watermarked ID image](data/myid-watermark.jpg)


Dependencies
------------

This script depends on *[ImageMagick](https://imagemagick.org/)*'s `convert` and `composite`.

To install *ImageMagick* on a *Debian* based *Linux* machine, including *Ubuntu*, type:

```
sudo apt --yes install imagemagick
```
