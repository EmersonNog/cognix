part of '../writing_editor_screen.dart';

class _QuickOverview extends StatelessWidget {
  const _QuickOverview({
    required this.wordCount,
    required this.paragraphCount,
    required this.completedCount,
    required this.totalChecklist,
  });

  final int wordCount;
  final int paragraphCount;
  final int completedCount;
  final int totalChecklist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OverviewCard(
            icon: Icons.notes_rounded,
            label: 'Palavras',
            value: '$wordCount',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _OverviewCard(
            icon: Icons.view_agenda_rounded,
            label: 'Parágrafos',
            value: '$paragraphCount',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _OverviewCard(
            icon: Icons.task_alt_rounded,
            label: 'Checklist',
            value: '$completedCount/$totalChecklist',
            accent: _editorSuccess,
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = _editorPrimary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _editorSurfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: _editorOnSurface,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              color: _editorOnSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.items});

  final List<WritingChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _editorSurfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _editorSuccess.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: _editorSuccess,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Checklist de revisão',
                  style: GoogleFonts.manrope(
                    color: _editorOnSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final item in items) _ChecklistTile(item: item),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({required this.item});

  final WritingChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.completed ? _editorSuccess : _editorOnSurfaceMuted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: color,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    color: _editorOnSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.helper,
                  style: GoogleFonts.inter(
                    color: _editorOnSurfaceMuted,
                    fontSize: 11.8,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
