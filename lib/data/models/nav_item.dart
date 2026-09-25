/// A navbar entry. [sectionId] doubles as the scroll anchor and the id on the
/// matching [SectionShell].
class NavItem {
  const NavItem({required this.label, required this.sectionId});

  final String label;
  final String sectionId;
}
