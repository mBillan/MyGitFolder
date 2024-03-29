library flutx;

import 'core/logs/log.dart';
import 'themes/app_theme_notifier.dart';


export 'widgets/widgets.dart';
export 'utils/utils.dart';
export 'core/state_management/state_management.dart';
export 'core/routes/routes.dart';
export 'styles/styles.dart';
export  'themes/themes.dart';
export 'icons/two_tone/two_tone_icon.dart';
export 'extensions/extensions.dart';


class FlutX {

  // entry point of the package
  init(){
    FxAppThemeNotifier().init();
  }

  static enableLog(){
    FxLog.enable();
  }

  static disableLog(){
    FxLog.disable();
  }

}
