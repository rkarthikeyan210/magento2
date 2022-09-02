# Setup local environment
## Pre-requisites
1. Download the latest docker version from https://www.docker.com/
2. Add 127.0.0.1 magento2-incomm.local to hosts
3.  Install mutagen using the following command (only for Mac)
```sh
$ brew install havoc-io/mutagen/mutagen
```
If you want that mutagen automatically starts with your system:
```sh
$ mutagen daemon register
```
You can also start it manually:
```sh
$ mutagen daemon start
```

## Installation steps
1. Create a folder to clone base (magento core) and multitenant repos (the folder name doesn't matter):
```sh
$ mkdir magento2-multitenant
```
2. Proceed to the created folder:
```sh
$ cd magento2-multitenant
```
3. Clone the above mentioned repositories (don't forget to switch the branch):
```sh
$ git clone --config core.autocrlf=false git@github.com:InComm-Software-Development/digex-caas-magento-base.git magento-enterprise
$ git clone --config core.autocrlf=false git@github.com:InComm-Software-Development/digex-caas-magevanilla.git
```
4. Don't forget to change folder ownership if required: (Mac and Linux)
```sh
$ sudo chown -R <your_user>:<your_user_group> path_to_magento2_amex_folder/magento-enterprise
$ sudo chown -R <your_user>:<your_user_group> path_to_magento2_amex_folder/digex-caas-magevanilla
```
4. Copy Magento core files from magento-enterprise folder to digex-caas-magevanilla/docker/build/php/magento2 (only Windows)
5. Go to the docker folder under the digex-caas-magevanilla folder:
```sh
$ cd digex-caas-magevanilla/docker
```
6. Run the build command:
```sh
$ ./docker-build.sh
```
7. Copy the databases into the MySQL container and restore them. DB names should be: magento, magento_quote and magento_sales
8. To stop the project use the following command:
```sh
$ ./docker-stop.sh
```
9. To start the project use the following command:
```sh
$ ./docker-run.sh
```
10. Add `127.0.0.1 magento2-incomm.local` to hosts
11. Open `http://magento2-incomm.local/` in browser
