import 'dart:convert';
import 'dart:io';
import 'package:twitter_1user/twitter_1user.dart';
import 'package:intl/intl.dart';

class TwitterDelete extends Twitter {
  final String deleteBefore;
  final String filePath;
  int oldestId = 0;
  int deletedCount = 0;

  TwitterDelete(String api_key, String api_secret, String access_token,
      String access_secret,
      [this.deleteBefore = '', this.filePath = ''])
      : super(api_key, api_secret, access_token, access_secret);

  Future<void> delete() async {
    if (filePath != '') {
      await _deleteFromFile();
    } else {
      await _deleteFromStatuses();
    }
    print("$deletedCount items have been deleted.");
  }

  Future<void> _deleteFromStatuses() async {
    while (true) {
      List tweets = jsonDecode(await getTweets());
      if (tweets.length <= 0) break;
      for (var tweet in tweets) await _delete(tweet);
      oldestId = tweets[tweets.length - 1]['id'];
    }
  }

  Future<void> _deleteFromFile() async {
    String tweetJs = await new File(filePath).readAsString();
    List tweets = jsonDecode(_tweetJsToJson(tweetJs));
    for (var tweet in tweets) await _delete(tweet);
  }

  Future<void> _delete(Map<String, dynamic> tweet) async {
    DateTime datetime = _dateParse(tweet['created_at']);
    if (DateTime.parse(deleteBefore).isBefore(datetime)) return;
    await deleteTweet(tweet['id'].toString());
    deletedCount++;
    String text = tweet['text'] != null ? tweet['text'] : tweet['full_text'];
    print("DELETED! [${tweet['id']}] $datetime $text");
  }

  DateTime _dateParse(String created_at) {
    var dateParts = created_at.split(' ');
    dateParts.removeAt(4);
    var dateFormat = DateFormat('EEE MMM dd HH:mm:ss yyyy');
    return dateFormat.parse(dateParts.join(' '));
  }

  Future<String> getTweets() async {
    Map<String, String> options = {
      'count': '200',
      'include_rts': '1',
      'trim_user': '1'
    };
    if (oldestId > 0) {
      oldestId--;
      options['max_id'] = oldestId.toString();
    }
    return await this.request('GET', 'statuses/user_timeline.json', options);
  }

  Future<String> deleteTweet(String id) async {
    Map<String, String> options = {'trim_user': '1', 'id': id};
    String path = "statuses/destroy/$id.json";
    return await this.request('POST', path, options);
  }

  String _tweetJsToJson(String tweets) {
    return tweets.replaceFirstMapped('window.YTD.tweet.part0 = ', (m) => '');
  }
}
