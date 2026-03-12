import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/modal/constants/string_constants.dart';
import 'package:reown_appkit/modal/constants/style_constants.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/modal/services/magic_service/i_magic_service.dart';
import 'package:reown_appkit/modal/services/magic_service/models/magic_events.dart';
import 'package:reown_appkit/modal/widgets/buttons/base_button.dart';

import '../../../../services/wallet_management_service.dart';

class WalletConnectionButton extends StatefulWidget {
  const WalletConnectionButton({
    super.key,
    required this.appKit,
    this.size = BaseButtonSize.regular,
    this.state,
    this.context,
  });

  final IReownAppKitModal appKit;
  final BaseButtonSize size;
  final ConnectButtonState? state;
  final BuildContext? context;

  @override
  State<WalletConnectionButton> createState() => _WalletConnectionButtonState();
}

class _WalletConnectionButtonState extends State<WalletConnectionButton> {
  late ConnectButtonState _state;
  final walletManagementService = Get.find<WalletManagementService>();

  @override
  void initState() {
    super.initState();
    _state = widget.state ?? ConnectButtonState.idle;
    _updateState();
    widget.appKit.addListener(_updateState);
  }

  @override
  void didUpdateWidget(covariant WalletConnectionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _state = widget.state ?? ConnectButtonState.idle;
    _updateState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.appKit.removeListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        // _WebViewWidget(),

        ConnectButtonCustom(
          serviceStatus: widget.appKit.status,
          state: _state,
          size: widget.size,
          onTap: _onTap,
        ),
      ],
    );
  }

  void _onTap() async {
    if (widget.appKit.isConnected) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      await widget.appKit.disconnect();
      await Future.delayed(const Duration(seconds: 2));
      await walletManagementService.checkStatusOfConnectionAndReconnect();
      _updateState();
      EasyLoading.dismiss();
    } else {
      widget.appKit.openModalView().then(
        (value) {
          walletManagementService.checkStatusOfConnectionAndReconnect();
          _updateState();
        },
      );
    }
  }

  void _updateState() {
    final isConnected = widget.appKit.isConnected;
    if (_state == ConnectButtonState.none && !isConnected) {
      return;
    }
    // Case 0: init error
    if (widget.appKit.status == ReownAppKitModalStatus.error) {
      return setState(() => _state = ConnectButtonState.error);
    }
    // Case 1: Is connected
    else if (widget.appKit.isConnected) {
      return setState(() => _state = ConnectButtonState.connected);
    }
    // Case 1.5: No required namespaces
    else if (!widget.appKit.hasNamespaces) {
      return setState(() => _state = ConnectButtonState.disabled);
    }
    // Case 2: Is not open and is not connected
    else if (!widget.appKit.isOpen && !widget.appKit.isConnected) {
      return setState(() => _state = ConnectButtonState.idle);
    }
    // Case 3: Is open and is not connected
    else if (widget.appKit.isOpen && !widget.appKit.isConnected) {
      return setState(() => _state = ConnectButtonState.connecting);
    }
  }
}

class _WebViewWidget extends StatefulWidget {
  @override
  State<_WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<_WebViewWidget> {
  IMagicService get _magicService => GetIt.I<IMagicService>();
  bool _show = true;
  //
  @override
  void initState() {
    super.initState();
    _magicService.onMagicRpcRequest.subscribe(_onRequest);
  }

  @override
  void dispose() {
    _magicService.onMagicRpcRequest.unsubscribe(_onRequest);
    EasyLoading.dismiss();
    super.dispose();
  }

  void _onRequest(MagicRequestEvent? args) async {
    if (args != null) {
      final show = args.request == null;
      await Future.delayed(Duration(milliseconds: show ? 500 : 0));
      setState(() => _show = args.request == null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final farcasterIncluded = _magicService.isFarcasterEnabled.value;
    if (farcasterIncluded && _show) {
      return SizedBox(
        width: 0.5,
        height: 0.5,
        child: _magicService.webview,
      );
    }
    return const SizedBox.shrink();
  }
}

enum ConnectButtonState {
  error,
  idle,
  disabled,
  connecting,
  connected,
  none,
}

class ConnectButtonCustom extends StatelessWidget {
  const ConnectButtonCustom({
    super.key,
    this.size = BaseButtonSize.regular,
    this.state = ConnectButtonState.idle,
    this.serviceStatus = ReownAppKitModalStatus.idle,
    this.titleOverride,
    this.onTap,
  });
  final BaseButtonSize size;
  final ConnectButtonState state;
  final ReownAppKitModalStatus serviceStatus;
  final String? titleOverride;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final themeColors = ReownAppKitModalTheme.colorsOf(context);
    final connecting = state == ConnectButtonState.connecting;
    final disabled = state == ConnectButtonState.disabled;
    final connected = state == ConnectButtonState.connected;
    final disconnected = state == ConnectButtonState.idle;
    const borderRadius = 10.00;
    final showLoading = connecting || serviceStatus.isLoading;
    return BaseButton(
      semanticsLabel: 'AppKitModalConnectButton',
      onTap: disabled || connecting
          ? null
          : serviceStatus.isInitialized
              ? onTap
              : null,
      size: size,
      buttonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (connecting) {
              return themeColors.grayGlass002;
            }
            if (disconnected) {
              return Theme.of(context).colorScheme.tertiary;
            }

            if (states.contains(WidgetState.disabled)) {
              return Theme.of(context).colorScheme.tertiary;
            }

            return Theme.of(context).colorScheme.primary;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (connecting) {
              return Theme.of(context).colorScheme.onTertiary;
            }
            if (disconnected) {
              return Theme.of(context).colorScheme.onTertiary;
            }
            if (states.contains(WidgetState.disabled)) {
              return Theme.of(context).colorScheme.onTertiary;
            }
            return Theme.of(context).colorScheme.onPrimary;
          },
        ),
        shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
          (states) {
            return RoundedRectangleBorder(
              side: (states.contains(WidgetState.disabled) || connecting)
                  ? BorderSide(
                      color: themeColors.grayGlass002,
                      width: 1.0,
                    )
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius),
            );
          },
        ),
      ),
      overridePadding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        showLoading
            ? const EdgeInsets.only(left: 6.0, right: 16.0)
            : const EdgeInsets.only(left: 16.0, right: 16.0),
      ),
      child: showLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox.square(dimension: kPadding6),
                CircularLoaderCustom(
                  size: size.height * 0.4,
                  strokeWidth: size == BaseButtonSize.small ? 1.0 : 1.5,
                ),
                const SizedBox.square(dimension: kPadding6),
                if (connecting)
                  Text(titleOverride ?? UIConstants.connectButtonConnecting),
                if (serviceStatus.isLoading)
                  size == BaseButtonSize.small
                      ? Text(
                          titleOverride ?? UIConstants.connectButtonIdleShort)
                      : Text(titleOverride ?? UIConstants.connectButtonIdle),
              ],
            )
          : connected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wallet,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(titleOverride ?? UIConstants.connectButtonConnected),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wallet,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(titleOverride ?? UIConstants.connectButtonIdle),
                  ],
                ),
    );
  }
}

class CircularLoaderCustom extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final EdgeInsetsGeometry? padding;
  const CircularLoaderCustom({
    super.key,
    this.size,
    this.strokeWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    ReownAppKitModalTheme.colorsOf(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(0.0),
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.onTertiary,
        strokeWidth: strokeWidth ?? 4.0,
      ),
    );
  }
}
