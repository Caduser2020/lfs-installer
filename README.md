# lfs-wget-list
List of required packages for Linux from scratch;

## How to use:
Download the 'wget-list.txt' file onto the machine that you are installing Linux from scratch on. Then, run the command below to download all the sources.
```
wget -i wget-list -P $LFS sources'
```
## FAQ
Why are some of the urls not working? Some of the urls change with LFS versions or the site administrators of the download
location remove older versions when new ones are released, espcially File (5.36). In that case, open an issue to let me know and check for an updated url at [LFS Downloads](http://www.linuxfromscratch.org/lfs/download.html#ftp).
