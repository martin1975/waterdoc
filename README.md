waterdoc
========

This `bash` script is intended to add a watermark on identity documents before being
sent to third parties.

The aim of this watermark is to prevent identity theft.

Usage example:

```
./waterdoc.sh ./data/myid.png "THE INTERNETS"
```

This will convert the following image:

[Source ID image](data/myid.jpg)

to this watermarked one:

[Watermarked ID image](data/myid-watermark.jpg)
