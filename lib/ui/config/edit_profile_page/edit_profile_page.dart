import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_bk/ui/pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'view_model/edit_profile_view_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  static String routeName = 'editProfilePage';
  static String routePath = 'editProfile';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EditProfileViewModel>().init();
      }
    });
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'editProfilePage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).info,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                title: Text(
                  'Editar seus dados',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                      ),
                ),
                actions: const [],
                centerTitle: true,
                elevation: 2.0,
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
                    alignment: const AlignmentDirectional(0.0, -1.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 0.32,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 150.0,
                                      height: 150.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Builder(builder: (context) {
                                          final photoUrl = viewModel.photoToDisplay;
                                          final parsed = Uri.tryParse(photoUrl);
                                          final hasImage =
                                              parsed != null && parsed.hasScheme && parsed.host.isNotEmpty;
                                          if (!hasImage) {
                                            return const _EditAvatarPlaceholder(size: 150.0);
                                          }
                                          return Container(
                                            width: 150.0,
                                            height: 150.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: CachedNetworkImage(
                                              fadeInDuration: const Duration(milliseconds: 500),
                                              fadeOutDuration: const Duration(milliseconds: 500),
                                              imageUrl: photoUrl,
                                              fit: BoxFit.cover,
                                              errorWidget: (_, __, ___) =>
                                                  const _EditAvatarPlaceholder(size: 150.0),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          await viewModel.uploadImage(context);
                                        },
                                        text: 'Mudar Imagem',
                                        options: FFButtonOptions(
                                          width: 180.0,
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
                                        showLoadingIndicator: viewModel.isUploading,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 8.0),
                                child: Text(
                                  viewModel.displayName,
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                      ),
                                ),
                              ),
                              Text(
                              viewModel.email,
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: viewModel.formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                                child: TextFormField(
                                  controller: viewModel.fullNameTextController,
                                  focusNode: viewModel.fullNameFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Seu nome completo',
                                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                        ),
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
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                  keyboardType: TextInputType.name,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Campo obrigatório';
                                    }
                                    if (val.trim().split(' ').length < 2) {
                                      return 'Por favor, informe nome e sobrenome';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                                child: TextFormField(
                                  controller: viewModel.whatsappTextController,
                                  focusNode: viewModel.whatsappFocusNode,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'WhatsApp/Celular',
                                    hintText: '(00) 00000-0000',
                                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                        ),
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
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                    _PhoneNumberFormatter(),
                                  ],
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Campo obrigatório';
                                    }
                                    final numbers = val.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (numbers.length < 10 || numbers.length > 11) {
                                      return 'Número inválido (use DDD + número)';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                                child: TextFormField(
                                  controller: viewModel.cidadeTextController,
                                  focusNode: viewModel.cidadeFocusNode,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Cidade',
                                    hintText: 'Digite sua cidade',
                                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                        ),
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
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                  textCapitalization: TextCapitalization.words,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.05),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await viewModel.saveChanges(context);
                              },
                              text: 'Salvar Alterações',
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
                              showLoadingIndicator: false,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                ForgotPasswordPage.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            child: Text(
                              'Clique para alterar sua senha',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                ChangeEmailPage.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: const TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            child: Text(
                              'Clique para alterar seu email',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                  ),
                            ),
                          ),
                        ),
                      ],
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

class _EditAvatarPlaceholder extends StatelessWidget {
  const _EditAvatarPlaceholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).accent3,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_outline,
        size: size * 0.5,
        color: FlutterFlowTheme.of(context).primary,
      ),
    );
  }
}

/// Formatador de número de telefone
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final textLength = text.length;

    if (textLength == 0) {
      return newValue;
    }

    var buffer = StringBuffer();

    // Adiciona parênteses no DDD
    if (textLength > 0) {
      buffer.write('(');
      buffer.write(text.substring(0, textLength >= 2 ? 2 : textLength));
      if (textLength >= 2) {
        buffer.write(') ');
      }
    }

    // Adiciona os dígitos do número
    if (textLength >= 3) {
      if (textLength <= 6) {
        buffer.write(text.substring(2, textLength));
      } else if (textLength <= 10) {
        buffer.write(text.substring(2, 6));
        buffer.write('-');
        buffer.write(text.substring(6, textLength));
      } else {
        buffer.write(text.substring(2, 7));
        buffer.write('-');
        buffer.write(text.substring(7, textLength));
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
