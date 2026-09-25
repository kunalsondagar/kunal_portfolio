import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/responsive.dart';

/// A single coloured token in the code window.
class CodeToken {
  const CodeToken(this.text, this.color);

  final String text;
  final Color color;
}

class CodeLine {
  const CodeLine(this.tokens, {this.indent = 0});

  final List<CodeToken> tokens;
  final int indent;
}

/// macOS-style window frame around a snippet of source code.
///
/// Used in the hero. The snippet is real, runnable Flutter code — it is there to
/// show how the work is written, not to decorate the page.
class CodeWindow extends StatelessWidget {
  const CodeWindow({
    required this.lines,
    super.key,
    this.title = 'ride_controller.dart',
    this.maxWidth,
  });

  final List<CodeLine> lines;
  final String title;
  final double? maxWidth;

  /// Syntax colours, public so callers can build [CodeLine]s.
  static const Color keyword = Color(0xFFC792EA);
  static const Color type = Color(0xFF82AAFF);
  static const Color string = Color(0xFFC3E88D);
  static const Color fn = Color(0xFFFFCB6B);
  static const Color comment = Color(0xFF5C6A82);
  static const Color plain = Color(0xFFB9C4D6);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = AppTypography.mono.copyWith(
      fontSize: context.responsiveValue(mobile: 11.5, desktop: 12.5),
      height: 1.75,
      color: plain,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF080B12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _TitleBar(title: title),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < lines.length; i++)
                    _Line(line: lines[i], style: style, number: i + 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0C1018),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: <Widget>[
          _Dot(color: const Color(0xFFFF5F57)),
          const SizedBox(width: 7),
          _Dot(color: const Color(0xFFFEBC2E)),
          const SizedBox(width: 7),
          _Dot(color: const Color(0xFF28C840)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.mono.copyWith(
                fontSize: 11.5,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.line, required this.style, required this.number});

  final CodeLine line;
  final TextStyle style;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: line.indent * 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 22,
            child: Text(
              '$number',
              textAlign: TextAlign.right,
              style: style.copyWith(
                color: const Color(0xFF39425A),
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  for (final CodeToken token in line.tokens)
                    TextSpan(
                      text: token.text,
                      style: style.copyWith(color: token.color),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
