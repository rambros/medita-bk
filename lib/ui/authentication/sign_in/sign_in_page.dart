import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/sign_in_view_model.dart';
import 'package:medita_bk/ui/authentication/sign_up/sign_up_page.dart';
import 'package:medita_bk/ui/authentication/forgot_password/forgot_password_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static String routeName = 'signIn';
  static String routePath = 'signIn';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  bool _passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignInViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                leading: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pop();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
                actions: const [],
                centerTitle: false,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 570.0,
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem-vindo de volta!',
                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).displaySmallIsCustom,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                            child: Text(
                              'Utilize o formulário abaixo para acessar sua conta.',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _emailController,
                                          focusNode: _emailFocusNode,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email ',
                                            labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                            hintText: 'Entre com seu email aqui...',
                                            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).error,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).error,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            filled: true,
                                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                            contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 0.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                              ),
                                          keyboardType: TextInputType.emailAddress,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          obscureText: !_passwordVisibility,
                                          decoration: InputDecoration(
                                            labelText: 'Senha',
                                            labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                            hintText: 'Entre com sua senha',
                                            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).error,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).error,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                            filled: true,
                                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                            contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 24.0, 24.0),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => _passwordVisibility = !_passwordVisibility,
                                              ),
                                              focusNode: FocusNode(skipTraversal: true),
                                              child: Icon(
                                                _passwordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 22.0,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 24.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(ForgotPasswordPage.routeName);
                                        },
                                        child: Text(
                                          'Esqueceu a senha?',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      await viewModel.signInWithEmail(
                                        context,
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    },
                                    text: 'Login',
                                    options: FFButtonOptions(
                                      width: MediaQuery.sizeOf(context).width * 0.85,
                                      height: 50.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                            color: FlutterFlowTheme.of(context).info,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                          ),
                                      elevation: 2.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                      hoverColor: FlutterFlowTheme.of(context).primary,
                                      hoverBorderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 1.0,
                                      ),
                                      hoverTextColor: FlutterFlowTheme.of(context).info,
                                    ),
                                    showLoadingIndicator: viewModel.isLoading,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 24.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await viewModel.signInAnonymously(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continuar como convidado',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 24.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(SignUpPage.routeName);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                    child: Text(
                                      'Ainda não tem uma conta?',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 0.0, 8.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(SignUpPage.routeName);
                                      },
                                      child: Text(
                                        'Cadastrar',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
