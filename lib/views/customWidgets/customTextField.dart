// New Theme Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom Text Fill that change the text font size if it doesn't fit in the [width].
/// Every TextField's parameters can also be used (they will be transmit to the TextField)
class CustomTextField extends StatefulWidget {
  final BuildContext context;
  final double width;
  final double? height;
  final double maxFontSize;
  final double minFontSize;
  final TextEditingController controller;

  //Parameters of the default TextField
  //Will be reused when creating a TextField as a child
  final InputDecoration? decoration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final Object groupId;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  static const int noMaxLength = -1;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  bool? get selectionEnabled => enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool canRequestFocus;
  final UndoHistoryController? undoController;
  static Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
  final SpellCheckConfiguration? spellCheckConfiguration;
  static const TextStyle materialMisspelledTextStyle = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: Colors.red,
    decorationStyle: TextDecorationStyle.wavy,
  );


  //---------------------------------------------------------------------------------
  //Constructor
  const CustomTextField({
    required this.context,
    required this.width, // Fixed width of the TextField
    this.height,
    required this.controller,
    this.maxFontSize = 20.0, // Maximum font size
    this.minFontSize = 12.0, // Minimum font size
    this.decoration = const InputDecoration(), // Custom InputDecoration

    //Parameters of the default TextField
    super.key,
    this.groupId = EditableText,
    this.focusNode,
    this.undoController,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });

  @override
  _CustomTextField createState() => _CustomTextField();
}

class _CustomTextField extends State<CustomTextField> {
  late final TextEditingController _controller ;
  double _fontSize = 18.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_adjustFontSize);
    _fontSize = widget.maxFontSize;
    //Initialization with a first check of size (in case of already having text, the controller need to be checked manually)
    _adjustFontSize();

  }


  void _adjustFontSize() {
    // Measure the text width using TextPainter
    final text = _controller.text;
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: _fontSize)),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.textScaler = MediaQuery.textScalerOf(widget.context); //Get the text scalor based on the device's text font size
    textPainter.layout();

    double textWidth = textPainter.width;
    //print("Text Width : $textWidth");

    // Adjust the font size to fit within the fixed width
    if (mounted) {
      setState(() {
        if (_controller.text.isEmpty) {
          _fontSize = widget.maxFontSize;
        }
        // 0.75 to reduce by 25% because of a white space at the right and left
        else if ((textWidth) > (widget.width*0.75*widget.maxLines) && _fontSize > widget.minFontSize) {
          //Reduce while it don't fit in the box
          while (textWidth > (widget.width*0.75*widget.maxLines) && _fontSize > widget.minFontSize) {
            _fontSize = _fontSize - 1;
            textPainter = TextPainter(
              text: TextSpan(text: text, style: TextStyle(fontSize: _fontSize)),
              maxLines: widget.maxLines,
              textDirection: TextDirection.ltr,
            );
            textPainter.textScaler = MediaQuery.textScalerOf(widget.context);
            textPainter.layout();
            textWidth = textPainter.width;
          }
        }
        else if (textWidth < (widget.width*0.75*widget.maxLines) && _fontSize < widget.maxFontSize) {
          _fontSize = _fontSize + 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: TextField(
          controller: _controller,
          //Copy the TextStyle (if exists) and only change the fontSize
          style : widget.style == null ?  TextStyle(fontSize: _fontSize) : widget.style?.copyWith(fontSize: _fontSize),

          //TextField parameters that didn't get changed :
          decoration: widget.decoration,
          groupId: widget.groupId,
          focusNode: widget.focusNode,
          undoController: widget.undoController,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          textDirection: widget.textDirection,
          readOnly: widget.readOnly,
          showCursor: widget.showCursor,
          autofocus: widget.autofocus,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          ignorePointers: widget.ignorePointers,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorOpacityAnimates: widget.cursorOpacityAnimates,
          cursorColor: widget.cursorColor,
          cursorErrorColor: widget.cursorErrorColor,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          keyboardAppearance: widget.keyboardAppearance,
          scrollPadding: widget.scrollPadding,
          dragStartBehavior: widget.dragStartBehavior,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          selectionControls: widget.selectionControls,
          onTap: widget.onTap,
          onTapAlwaysCalled: widget.onTapAlwaysCalled,
          onTapOutside: widget.onTapOutside,
          mouseCursor: widget.mouseCursor,
          buildCounter: widget.buildCounter,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          autofillHints: widget.autofillHints,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          clipBehavior: widget.clipBehavior,
          restorationId: widget.restorationId,
          scribbleEnabled: widget.scribbleEnabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          contextMenuBuilder: widget.contextMenuBuilder,
          canRequestFocus: widget.canRequestFocus,
          spellCheckConfiguration: widget.spellCheckConfiguration,
          magnifierConfiguration: widget.magnifierConfiguration,
        ),
      ),
    );
  }
}
