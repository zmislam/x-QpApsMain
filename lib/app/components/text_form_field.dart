import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../config/constants/color.dart';

const OutlineInputBorder ENABLED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: ENABLED_BORDER_COLOR),
);
const OutlineInputBorder FOCUSED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: FOCUSED_BORDER_COLOR),
);
const OutlineInputBorder ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: ERROR_BORDER_COLOR),
);
const OutlineInputBorder FOCUSED_ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: FOCUSED_ERROR_BORDER_COLOR),
);

class LoginTextFormField extends StatelessWidget {
  const LoginTextFormField({
    Key? key,
    this.label,
    this.validationText,
    this.controller,
    this.suffixIconButton,
    this.prefixIcon,
    this.prefixIconColor,
    required this.obscureText,
    this.focusNode,
    this.fillColor,
  }) : super(key: key);

  final String? label;
  final String? validationText;
  final TextEditingController? controller;
  final IconButton? suffixIconButton;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final bool obscureText;
  final FocusNode? focusNode;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: fillColor != null,
        suffixIcon: suffixIconButton,
        hintText: label,
        contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class SignUpTextFormField extends StatelessWidget {
  const SignUpTextFormField(
      {super.key,
      required this.controller,
      required this.label,
      this.validationText,
      this.validator,
      this.suffixIcon,
      this.obscureText,
      this.inputType});
  final TextEditingController controller;
  final String label;
  final String? validationText;
  final TextInputType? inputType;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: inputType ?? TextInputType.text,
      decoration: InputDecoration(
          label: Text(label),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: PRIMARY_COLOR),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          suffixIcon: suffixIcon),
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return validationText;
            } else {
              return null;
            }
          },
    );
  }
}

class PrimaryTextFormField extends StatelessWidget {
  const PrimaryTextFormField(
      {super.key,
      this.controller,
      this.label,
      this.hinText,
      this.validationText,
      this.maxLines,
      this.maxLength,
      this.validator,
      this.hintStyle,
      this.outlineBorder,
      this.readOnly,
      this.keyboardInputType,
      this.suffixIcon,
      this.suffixIconColor,
      this.prefixIcon,
      this.prefixIconColor,
      this.onTap,
      this.onChanged,
      this.inputTextStyle,
      this.textInputAction,
      this.labelTextStyle,
      this.inputFormatters});
  final String? label;
  final bool? readOnly;
  final String? hinText;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? labelTextStyle;
  final InputBorder? outlineBorder;
  final TextInputType? keyboardInputType;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  final TextEditingController? controller;
  final String? validationText;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      keyboardType: keyboardInputType ?? TextInputType.text,
      onChanged: onChanged,
      style: inputTextStyle,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        suffixIconColor:
            suffixIconColor, //?? Colors.grey.withValues(alpha:0.5),
        prefixIconColor:
            prefixIconColor, //?? Colors.grey.withValues(alpha:0.5),

        prefixIcon: prefixIcon,
        filled: false,
        border:
            outlineBorder, //?? OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder:
            outlineBorder, //?? OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder:
            outlineBorder, //?? OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

        // suffixIcon: suffixIcon,
        // obscureText: obscureText?? false,

        hintText: hinText,
        hintStyle: hintStyle, //?? const TextStyle(color: Colors.grey),
        // label: Text(label),
        labelText: label,
        labelStyle: labelTextStyle,
      ),
      textInputAction: textInputAction,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return validationText;
            } else {
              return null;
            }
          },
    );
  }
}

class BorderlessTextFormField extends StatelessWidget {
  const BorderlessTextFormField(
      {super.key,
      this.controller,
      this.label,
      this.validationText,
      this.suffixIcon,
      this.obscureText,
      this.maxLines,
      this.inputType});
  final String? label;

  final TextEditingController? controller;
  final String? validationText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final int? maxLines;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      maxLines: maxLines ?? 1,
      keyboardType: inputType ?? TextInputType.text,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label ?? '',
          suffixIcon: suffixIcon),
      validator: (value) {
        if (value!.isEmpty) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class AboutTextFormField extends StatelessWidget {
  const AboutTextFormField({
    super.key,
    this.controller,
    this.label,
    this.validationText,
  });
  final String? label;

  final TextEditingController? controller;
  final String? validationText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            hintText: label,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return validationText;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}

class ClickableTextFormField extends StatelessWidget {
  const ClickableTextFormField(
      {Key? key,
      this.label,
      this.validationText,
      this.controller,
      this.suffixIcon,
      this.suffixIconColor,
      this.maxLines,
      this.hints,
      this.onTap,
      this.inputFormatters})
      : super(key: key);
  final String? label;
  final String? validationText;
  final String? hints;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final int? maxLines;

  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onTap: onTap,
      canRequestFocus: false,
      inputFormatters: inputFormatters,
      magnifierConfiguration: const TextMagnifierConfiguration(),
      decoration: InputDecoration(
          // filled: true,
          // fillColor: Colors.white,
          hintText: hints,
          prefixIcon: Icon(
            suffixIcon,
            color: suffixIconColor,
          ),
          // label: Text(label ?? '',),
          labelText: label
          // contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationText;
        } else {
          return null;
        }
      },
    );
  }
}

class AboutClickableTextFormField extends StatelessWidget {
  const AboutClickableTextFormField({
    Key? key,
    this.label,
    this.validationText,
    this.controller,
    this.prefixIcon,
    this.prefixColor,
    this.hintText,
    this.onTap,
  }) : super(key: key);
  final String? label;
  final String? hintText;
  final String? validationText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Color? prefixColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          onTap: onTap,
          canRequestFocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardTheme.color,
            hintText: hintText ?? '',
            prefixIcon: Icon(
              prefixIcon,
              color: prefixColor,
            ),
            contentPadding: const EdgeInsets.only(left: 10),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return validationText;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}

class CardExpiryTextFormField extends StatelessWidget {
  const CardExpiryTextFormField({
    super.key,
    this.hintText,
    this.controller,
  });
  final TextEditingController? controller;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        CardExpiryInputFormatter(),
      ],
    );
  }
}

class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.length == 2 && !text.contains('/')) {
      text += '/';
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class MultiInputChipField extends StatefulWidget {
  const MultiInputChipField({
    super.key,
    this.label = 'Add items',
    this.hintText = 'Type and press Enter',
    this.validator,
    this.chipBackgroundColor,
    this.chipTextColor,
    this.inputBorder,
    this.inputTextStyle,
    this.labelTextStyle,
    this.onChanged,
    this.initialItems = const [],
    this.itemsRx,
  });

  final String label;
  final String hintText;
  final String? Function(List<String>?)? validator;
  final Color? chipBackgroundColor;
  final Color? chipTextColor;
  final InputBorder? inputBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? labelTextStyle;
  final Function(List<String>)? onChanged;
  final List<String> initialItems;
  final RxList<String>? itemsRx;

  @override
  State<MultiInputChipField> createState() => _MultiInputChipFieldState();
}

class _MultiInputChipFieldState extends State<MultiInputChipField> {
  final TextEditingController _controller = TextEditingController();
  late RxList<String> _items;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Use provided RxList or create a new one with initial items
    _items = widget.itemsRx ?? RxList<String>.from(widget.initialItems);
  }

  void _addItem(String value) {
    if (value.trim().isNotEmpty && !_items.contains(value.trim())) {
      _items.add(value.trim());
      _controller.clear();
      if (widget.onChanged != null) {
        widget.onChanged!(_items.toList());
      }
    }
  }

  void _removeItem(String value) {
    _items.remove(value);
    if (widget.onChanged != null) {
      widget.onChanged!(_items.toList());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          style: widget.inputTextStyle,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: widget.labelTextStyle,
            hintText: widget.hintText,
            border: widget.inputBorder ??
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: widget.inputBorder ??
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: widget.inputBorder ??
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addItem(_controller.text);
                _focusNode.requestFocus();
              },
            ),
          ),
          onFieldSubmitted: (value) {
            _addItem(value);
            _focusNode.requestFocus();
          },
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(_items);
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\n')),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => _items.isEmpty
            ? const SizedBox.shrink()
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _items.map((item) => _buildChip(item)).toList(),
              )),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: widget.chipTextColor ?? Colors.white,
        ),
      ),
      backgroundColor:
          widget.chipBackgroundColor ?? Theme.of(context).primaryColor,
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      deleteIconColor: widget.chipTextColor ?? Colors.white,
      onDeleted: () => _removeItem(label),
    );
  }
}
