part of 'writing_result_screen.dart';

class _ChecklistSummary extends StatefulWidget {
  const _ChecklistSummary({required this.items});

  final List<WritingChecklistItem> items;

  @override
  State<_ChecklistSummary> createState() => _ChecklistSummaryState();
}

class _ChecklistSummaryState extends State<_ChecklistSummary> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final items = widget.items;
    final completed = items.where((item) => item.completed).length;
    final progress = items.isEmpty ? 0.0 : completed / items.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              overlayColor: const WidgetStatePropertyAll<Color?>(
                Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$completed/${items.length} critérios atendidos',
                            style: GoogleFonts.manrope(
                              color: colors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isExpanded
                                ? 'Toque para recolher os critérios'
                                : 'Toque para ver os critérios',
                            style: GoogleFonts.inter(
                              color: colors.onSurfaceMuted,
                              fontSize: 11.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: colors.onSurfaceMuted,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(colors.success),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 420),
              reverseDuration: const Duration(milliseconds: 320),
              curve: Curves.easeOutQuart,
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _isExpanded ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      for (var index = 0; index < items.length; index++) ...[
                        _ChecklistRow(item: items[index]),
                        if (index != items.length - 1)
                          const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final WritingChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final completed = item.completed;
    final color = completed ? colors.success : colors.onSurfaceMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: completed
            ? color.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle_rounded : Icons.close_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: completed ? color : colors.onSurface,
                fontSize: 12.2,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            completed ? 'OK' : 'Pendente',
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
