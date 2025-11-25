// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/custom_functions.dart'; // Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as Dialog;
import 'package:flutter/material.dart';
import 'dart:async';

Future showPickerNumberFormatValue(
  BuildContext context,
  int duration,
  FileType fileType,
  Future Function(int newDuration) callBack,
) async {
  var seconds = (duration % 60).truncate();
  var minutes = (duration / 60).truncate();
  var maxMinutes = (fileType == FileType.silence) ? 59 : minutes;
  var maxSeconds = (fileType == FileType.silence) ? 59 : seconds;
  Picker(
      footer: const Text(
        'Minutos      Segundos',
        style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w400),
      ),
      cancelText: 'Cancelar',
      cancelTextStyle:
          TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
      confirmText: 'Confirmar',
      confirmTextStyle:
          TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
      magnification: 1.5,
      itemExtent: 38,
      height: 200,
      columnPadding: const EdgeInsets.all(1),
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: maxMinutes, initValue: minutes),
        NumberPickerColumn(begin: 0, end: 59, initValue: seconds),
      ]),
      delimiter: [
        PickerDelimiter(
            child: Container(
          width: 30.0,
          alignment: Alignment.center,
          child: const Text(
            ':',
            style: TextStyle(fontSize: 24),
          ),
        ))
      ],
      hideHeader: true,
      title: const Center(
        child: Text(
          'Duração do timer',
          style: TextStyle(fontSize: 24, color: Colors.black54, fontWeight: FontWeight.w700),
        ),
      ),
      selectedTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      onConfirm: (Picker picker, List value) {
        //print(value.toString());
        print(picker.getSelectedValues());
        int newDuration = value[0] * 60 + value[1];
        if (newDuration > maxMinutes * 60 + maxSeconds) {
          newDuration = maxMinutes * 60 + maxSeconds;
        }
        callBack(newDuration);
      }).showDialog(context);
}

/// Picker selected callback.
typedef PickerSelectedCallback = void Function(Picker picker, int index, List<int> selected);

/// Picker confirm callback.
typedef PickerConfirmCallback = void Function(Picker picker, List<int> selected);

/// Picker confirm before callback.
typedef PickerConfirmBeforeCallback = Future<bool> Function(Picker picker, List<int> selected);

/// Picker value format callback.
typedef PickerValueFormat<T> = String Function(T value);

/// Picker widget builder
typedef PickerWidgetBuilder = Widget Function(BuildContext context, Widget pickerWidget);

/// Picker build item, If 'null' is returned, the default build is used
typedef PickerItemBuilder = Widget? Function(
    BuildContext context, String? text, Widget? child, bool selected, int col, int index);

/// Picker
class Picker {
  static const double DefaultTextSize = 18.0;

  /// Index of currently selected items
  late List<int> selecteds;

  /// Picker adapter, Used to provide data and generate widgets
  late PickerAdapter adapter;

  /// insert separator before picker columns
  final List<PickerDelimiter>? delimiter;

  final VoidCallback? onCancel;
  final PickerSelectedCallback? onSelect;
  final PickerConfirmCallback? onConfirm;
  final PickerConfirmBeforeCallback? onConfirmBefore;

  /// When the previous level selection changes, scroll the child to the first item.
  final changeToFirst;

  /// Specify flex for each column
  final List<int>? columnFlex;

  final Widget? title;
  final Widget? cancel;
  final Widget? confirm;
  final String? cancelText;
  final String? confirmText;

  final double height;

  /// Height of list item
  final double itemExtent;

  final TextStyle? textStyle, cancelTextStyle, confirmTextStyle, selectedTextStyle;
  final TextAlign textAlign;
  final IconThemeData? selectedIconTheme;

  /// Text scaling factor
  final double? textScaleFactor;

  final EdgeInsetsGeometry? columnPadding;
  final Color? backgroundColor, headerColor, containerColor;

  /// Hide head
  final bool hideHeader;

  /// Show pickers in reversed order
  final bool reversedOrder;

  /// Generate a custom header， [hideHeader] = true
  final WidgetBuilder? builderHeader;

  /// Generate a custom item widget, If 'null' is returned, the default builder is used
  final PickerItemBuilder? onBuilderItem;

  /// List item loop
  final bool looping;

  /// Delay generation for smoother animation, This is the number of milliseconds to wait. It is recommended to > = 200
  final int smooth;

  final Widget? footer;

  /// A widget overlaid on the picker to highlight the currently selected entry.
  final Widget selectionOverlay;

  final Decoration? headerDecoration;

  final double magnification;
  final double diameterRatio;
  final double squeeze;

  final bool printDebug;

  Widget? _widget;
  PickerWidgetState? _state;

  Picker(
      {required this.adapter,
      this.delimiter,
      List<int>? selecteds,
      this.height = 150.0,
      this.itemExtent = 28.0,
      this.columnPadding,
      this.textStyle,
      this.cancelTextStyle,
      this.confirmTextStyle,
      this.selectedTextStyle,
      this.selectedIconTheme,
      this.textAlign = TextAlign.start,
      this.textScaleFactor,
      this.title,
      this.cancel,
      this.confirm,
      this.cancelText,
      this.confirmText,
      this.backgroundColor = Colors.white,
      this.containerColor,
      this.headerColor,
      this.builderHeader,
      this.changeToFirst = false,
      this.hideHeader = false,
      this.looping = false,
      this.reversedOrder = false,
      this.headerDecoration,
      this.columnFlex,
      this.footer,
      this.smooth = 0,
      this.magnification = 1.0,
      this.diameterRatio = 1.1,
      this.squeeze = 1.45,
      this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
      this.onBuilderItem,
      this.onCancel,
      this.onSelect,
      this.onConfirmBefore,
      this.onConfirm,
      this.printDebug = false}) {
    this.selecteds = selecteds ?? <int>[];
  }

  Widget? get widget => _widget;
  PickerWidgetState? get state => _state;
  int _maxLevel = 1;

  /// 生成picker控件
  ///
  /// Build picker control
  Widget makePicker([ThemeData? themeData, bool isModal = false, Key? key]) {
    _maxLevel = adapter.maxLevel;
    adapter.picker = this;
    adapter.initSelects();
    _widget = PickerWidget(
      key: key ?? ValueKey(this),
      data: this,
      child: _PickerWidget(picker: this, themeData: themeData, isModal: isModal),
    );
    return _widget!;
  }

  /// show picker bottom sheet
  void show(
    ScaffoldState state, {
    ThemeData? themeData,
    Color? backgroundColor,
    PickerWidgetBuilder? builder,
  }) {
    state.showBottomSheet((BuildContext context) {
      final picker = makePicker(themeData);
      return builder == null ? picker : builder(context, picker);
    }, backgroundColor: backgroundColor);
  }

  /// show picker bottom sheet
  void showBottomSheet(
    BuildContext context, {
    ThemeData? themeData,
    Color? backgroundColor,
    PickerWidgetBuilder? builder,
  }) {
    Scaffold.of(context).showBottomSheet((BuildContext context) {
      final picker = makePicker(themeData);
      return builder == null ? picker : builder(context, picker);
    }, backgroundColor: backgroundColor);
  }

  /// Display modal picker
  Future<T?> showModal<T>(BuildContext context,
      {ThemeData? themeData,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      Color? backgroundColor,
      PickerWidgetBuilder? builder}) async {
    return await showModalBottomSheet<T>(
        context: context, //state.context,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        backgroundColor: backgroundColor,
        builder: (BuildContext context) {
          final picker = makePicker(themeData, true);
          return builder == null ? picker : builder(context, picker);
        });
  }

  /// show dialog picker
  Future<List<int>?> showDialog(BuildContext context,
      {bool barrierDismissible = true, Color? backgroundColor, PickerWidgetBuilder? builder, Key? key}) {
    return Dialog.showDialog<List<int>>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          final actions = <Widget>[];
          final theme = Theme.of(context);
          final cancelButton =
              PickerWidgetState._buildButton(context, cancelText, cancel, cancelTextStyle, true, theme, () {
            Navigator.pop<List<int>>(context, null);
            if (onCancel != null) {
              onCancel!();
            }
          });
          if (cancelButton != null) {
            actions.add(cancelButton);
          }
          final confirmButton =
              PickerWidgetState._buildButton(context, confirmText, confirm, confirmTextStyle, false, theme, () async {
            if (onConfirmBefore != null && !(await onConfirmBefore!(this, selecteds))) {
              return; // Cancel;
            }
            Navigator.pop<List<int>>(context, selecteds);
            if (onConfirm != null) {
              onConfirm!(this, selecteds);
            }
          });
          if (confirmButton != null) {
            actions.add(confirmButton);
          }
          return AlertDialog(
            key: key ?? const Key('picker-dialog'),
            title: title,
            backgroundColor: backgroundColor,
            actions: actions,
            content: builder == null ? makePicker(theme) : builder(context, makePicker(theme)),
          );
        });
  }

  /// 获取当前选择的值
  /// Get the value of the current selection
  List getSelectedValues() {
    return adapter.getSelectedValues();
  }

  /// 取消
  void doCancel(BuildContext context) {
    Navigator.of(context).pop<List<int>>(null);
    if (onCancel != null) onCancel!();
    _widget = null;
  }

  /// 确定
  void doConfirm(BuildContext context) async {
    if (onConfirmBefore != null && !(await onConfirmBefore!(this, selecteds))) {
      return; // Cancel;
    }
    Navigator.of(context).pop<List<int>>(selecteds);
    if (onConfirm != null) onConfirm!(this, selecteds);
    _widget = null;
  }

  /// 弹制更新指定列的内容
  /// 当 onSelect 事件中，修改了当前列前面的列的内容时，可以调用此方法来更新显示
  void updateColumn(int index, [bool all = false]) {
    if (all) {
      _state?.update();
      return;
    }
    if (_state?._keys[index] != null) {
      adapter.setColumn(index - 1);
      _state?._keys[index]!(() {});
    }
  }

  static ButtonStyle _getButtonStyle(ButtonThemeData? theme, [isCancelButton = false]) => TextButton.styleFrom(
      minimumSize: Size(theme?.minWidth ?? 0.0, 42),
      textStyle: TextStyle(
        fontSize: Picker.DefaultTextSize,
        color: isCancelButton ? null : theme?.colorScheme?.secondary,
      ),
      padding: theme?.padding);
}

/// 分隔符
class PickerDelimiter {
  final Widget? child;
  final int column;
  PickerDelimiter({required this.child, this.column = 1});
}

/// picker data list item
class PickerItem<T> {
  /// 显示内容
  final Widget? text;

  /// 数据值
  final T? value;

  /// 子项
  final List<PickerItem<T>>? children;

  PickerItem({this.text, this.value, this.children});
}

class PickerWidget<T> extends InheritedWidget {
  final Picker data;
  const PickerWidget({super.key, required this.data, required super.child});
  @override
  bool updateShouldNotify(covariant PickerWidget oldWidget) => oldWidget.data != data;

  static PickerWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PickerWidget>() as PickerWidget;
  }
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker picker;
  final ThemeData? themeData;
  final bool isModal;
  const _PickerWidget({super.key, required this.picker, this.themeData, required this.isModal});

  @override
  PickerWidgetState createState() => PickerWidgetState<T>(picker: this.picker, themeData: this.themeData);
}

class PickerWidgetState<T> extends State<_PickerWidget> {
  final Picker picker;
  final ThemeData? themeData;
  PickerWidgetState({required this.picker, this.themeData});

  ThemeData? theme;
  final List<FixedExtentScrollController> scrollController = [];
  final List<StateSetter?> _keys = [];

  @override
  void initState() {
    super.initState();
    picker._state = this;
    picker.adapter.doShow();

    if (scrollController.isEmpty) {
      for (int i = 0; i < picker._maxLevel; i++) {
        scrollController.add(FixedExtentScrollController(initialItem: picker.selecteds[i]));
        _keys.add(null);
      }
    }
  }

  void update() {
    setState(() {});
  }

  // var ref = 0;
  @override
  Widget build(BuildContext context) {
    // print("picker build ${ref++}");
    theme = themeData ?? Theme.of(context);

    if (_wait && picker.smooth > 0) {
      Future.delayed(Duration(milliseconds: picker.smooth), () {
        if (!_wait) return;
        setState(() {
          _wait = false;
        });
      });
    } else {
      _wait = false;
    }

    final body = <Widget>[];
    if (!picker.hideHeader) {
      if (picker.builderHeader != null) {
        body.add(picker.headerDecoration == null
            ? picker.builderHeader!(context)
            : DecoratedBox(decoration: picker.headerDecoration!, child: picker.builderHeader!(context)));
      } else {
        body.add(DecoratedBox(
          decoration: picker.headerDecoration ??
              BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme!.dividerColor, width: 0.5),
                  bottom: BorderSide(color: theme!.dividerColor, width: 0.5),
                ),
                color: picker.headerColor ?? (theme!.colorScheme.surface),
              ),
          child: Row(
            children: _buildHeaderViews(context),
          ),
        ));
      }
    }

    body.add(_wait
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildViews(),
          )
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildViews(),
            ),
          ));

    if (picker.footer != null) body.add(picker.footer!);
    Widget v = Column(
      mainAxisSize: MainAxisSize.min,
      children: body,
    );
    if (widget.isModal) {
      return GestureDetector(
        onTap: () {},
        child: v,
      );
    }
    return v;
  }

  List<Widget>? _headerItems;

  List<Widget> _buildHeaderViews(BuildContext context) {
    if (_headerItems != null) {
      return _headerItems!;
    }
    theme ??= Theme.of(context);
    List<Widget> items = [];

    final cancel = _buildButton(
        context, picker.cancelText, picker.cancel, picker.cancelTextStyle, true, theme, () => picker.doCancel(context));
    if (cancel != null) {
      items.add(cancel);
    }

    items.add(Expanded(
      child: picker.title == null
          ? const SizedBox()
          : DefaultTextStyle(
              style: theme!.textTheme.headlineSmall?.copyWith(
                    fontSize: Picker.DefaultTextSize,
                  ) ??
                  const TextStyle(fontSize: Picker.DefaultTextSize),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              child: picker.title!),
    ));

    final confirm = _buildButton(context, picker.confirmText, picker.confirm, picker.confirmTextStyle, false, theme,
        () => picker.doConfirm(context));
    if (confirm != null) {
      items.add(confirm);
    }

    _headerItems = items;
    return items;
  }

  static Widget? _buildButton(BuildContext context, String? text, Widget? widget, TextStyle? textStyle, bool isCancel,
      ThemeData? theme, VoidCallback? onPressed) {
    if (widget == null) {
      String? txt = text ?? (isCancel ? "Cancelar" : "Confirmar");
      if (txt.isEmpty) {
        return null;
      }
      return TextButton(
          style: Picker._getButtonStyle(ButtonTheme.of(context), isCancel),
          onPressed: onPressed,
          child: Text(txt,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              style: textStyle));
    } else {
      return textStyle == null ? widget : DefaultTextStyle(style: textStyle, child: widget);
    }
  }

  bool _changing = false;
  bool _wait = true;
  final Map<int, int> lastData = {};

  List<Widget> _buildViews() {
    if (picker.printDebug) print("_buildViews");
    theme ??= Theme.of(context);
    for (int j = 0; j < _keys.length; j++) {
      _keys[j] = null;
    }

    List<Widget> items = [];
    PickerAdapter? adapter = picker.adapter;
    adapter.setColumn(-1);

    if (adapter.length > 0) {
      var decoration = BoxDecoration(
        color: picker.containerColor ?? theme!.dialogBackgroundColor,
      );

      for (int i = 0; i < picker._maxLevel; i++) {
        Widget view = Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            padding: picker.columnPadding,
            height: picker.height,
            decoration: decoration,
            child: _wait
                ? null
                : StatefulBuilder(
                    builder: (context, state) {
                      _keys[i] = state;
                      adapter.setColumn(i - 1);
                      if (picker.printDebug) print("builder. col: $i");

                      // 上一次是空列表
                      final lastIsEmpty =
                          scrollController[i].hasClients && !scrollController[i].position.hasContentDimensions;

                      final length = adapter.length;
                      final view0 =
                          _buildCupertinoPicker(context, i, length, adapter, lastIsEmpty ? ValueKey(length) : null);

                      if (lastIsEmpty || (!picker.changeToFirst && picker.selecteds[i] >= length)) {
                        Timer(const Duration(milliseconds: 100), () {
                          if (!mounted) return;
                          if (picker.printDebug) print("timer last");
                          var len = adapter.length;
                          var index = (len < length ? len : length) - 1;
                          if (scrollController[i].position.hasContentDimensions) {
                            scrollController[i].jumpToItem(index);
                          } else {
                            scrollController[i] = FixedExtentScrollController(initialItem: index);
                            if (_keys[i] != null) {
                              _keys[i]!(() {});
                            }
                          }
                        });
                      }

                      return view0;
                    },
                  ),
          ),
        );
        items.add(view);
      }
    }

    if (picker.delimiter != null && !_wait) {
      for (int i = 0; i < picker.delimiter!.length; i++) {
        var o = picker.delimiter![i];
        if (o.child == null) continue;
        var item = SizedBox(height: picker.height, child: o.child);
        if (o.column < 0) {
          items.insert(0, item);
        } else if (o.column >= items.length)
          items.add(item);
        else
          items.insert(o.column, item);
      }
    }

    if (picker.reversedOrder) return items.reversed.toList();

    return items;
  }

  Widget _buildCupertinoPicker(BuildContext context, int i, int length, PickerAdapter adapter, Key? key) {
    return CupertinoPicker.builder(
      key: key,
      backgroundColor: picker.backgroundColor,
      scrollController: scrollController[i],
      itemExtent: picker.itemExtent,
      // looping: picker.looping,
      magnification: picker.magnification,
      diameterRatio: picker.diameterRatio,
      squeeze: picker.squeeze,
      selectionOverlay: picker.selectionOverlay,
      childCount: picker.looping ? null : length,
      itemBuilder: (context, index) {
        adapter.setColumn(i - 1);
        return adapter.buildItem(context, index % length);
      },
      onSelectedItemChanged: (int index) {
        if (length <= 0) return;
        final selectedIndex = index % length;
        if (picker.printDebug) {
          print("onSelectedItemChanged. col: $i, row: $selectedIndex");
        }
        picker.selecteds[i] = selectedIndex;
        updateScrollController(i);
        adapter.doSelect(i, selectedIndex);
        if (picker.changeToFirst) {
          for (int j = i + 1; j < picker.selecteds.length; j++) {
            picker.selecteds[j] = 0;
            scrollController[j].jumpTo(0.0);
          }
        }
        if (picker.onSelect != null) {
          picker.onSelect!(picker, i, picker.selecteds);
        }

        if (adapter.needUpdatePrev(i)) {
          for (int j = 0; j < picker.selecteds.length; j++) {
            if (j != i && _keys[j] != null) {
              adapter.setColumn(j - 1);
              _keys[j]!(() {});
            }
          }
          // setState(() {});
        } else {
          if (_keys[i] != null) _keys[i]!(() {});
          if (adapter.isLinkage) {
            for (int j = i + 1; j < picker.selecteds.length; j++) {
              if (j == i) continue;
              adapter.setColumn(j - 1);
              _keys[j]?.call(() {});
            }
          }
        }
      },
    );
  }

  void updateScrollController(int col) {
    if (_changing || picker.adapter.isLinkage == false) return;
    _changing = true;
    for (int j = 0; j < picker.selecteds.length; j++) {
      if (j != col) {
        if (scrollController[j].hasClients && scrollController[j].position.hasContentDimensions) {
          scrollController[j].position.notifyListeners();
        }
      }
    }
    _changing = false;
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_changing', _changing));
  }
}

/// 选择器数据适配器
abstract class PickerAdapter<T> {
  Picker? picker;

  int getLength();
  int getMaxLevel();
  void setColumn(int index);
  void initSelects();
  Widget buildItem(BuildContext context, int index);

  /// 是否需要更新前面的列
  /// Need to update previous columns
  bool needUpdatePrev(int curIndex) {
    return false;
  }

  Widget makeText(Widget? child, String? text, bool isSel) {
    return Center(
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker!.textAlign,
            style: picker!.textStyle ??
                TextStyle(
                    color: Colors.black87,
                    fontFamily: picker?.state?.context != null
                        ? Theme.of(picker!.state!.context).textTheme.headlineSmall!.fontFamily
                        : "",
                    fontSize: Picker.DefaultTextSize),
            child: child != null
                ? (isSel && picker!.selectedIconTheme != null
                    ? IconTheme(
                        data: picker!.selectedIconTheme!,
                        child: child,
                      )
                    : child)
                : Text(text ?? "",
                    textScaleFactor: picker!.textScaleFactor, style: (isSel ? picker!.selectedTextStyle : null))));
  }

  Widget makeTextEx(Widget? child, String text, Widget? postfix, Widget? suffix, bool isSel) {
    List<Widget> items = [];
    if (postfix != null) items.add(postfix);
    items.add(child ?? Text(text, style: (isSel ? picker!.selectedTextStyle : null)));
    if (suffix != null) items.add(suffix);

    Color? txtColor = Colors.black87;
    double? txtSize = Picker.DefaultTextSize;
    if (isSel && picker!.selectedTextStyle != null) {
      if (picker!.selectedTextStyle!.color != null) {
        txtColor = picker!.selectedTextStyle!.color;
      }
      if (picker!.selectedTextStyle!.fontSize != null) {
        txtSize = picker!.selectedTextStyle!.fontSize;
      }
    }

    return Center(
        //alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker!.textAlign,
            style: picker!.textStyle ?? TextStyle(color: txtColor, fontSize: txtSize),
            child: Wrap(
              children: items,
            )));
  }

  String getText() {
    return getSelectedValues().toString();
  }

  List<T> getSelectedValues() {
    return [];
  }

  void doShow() {}
  void doSelect(int column, int index) {}

  int getColumnFlex(int column) {
    if (picker!.columnFlex != null && column < picker!.columnFlex!.length) {
      return picker!.columnFlex![column];
    }
    return 1;
  }

  int get maxLevel => getMaxLevel();

  /// Content length of current column
  int get length => getLength();

  String get text => getText();

  // 是否联动，即后面的列受前面列数据影响
  bool get isLinkage => getIsLinkage();

  @override
  String toString() {
    return getText();
  }

  bool getIsLinkage() {
    return true;
  }

  /// 通知适配器数据改变
  void notifyDataChanged() {
    if (picker?.state != null) {
      picker!.adapter.doShow();
      picker!.adapter.initSelects();
      for (int j = 0; j < picker!.selecteds.length; j++) {
        picker!.state!.scrollController[j].jumpToItem(picker!.selecteds[j]);
      }
    }
  }
}

/// 数据适配器
class PickerDataAdapter<T> extends PickerAdapter<T> {
  late List<PickerItem<T>> data;
  List<PickerItem<dynamic>>? _datas;
  int _maxLevel = -1;
  int _col = 0;
  final bool isArray;

  PickerDataAdapter({List? pickerData, List<PickerItem<T>>? data, this.isArray = false}) {
    this.data = data ?? <PickerItem<T>>[];
    _parseData(pickerData);
  }

  @override
  bool getIsLinkage() {
    return !isArray;
  }

  void _parseData(List? pickerData) {
    if (pickerData != null && pickerData.isNotEmpty && (data.isEmpty)) {
      if (isArray) {
        _parseArrayPickerDataItem(pickerData, data);
      } else {
        _parsePickerDataItem(pickerData, data);
      }
    }
  }

  _parseArrayPickerDataItem(List? pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var v = pickerData[i];
      if (v is! List) continue;
      List lv = v;
      if (lv.isEmpty) continue;

      PickerItem item = PickerItem<T>(children: <PickerItem<T>>[]);
      data.add(item);

      for (int j = 0; j < lv.length; j++) {
        var o = lv[j];
        if (o is T) {
          item.children!.add(PickerItem<T>(value: o));
        } else if (T == String) {
          String v0 = o.toString();
          item.children!.add(PickerItem<T>(value: v0 as T));
        }
      }
    }
    if (picker?.printDebug == true) print("data.length: ${data.length}");
  }

  _parsePickerDataItem(List? pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var item = pickerData[i];
      if (item is T) {
        data.add(PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.isEmpty) continue;

        List<T> mapList = map.keys.toList().cast();
        for (int j = 0; j < mapList.length; j++) {
          var o = map[mapList[j]];
          if (o is List && o.isNotEmpty) {
            List<PickerItem<T>> children = <PickerItem<T>>[];
            //print('add: ${data.runtimeType.toString()}');
            data.add(PickerItem<T>(value: mapList[j], children: children));
            _parsePickerDataItem(o, children);
          }
        }
      } else if (T == String && item is! List) {
        String v = item.toString();
        //print('add: $_v');
        data.add(PickerItem<T>(value: v as T));
      }
    }
  }

  @override
  void setColumn(int index) {
    if (_datas != null && _col == index + 1) return;
    _col = index + 1;
    if (isArray) {
      if (picker!.printDebug) print("index: $index");
      if (_col < data.length) {
        _datas = data[_col].children;
      } else {
        _datas = null;
      }
      return;
    }
    if (index < 0) {
      _datas = data;
    } else {
      _datas = data;
      // 列数过多会有性能问题
      for (int i = 0; i <= index; i++) {
        var j = picker!.selecteds[i];
        if (_datas != null && _datas!.length > j) {
          _datas = _datas![j].children;
        } else {
          _datas = null;
          break;
        }
      }
    }
  }

  @override
  int getLength() => _datas?.length ?? 0;

  @override
  getMaxLevel() {
    if (_maxLevel == -1) _checkPickerDataLevel(data, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final PickerItem item = _datas![index];
    final isSel = index == picker!.selecteds[_col];
    if (picker!.onBuilderItem != null) {
      final v = picker!.onBuilderItem!(context, item.value.toString(), item.text, isSel, _col, index);
      if (v != null) return makeText(v, null, isSel);
    }
    if (item.text != null) {
      return isSel && picker!.selectedTextStyle != null
          ? DefaultTextStyle(
              style: picker!.selectedTextStyle!,
              textAlign: picker!.textAlign,
              child: picker!.selectedIconTheme != null
                  ? IconTheme(
                      data: picker!.selectedIconTheme!,
                      child: item.text!,
                    )
                  : item.text!)
          : item.text!;
    }
    return makeText(item.text, item.text != null ? null : item.value.toString(), isSel);
  }

  @override
  void initSelects() {
    // ignore: unnecessary_null_comparison
    if (picker!.selecteds == null) picker!.selecteds = <int>[];
    if (picker!.selecteds.isEmpty) {
      for (int i = 0; i < _maxLevel; i++) {
        picker!.selecteds.add(0);
      }
    }
  }

  @override
  List<T> getSelectedValues() {
    List<T> items = [];
    var sLen = picker!.selecteds.length;
    if (isArray) {
      for (int i = 0; i < sLen; i++) {
        int j = picker!.selecteds[i];
        if (j < 0 || data[i].children == null || j >= data[i].children!.length) {
          break;
        }
        items.add(data[i].children![j].value as T);
      }
    } else {
      List<PickerItem<dynamic>>? datas = data;
      for (int i = 0; i < sLen; i++) {
        int j = picker!.selecteds[i];
        if (j < 0 || j >= datas!.length) break;
        items.add(datas[j].value);
        datas = datas[j].children;
        if (datas == null || datas.isEmpty) break;
      }
    }
    return items;
  }

  _checkPickerDataLevel(List<PickerItem>? data, int level) {
    if (data == null) return;
    if (isArray) {
      _maxLevel = data.length;
      return;
    }
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children!.isNotEmpty) {
        _checkPickerDataLevel(data[i].children, level + 1);
      }
    }
    if (_maxLevel < level) _maxLevel = level;
  }
}

class NumberPickerColumn {
  final List<int>? items;
  final int begin;
  final int end;
  final int? initValue;
  final int columnFlex;
  final int jump;
  final Widget? postfix, suffix;
  final PickerValueFormat<int>? onFormatValue;

  const NumberPickerColumn({
    this.begin = 0,
    this.end = 9,
    this.items,
    this.initValue,
    this.jump = 1,
    this.columnFlex = 1,
    this.postfix,
    this.suffix,
    this.onFormatValue,
  });

  int indexOf(int? value) {
    if (value == null) return -1;
    if (items != null) return items!.indexOf(value);
    if (value < begin || value > end) return -1;
    return (value - begin) ~/ (jump == 0 ? 1 : jump);
  }

  int valueOf(int index) {
    if (items != null) {
      return items![index];
    }
    return begin + index * (jump == 0 ? 1 : jump);
  }

  String getValueText(int index) {
    return onFormatValue == null ? "${valueOf(index)}" : onFormatValue!(valueOf(index));
  }

  int count() {
    var v = (end - begin) ~/ (jump == 0 ? 1 : jump) + 1;
    if (v < 1) return 0;
    return v;
  }
}

class NumberPickerAdapter extends PickerAdapter<int> {
  NumberPickerAdapter({required this.data});

  final List<NumberPickerColumn> data;
  NumberPickerColumn? cur;
  int _col = 0;

  @override
  int getLength() {
    if (cur == null) return 0;
    if (cur!.items != null) return cur!.items!.length;
    return cur!.count();
  }

  @override
  int getMaxLevel() => data.length;

  @override
  bool getIsLinkage() {
    return false;
  }

  @override
  void setColumn(int index) {
    if (index != -1 && _col == index + 1) return;
    _col = index + 1;
    if (_col >= data.length) {
      cur = null;
    } else {
      cur = data[_col];
    }
  }

  @override
  void initSelects() {
    int maxLevel = getMaxLevel();
    // ignore: unnecessary_null_comparison
    if (picker!.selecteds == null) picker!.selecteds = <int>[];
    if (picker!.selecteds.isEmpty) {
      for (int i = 0; i < maxLevel; i++) {
        int v = data[i].indexOf(data[i].initValue);
        if (v < 0) v = 0;
        picker!.selecteds.add(v);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final txt = cur!.getValueText(index);
    final isSel = index == picker!.selecteds[_col];
    if (picker!.onBuilderItem != null) {
      final v = picker!.onBuilderItem!(context, txt, null, isSel, _col, index);
      if (v != null) return makeText(v, null, isSel);
    }
    if (cur!.postfix == null && cur!.suffix == null) {
      return makeText(null, txt, isSel);
    } else {
      return makeTextEx(null, txt, cur!.postfix, cur!.suffix, isSel);
    }
  }

  @override
  int getColumnFlex(int column) {
    return data[column].columnFlex;
  }

  @override
  List<int> getSelectedValues() {
    List<int> items = [];
    for (int i = 0; i < picker!.selecteds.length; i++) {
      int j = picker!.selecteds[i];
      int v = data[i].valueOf(j);
      items.add(v);
    }
    return items;
  }
}
