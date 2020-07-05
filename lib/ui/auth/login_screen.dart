import 'package:agent/constants/colors.dart';
import 'package:agent/constants/styles.dart';
import 'package:agent/localization/trans.dart';
import 'package:agent/providers/auth.dart';
import 'package:agent/providers/counter.dart';
import 'package:agent/widgets/text_form_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
 const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isButtonEnabled = true;
  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'username',
    'password',
  ];
  Map<String, String> validationMap =
      Map<String, String>.fromIterables(keys, validators);

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actionsOverflowButtonSpacing: 50,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  bool _obscureText = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  Widget customcard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Form(
        key: _formKey,
        onWillPop: () {
          return _onWillPop();
        },
        child: Column(
          children: <Widget>[
            TextFormInput(
                text: trans(context, 'username'),
                cController: usernameController,
                prefixIcon: Icons.person_outline,
                kt: TextInputType.emailAddress,
                obscureText: false,
                readOnly: false,
                onTab: () {},
                nextfocusNode: focus1,
                onFieldSubmitted: () {
                  focus1.requestFocus();
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return trans(context, 'plz_enter_username');
                  }
                  return validationMap['username'];
                }),
            const SizedBox(height: 32),
            TextFormInput(
                text: trans(context, 'pin_code'),
                cController: passwordController,
                prefixIcon: Icons.lock_outline,
                kt: TextInputType.number,
                readOnly: false,
                onTab: () {},
                suffixicon: IconButton(
                  icon: Icon(
                    (_obscureText == false)
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                onFieldSubmitted: () {
                  focus2.requestFocus();
                },
                obscureText: _obscureText,
                focusNode: focus1,
                validator: (String value) {
                  if (value.isEmpty) {
                    return trans(context, 'plz_enter_pass');
                  }
                  return validationMap['password'];
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);

    final MyCounter bolc = Provider.of<MyCounter>(context);
    return Scaffold(
        backgroundColor: Colors.blue,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/images/welcomeback.svg',
                          width: 120.0,
                          height: 120.0,
                        ),
                        const SizedBox(height: 32),
                        Text(trans(context, 'welcome_back'),
                            textAlign: TextAlign.center,
                            style: styles.mystyle2),
                        customcard(context),
                        const SizedBox(height: 48),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: colors.myBlue)),
                              onPressed: () async {
                                if (_isButtonEnabled) {
                                  if (_formKey.currentState.validate()) {
                                    bolc.togelf(true);
                                    setState(() {
                                      _isButtonEnabled = false;
                                    });
                                    await auth
                                        .login(usernameController.text,
                                            passwordController.text, context)
                                        .then((dynamic value) {
                                      if (value != null) {
                                        value.forEach((String k, dynamic vv) {
                                          setState(() {
                                            validationMap[k] = vv[0].toString();
                                          });
                                        });
                                        _formKey.currentState.validate();
                                        validationMap.updateAll(
                                            (String key, String value) {
                                          return null;
                                        });
                                      }
                                    });
                                    setState(() {
                                      _isButtonEnabled = true;
                                    });
                                    bolc.togelf(false);
                                  }
                                }
                              },
                              color: colors.blue,
                              textColor: Colors.white,
                              child: bolc.returnchild(trans(context, 'login'))),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/images/company_logo.svg',
                        width: 120.0,
                        height: 120.0,
                      ),
                      const SizedBox(height: 96),
                      SvgPicture.asset(
                        'assets/images/mainLogo.svg',
                        width: 320.0,
                        height: 320.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
