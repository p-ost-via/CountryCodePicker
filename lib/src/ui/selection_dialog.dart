import 'package:country_code_picker/src/misc/country_localizations.dart';
import 'package:country_code_picker/src/model/country_code.dart';
import 'package:flutter/material.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final Icon? closeIcon;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.closeIcon,
  })  : this.searchDecoration = searchDecoration.prefixIcon == null
            ? searchDecoration.copyWith(prefixIcon: Icon(Icons.search))
            : searchDecoration,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  late List<CountryCode> filteredElements;

  String currentQuery = '';

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widget.size?.width ?? MediaQuery.of(context).size.width,
          height:
              widget.size?.height ?? MediaQuery.of(context).size.height * 0.85,
          decoration: widget.boxDecoration ??
              BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: widget.barrierColor ?? Colors.grey.withOpacity(1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 20,
                  icon: widget.closeIcon!,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              if (!widget.hideSearch)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    style: widget.searchStyle,
                    decoration: widget.searchDecoration,
                    onChanged: (value) => _filterElements(context, value),
                  ),
                ),
              Expanded(
                child: ListView(
                  children: [
                    if (filteredElements.isNotEmpty &&
                        currentQuery.isNotEmpty) ...[
                      ...filteredElements
                          .map<Widget>((e) => _buildOption(e))
                          .toList(growable: false),
                      const Divider(),
                    ] else if (filteredElements.isEmpty &&
                        currentQuery.isNotEmpty)
                      _buildEmptySearchWidget(context),
                    widget.favoriteElements.isEmpty
                        ? const DecoratedBox(decoration: BoxDecoration())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.favoriteElements
                                  .map((f) => _buildOption(f)),
                              const Divider(),
                            ],
                          ),
                    if (currentQuery.isEmpty)
                      ...widget.elements
                          .map((e) => _buildOption(e))
                          .toList(growable: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildOption(CountryCode code) => Material(
        color: Colors.transparent,
        child: SimpleDialogOption(
          onPressed: () => _selectItem(code),
          child: Container(
            width: 400,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                if (widget.showFlag!)
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration: widget.flagDecoration,
                      clipBehavior: widget.flagDecoration == null
                          ? Clip.none
                          : Clip.hardEdge,
                      child: Image.asset(
                        code.flagUri!,
                        package: 'country_code_picker',
                        width: widget.flagWidth,
                      ),
                    ),
                  ),
                Expanded(
                  flex: 4,
                  child: Text(
                    widget.showCountryOnly!
                        ? code.toCountryStringOnly()
                        : code.toLongString(),
                    overflow: TextOverflow.fade,
                    style: widget.textStyle?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildEmptySearchWidget(BuildContext context) {
    Widget wrapIntoPadding(Widget child) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: child,
      );
    }

    if (widget.emptySearchBuilder != null) {
      return wrapIntoPadding(widget.emptySearchBuilder!(context));
    }

    return Center(
      child: wrapIntoPadding(
        Text(CountryLocalizations.of(context)?.translate('no_country') ??
            'No country found'),
      ),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(BuildContext context, String s) {
    s = s.toUpperCase();
    setState(() {
      currentQuery = s;
      filteredElements = widget.elements
          .where((e) =>
              e.code!.contains(s) ||
              e.dialCode!.contains(s) ||
              e.name!.toUpperCase().contains(s) ||
              e.engName.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
