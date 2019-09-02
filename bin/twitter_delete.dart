import 'package:dotenv/dotenv.dart' show load, isEveryDefined, env;
import 'package:args/args.dart';
import 'package:twitter_delete/twitter_delete.dart';

const filePath = 'file-path';
const deleteBefore = 'delete-before';

Future<void> main(List<String> arguments) async {
  load();
  if (!isEveryDefined(
      ['api_key', 'api_secret', 'access_token', 'access_secret'])) {
    return print('Please set twitter api infomation.');
  }
  final parser = new ArgParser()
    ..addOption(filePath, abbr: 'f', valueHelp: 'file')
    ..addOption(deleteBefore, abbr: 'b', valueHelp: 'before');
  ArgResults argResults = parser.parse(arguments);
  if (argResults[deleteBefore] == null) {
    return print('Please set the period for deletion.');
  }
  TwitterDelete twitterDelete = new TwitterDelete(
      env['api_key'],
      env['api_secret'],
      env['access_token'],
      env['access_secret'],
      argResults[deleteBefore],
      argResults[filePath] ?? '');
  twitterDelete.delete();
}
