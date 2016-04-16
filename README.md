This a sub-repo of [Neard project](https://github.com/crazy-max/neard) involving Composer tool bundles.

## Installation

* Download and install [Neard](https://github.com/crazy-max/neard).
* If you already have installed Neard, stop it.
* Download [a Composer bundle](#download).
* Extract archive in `neard\tools\composer\`. Directory structure example :

```
[-] neard
 | [-] tools
 |  | [-] composer 
 |  |  | [-] composer1.0-dev-edf14da
 |  |     | neard.conf
 |  |  | [-] composer1.0.0
 |  |     | neard.conf
```

* Edit the `neard.conf` file and replace the key `composerVersion` with the correct version.
* Start Neard.

## Download

![](https://raw.github.com/crazy-max/neard-tool-composer/master/img/star-20160403.png) : Default bundle on Neard.

|                              | Composer release date | Neard release | Download |
| -----------------------------|:---------------------:|:-------------:|:--------:|
| **Composer 1.0-dev-edf14da** ![](https://raw.github.com/crazy-max/neard-tool-composer/master/img/star-20160403.png) | 2015/10/01 | [r1](https://github.com/crazy-max/neard-tool-composer/releases/tag/r1) | [neard-composer-1.0-dev-edf14da-r1.zip](https://github.com/crazy-max/neard-tool-composer/releases/download/r1/neard-composer-1.0-dev-edf14da-r1.zip) |
| **Composer 1.0.0** | 2016/04/05 | [r1](https://github.com/crazy-max/neard-tool-composer/releases/tag/r1) | [neard-composer-1.0.0-r1.zip](https://github.com/crazy-max/neard-tool-composer/releases/download/r1/neard-composer-1.0.0-r1.zip) |

## Sources

* https://getcomposer.org
* http://github.com/composer/composer

## Contribute

If you want to contribute to this bundle and create new bundles, you have to download [neard-dev](https://github.com/crazy-max/neard-dev) in the parent folder of the bundle.
Directory structure example :

```
[-] neard-dev
 | [-] build
 |  |  | build-commons.xml 
[-] neard-tool-composer
 |  | build.xml
```

To create a new bundle :
* Do not forget to increment the `build.release` in the `build.properties` file.
* If you want you can change the `build.path` (default `C:\neard-build`).
* Open a command prompt in your bundle folder and call the Ant target `release` : `ant release`.
* Upload your release on a file hosting system like [Sendspace](https://www.sendspace.com/).
* Create an [issue on Neard repository](https://github.com/crazy-max/neard/issues) to integrate your release.

## Issues

Issues must be reported on [Neard repository](https://github.com/crazy-max/neard/issues).<br />
Please read [Found a bug?](https://github.com/crazy-max/neard#found-a-bug) section before reporting an issue.
