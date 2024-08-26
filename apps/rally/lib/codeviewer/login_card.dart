import 'package:animated/animated.dart';
import 'package:email_validator/email_validator.dart';
import 'package:environment/environment.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localization/localization.dart';
import 'package:novade_lite/shared/services/login/login.dart';
import 'package:novade_lite/shared/services/login/login.json.dart';
import 'package:novade_lite/shared/services/login/login_exceptions.dart';
import 'package:novade_lite/shared/utils/urls/novade_marketing_url.dart';
import 'package:novade_lite/shared/widgets/action_button/action_button.dart';
import 'package:novade_lite/shared/widgets/beta_widget.dart';
import 'package:novade_lite/shared/widgets/env_toggle.dart';
import 'package:novade_lite/shared/widgets/error/error_label.dart';
import 'package:novade_lite/shared/widgets/form_field/nvd_text_form_field.dart';
import 'package:novade_lite/shared/widgets/novade_constants.dart';
import 'package:novade_lite/shared/widgets/sign_up/email_resent_message.dart';
import 'package:novade_lite/web/router/routes/public_routes.dart';
import 'package:novade_lite/web/screens/login/widgets/join_existing_workspace_dialog.dart';
import 'package:novade_lite/web/screens/login/widgets/qr_login_card.dart';
import 'package:novade_lite/web/screens/login/widgets/too_many_devices_dialog.dart';
import 'package:novade_lite/web/services/login/handle_login_response.dart';
import 'package:novade_lite/web/services/utils.dart';
import 'package:novade_lite/web/widgets/form_field/password_field.dart';
import 'package:novade_lite/web/widgets/or_divider/or_divider.dart';
import 'package:novade_lite/web/widgets/workspaces/marketing_and_policy_footer.dart';
import 'package:product_analytics/product_analytics.dart';
import 'package:shared_bindings/shared_bindings.dart';
import 'package:text_keys_shared/text_keys_shared.dart';
import 'package:theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Login / reset password card.
class LoginCard extends StatefulWidget {
  /// Login / reset password card.
  const LoginCard({Key? key}) : super(key: key);

  /// Max Width of both the login via password widget and the login via QR code
  /// widget.
  static const double maxWidth = 325.0;

  /// Height of the OR divider.
  static const dividerHeight = 90.0;

  /// Padding of the Login Card.
  static const padding = 48.0;

  @override
  State<LoginCard> createState() => _LoginCardState();
}

const _pageTransitionDuration = Duration(milliseconds: 300);

class _LoginCardState extends State<LoginCard> {
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pageController = PageController();
  var isDisabled = true;
  String error = '';
  bool isEmailResent = false;

  @override
  void initState() {
    super.initState();
    emailCtrl.addListener(updateIsDisabled);
    pwdCtrl.addListener(updateIsDisabled);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          if (!kIsProd)
            const Center(
              child: BetaWidget(
                child: Padding(
                  padding: EdgeInsets.all(NovadeTheme.padding_medium),
                  child: EnvToggle(),
                ),
              ),
            ),
          Center(
            child: InkWell(
              onTap: () {
                ProductAnalytics().logEvent(
                  eventType: ProductAnalyticsEventType(
                    ProductAnalyticsEventTypes.marketingSiteClickLink,
                    properties: MarketingWebsitePageProperties(
                      page: MarketingPageScreen.login.name,
                      buttonLink: MarketingPageOpenButton.logo.name,
                    ).toJson(),
                  ),
                );
                launchUrl(Uri.parse(novadeMarketingUrl));
              },
              child: SvgPicture.asset(
                'assets/images/login_logo.svg',
                height: LoginCard.padding,
              ),
            ),
          ),
          const SizedBox(height: NovadeTheme.padding_large),
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(LoginCard.padding),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: LoginCard.maxWidth),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ExpandablePageView(
                                // To prevent the user from dragging.
                                physics: const NeverScrollableScrollPhysics(),
                                controller: pageController,
                                onPageChanged: (_) {
                                  // Clear the error message.
                                  setState(() {
                                    error = '';
                                  });
                                },
                                children: [
                                  _LoginForm(
                                    emailCtrl: emailCtrl,
                                    passwordCtrl: pwdCtrl,
                                    isDisabled: isDisabled,
                                    onError: (message) {
                                      setState(() {
                                        error = message;
                                      });
                                    },
                                    onForgotPassword: () => goToPage(1),
                                  ),
                                  ForgotPassword(
                                    emailCtrl: emailCtrl,
                                    onBackToLogin: () {
                                      goToPage(0);
                                      setState(() {
                                        isEmailResent =
                                            false; // Remove the 'Email has been resent' popup message.
                                      });
                                    },
                                    onEmailResent: () => setState(() {
                                      isEmailResent = true;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const OrDivider(height: LoginCard.dividerHeight),
                    const Padding(
                      padding: EdgeInsets.all(LoginCard.padding),
                      child: QRLoginCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: NovadeTheme.padding_large),
          const MarketingAndPolicyFooter(
            page: MarketingPageScreen.login,
          ),
          const SizedBox(height: NovadeTheme.padding_medium),
          AnimatedVisibility(
            visible: isEmailResent,
            child: const Center(child: EmailResentMessage()),
          ),
          const SizedBox(height: NovadeTheme.padding_extraLarge),
          Center(
            child: ErrorLabel(
              error: error,
            ),
          ),
        ],
      ),
    );
  }

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: _pageTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  void updateIsDisabled() {
    final newIsDisabled = emailCtrl.text.isEmpty ||
        !EmailValidator.validate(emailCtrl.text) ||
        pwdCtrl.text.isEmpty;
    if (newIsDisabled != isDisabled) {
      setState(() {
        isDisabled = newIsDisabled;
      });
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    pwdCtrl.dispose();
    super.dispose();
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.isDisabled,
    required this.onError,
    required this.onForgotPassword,
    Key? key,
  }) : super(key: key);
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool isDisabled;
  final VoidCallback onForgotPassword;
  final void Function(String message) onError;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  void initState() {
    super.initState();
    ProductAnalytics().logEvent(
      eventType: const ProductAnalyticsEventType(
          ProductAnalyticsEventTypes.loginScreenView),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: FocusTraversalGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(TextKeys.login_via_password.translate(),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
                height: NovadeTheme
                    .padding_extraLarge), // We add the padding inside the column to avoid the following field label to be cut.
            TextFormField(
              autofocus: true,
              decoration:
                  InputDecoration(label: Text(TextKeys.email.translate())),
              controller: widget.emailCtrl,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: NovadeTheme.padding_small),
            PasswordField(
              label: TextKeys.password.translate(),
              controller: widget.passwordCtrl,
              onFieldSubmitted: (_) => onLogin(context),
              autofillHint: true,
            ),
            const SizedBox(height: NovadeTheme.padding_medium),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  ProductAnalytics().logEvent(
                      eventType: const ProductAnalyticsEventType(
                          ProductAnalyticsEventTypes.forgotPasswordClick));
                  return widget.onForgotPassword();
                },
                child: Text(TextKeys.forgot_password.translate()),
              ),
            ),
            const SizedBox(height: NovadeTheme.padding_medium),
            ActionButton(
              label: TextKeys.workspace.login.translate(),
              onPressed: widget.isDisabled ? null : () => onLogin(context),
            ),
            const SizedBox(height: NovadeTheme.padding_medium),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      TextKeys.workspace.no_workspace.translate(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color:
                                GlobalTheme.watch(context).textEmphasis.medium,
                          ),
                    ),
                  ),
                  const SizedBox(width: NovadeTheme.padding_extraSmall),
                  TextButton(
                    onPressed: () {
                      ProductAnalytics().logEvent(
                        eventType: const ProductAnalyticsEventType(
                            ProductAnalyticsEventTypes.loginPageSignUpClick),
                      );
                      RouterBinding.instance.go(const SignUpRoute().location);
                    },
                    child: Text(TextKeys.create.translate()),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    TextKeys.workspace.invited_to_a_workspace.translate(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: GlobalTheme.watch(context).textEmphasis.medium,
                        ),
                  ),
                ),
                const SizedBox(width: NovadeTheme.padding_extraSmall),
                TextButton(
                  onPressed: () async {
                    ProductAnalytics().logEvent(
                      eventType: ProductAnalyticsEventType(
                        ProductAnalyticsEventTypes
                            .joinExistingWorkspaceLearnMore,
                        properties:
                            const JoinExistingWorkspaceLearnMoreProperties(
                          locationType: LocationType.loginPage,
                        ).toJson(),
                      ),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => const JoinExistingWorkspaceDialog(),
                    );
                  },
                  child: Text(TextKeys.learn_more.translate()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onLogin(BuildContext context) async {
    final urlProvider = ApiUrlBinding.instance;
    final urls = EnvBinding.instance.value.urls;
    final email = widget.emailCtrl.text.trim();
    final password = widget.passwordCtrl.text.trim();
    final credentials = Credentials(email: email, password: password);
    final deviceInformation = await getDeviceInformation();
    try {
      final res = await login(urls,
          credentials: credentials, deviceInformation: deviceInformation);
      urlProvider.url = res.url;
      await handleLoginResponse(url: res.url, data: res.body, email: email);
    } on ForbiddenException {
      return widget.onError(TextKeys.contact_admin.translate());
    } on TooManyLinkedDevicesException {
      ProductAnalytics().logEvent(
          eventType: const ProductAnalyticsEventType(
              ProductAnalyticsEventTypes.loginBlocker));
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (_) => const TooManyLinkedDevicesDialog(),
        );
      }
    } on InvalidCredentialsException {
      return widget.onError(TextKeys.invalid_credentials.translate());
    } catch (e) {
      return widget.onError(TextKeys.workspace.server_error.translate());
    }
  }
}

/// Forgot password page.
@visibleForTesting
class ForgotPassword extends StatefulWidget {
  /// Forgot password page.
  const ForgotPassword({
    required this.emailCtrl,
    required this.onBackToLogin,
    required this.onEmailResent,
    Key? key,
  }) : super(key: key);

  /// Controller of the email text field.
  final TextEditingController emailCtrl;

  /// Callback redirecting to the login page.
  final VoidCallback onBackToLogin;

  /// Callback when the password has been resent.
  final VoidCallback onEmailResent;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
            height: NovadeTheme
                .padding_extraLarge), // We add the padding inside the column to avoid the following field label to be cut.
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: NovadeTheme.padding_large),
            child: AnimatedCrossFade(
              alignment: Alignment.center,
              firstChild: _ForgotPasswordForm(
                emailCtrl: widget.emailCtrl,
                onRequestNewPassword: () {
                  setState(() {
                    isSubmitted = true;
                  });
                  final urls = EnvBinding.instance.value.urls;
                  forgotPassword(urls, widget.emailCtrl.text.trim());
                },
              ),
              secondChild: _PasswordRequestSent(
                emailCtrl: widget.emailCtrl,
                onEmailResent: widget.onEmailResent,
              ),
              crossFadeState: isSubmitted
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeIn,
              secondCurve: Curves.easeIn,
              layoutBuilder:
                  (topChild, topChildKey, bottomChild, bottomChildKey) {
                // This prevents jumping because of the difference in size.
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(key: bottomChildKey, child: bottomChild),
                    Positioned(key: topChildKey, child: topChild),
                  ],
                );
              },
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onBackToLogin();
            // Reset the state after going back to login form.
            Future.delayed(_pageTransitionDuration, () {
              setState(() {
                isSubmitted = false;
              });
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: GlobalTheme.read(context).textEmphasis.low,
            backgroundColor: theme.canvasColor,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(NovadeTheme.padding_medium),
            child: Text(
              TextKeys.back_to_login.translate(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm({
    required this.emailCtrl,
    required this.onRequestNewPassword,
    Key? key,
  }) : super(key: key);
  final TextEditingController emailCtrl;
  final VoidCallback onRequestNewPassword;

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  late bool isDisabled;

  @override
  void initState() {
    super.initState();
    isDisabled = !EmailValidator.validate(widget.emailCtrl.text);
    widget.emailCtrl.addListener(onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          TextKeys.forgot_password.translate(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: NovadeTheme.padding_small),
        Text(
          TextKeys.forgot_password_description.translate(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GlobalTheme.watch(context).textEmphasis.low,
          ),
        ),
        const SizedBox(height: NovadeTheme.padding_medium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: NvdTextFormField(
            focusOnInit: true,
            label: TextKeys.email.translate(),
            controller: widget.emailCtrl,
            maxLength: Constants.emailLength,
          ),
        ),
        const SizedBox(height: NovadeTheme.padding_medium),
        ActionButton(
          label: TextKeys.submit.translate().toUpperCase(),
          onPressed: isDisabled ? null : widget.onRequestNewPassword,
        ),
        const SizedBox(height: NovadeTheme.padding_large),
      ],
    );
  }

  void onEmailChanged() {
    // Checks if the entered email is valid.
    final newIsDisabled = !EmailValidator.validate(widget.emailCtrl.text);
    if (newIsDisabled != isDisabled) {
      setState(() {
        isDisabled = newIsDisabled;
      });
    }
  }

  @override
  void dispose() {
    widget.emailCtrl.removeListener(onEmailChanged);
    super.dispose();
  }
}

class _PasswordRequestSent extends StatelessWidget {
  const _PasswordRequestSent(
      {required this.emailCtrl, required this.onEmailResent, Key? key})
      : super(key: key);

  final TextEditingController emailCtrl;

  final VoidCallback onEmailResent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorPalette = GlobalTheme.watch(context);
    return Column(
      children: [
        Text(
          TextKeys.forgot_password_sent.translate(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: NovadeTheme.padding_large),
        RichText(
          text: TextSpan(
            text: TextKeys.did_not_receive_email.translate(),
            style: TextStyle(color: colorPalette.textEmphasis.low),
            children: [
              TextSpan(
                text: TextKeys.resend.translate(),
                style: theme.textTheme.labelLarge,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ProductAnalytics().logEvent(
                        eventType: const ProductAnalyticsEventType(
                            ProductAnalyticsEventTypes
                                .forgotPasswordResendLink));
                    forgotPassword(
                        EnvBinding.instance.value.urls, emailCtrl.text);
                    onEmailResent();
                  },
                mouseCursor: SystemMouseCursors.click,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
