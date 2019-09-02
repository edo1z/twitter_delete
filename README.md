twitter_delete
==

You can delete Twitter tweets. You can also delete  past tweets by `tweet.js` too.
(`tweet.js` is a file included in Twitter Data that can be downloaded from the Twitter settings screen.)

## Install

```shell script
$ git clone git@github.com:edo1z/twitter_delete.git 
$ cd twitter_delete
$ pub get
$ cp .env.sample .env
$ vim .env
```
Enter your twitter api's consumer key, consumer secret, access token, and access token secret in the `.env` file.

## Usage

Executing the following command will delete all previous tweet data from May 1, 2019. However, data that can be deleted is limited to data that can be obtained from twitter api.

```shell script
$ dart bin/twitter_delete.dart -b 2019-05-01
```
When the following command is executed, all past tweet data from May 1, 2019 in `tweet.js` will be deleted.

```shell script
$ dart bin/twitter_delete.dart -f tweet.js -b 2019-05-01
```
#### Options

- The `-f` option specifies the file path of `tweet.js`. If this option is not specified, the latest tweet data is obtained from twitter api.
- The `-b` option specifies the date in the format `2019-01-01`. Delete all previous tweet data from this date. This option must be specified.

## Note

- If the operation stops, the API call limit may have been exceeded. Stop the program once and try again after a while.

## LICENSE

MIT
