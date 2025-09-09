import 'package:flutter/material.dart';
import 'package:ivf/Utils/app_data_helper.dart';
import 'package:ivf/Utils/app_colors.dart';

class AppAlertController {
  var _isLoaderShowing = false;
  static final AppAlertController _inst = AppAlertController._internal();

  AppAlertController._internal();

  factory AppAlertController() => _inst;
  BuildContext? _indicatorContext = AppDataHelper.rootContext;

  Future<void> showProgressIndicator({BuildContext? inContext}) async {
    if (_isLoaderShowing) return;
    _isLoaderShowing = true;

    print('Showing');

    _indicatorContext = inContext ?? AppDataHelper.rootContext;
    return showGeneralDialog<void>(
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 300),
        barrierColor: Colors.black54,
        context: inContext ?? AppDataHelper.rootContext!,
        pageBuilder: (context, animation, secondaryAnimation) {
          return loaderWidget(inContext: _indicatorContext!);
        },
        transitionBuilder: _transitionBuilder);
  }

  Widget loaderWidget({BuildContext? inContext}) {
    double loaderSize =
        MediaQuery.of(inContext ?? AppDataHelper.rootContext!).size.width * 0.2;
    var loader = SizedBox(
      width: loaderSize,
      height: loaderSize,
      child: CircularProgressIndicator(
        backgroundColor: AppColors.buttonColor,
        color: Colors.grey,
      ),
    );
    var loaderWithBG = Container(
      width: loaderSize * 2,
      height: loaderSize * 2,
      child: Center(
        child: loader,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
    return Container(
      child: Center(
        child: loaderWithBG,
      ),
    );
  }

  Widget _transitionBuilder(context, animation, secondaryAnimation, child) =>
      Transform.scale(
        scale: animation.value,
        child: Opacity(
          opacity: animation.value,
          child: child,
        ),
      );

  void hideProgressIndicator(){
    if(!_isLoaderShowing) return;
    Navigator.pop(_indicatorContext!);
    _isLoaderShowing=false;
  }
  void showAlert(
      {String title = '',
        required String message,
        String? cancelTitle,
        String? otherTitle,
        VoidCallback? otherAction,
        required BuildContext? inContext}) async {
    hideProgressIndicator();

    var alertTitle = Center(
      child: Text(
          title,
          style:TextStyle(
            // fontFamily: AppThemeManager.defaultNunitoLight
          )
      ),
    );

    var alertContent = SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Center(
            child: Text(
                message.startsWith('Exception:')
                    ? message.toString().split('Exception:')[1] : message,
                style: TextStyle(
                  // fontFamily: AppThemeManager.defaultNunitoLight
                )
            ),
          ),
        ],
      ),
    );

    List<Widget> alertButtons = [];
    var cancelButton = TextButton(
      child: Text(cancelTitle ?? 'OK',
          style: TextStyle(
            // fontFamily: AppThemeManager.defaultNunitoLight
          )
      ),
      onPressed: () {
        //otherAction;
        Navigator.of(inContext!,rootNavigator: true).pop('dialog');

      },
    );

    alertButtons.add(cancelButton);

    if (otherTitle != null) {
      var otherButton = TextButton(
        child: Text(otherTitle,
            style: TextStyle(
              // / fontFamily: AppThemeManager.defaultNunitoLight
            )),
        onPressed: () {
          if (otherAction != null) {
            otherAction();
          }
        },
      );

      alertButtons.add(otherButton);
    }

    var alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: alertTitle,
      content: alertContent,
      actions: alertButtons,
    );

    return showGeneralDialog<void>(
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      context: inContext!,
      pageBuilder: (context, animation, secondaryAnimation) => alert,
    );
  }
}
