# Top-Secret Archiver
**Archiver of your top-secret files.** Written in Bash script.

In fact, the script simply [archives](#Compression-parameters) specified directory using 7-zip (not recursively). Password for archive is set by user during script runtime.
## Requires
* [7-zip](https://www.7-zip.org/) in [%PATH% or $PATH](https://en.wikipedia.org/wiki/PATH_(variable))
## Compression parameters
7z a -t7z *`generated filename`* *`<directory>`* *`-p option if password is set`* -mhe -mx=3 -ms=off
