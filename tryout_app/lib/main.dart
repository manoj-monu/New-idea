import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const TryOutApp());

const purple = Color(0xFFE83DFF);
const purpleLight = Color(0xFF25112F);
const ink = Color(0xFFF8F5FF);
const muted = Color(0xFFB8B1C8);
const pageBg = Color(0xFF070812);
const categories = ['Women', 'Men', 'Kids'];
const clothes = ['Tops', 'Dresses', 'Jeans', 'Jackets', 'Sarees', 'Traditional', 'Sportswear', 'Innerwear', 'Shirts'];
const screenTitles = ['Splash Screen','Onboarding 1','Onboarding 2','Onboarding 3','Home Screen','Choose Category','Select Clothing','Choose Your Photo','Crop Photo','Choose Clothing Photo','Processing','Try-On Result','Edit Look','Save & Share','My Wardrobe','My Looks / History','Profile','Settings','Help & Support','Side Menu','3D View'];

class TryOutApp extends StatelessWidget {
  const TryOutApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'TryOut', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: pageBg,
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark),
      appBarTheme: const AppBarTheme(backgroundColor: pageBg, foregroundColor: ink, elevation: 0),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: purple, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
      fontFamily: 'Roboto'),
    home: const AppShell());
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override State<AppShell> createState() => _AppShellState();
}
class _AppShellState extends State<AppShell> {
  int tab = 0;
  final person = ValueNotifier<XFile?>(null);
  final garment = ValueNotifier<XFile?>(null);
  final picker = ImagePicker();
  final List<XFile> savedLooks = [];
  Future<void> pick(bool isPerson, ImageSource source) async {
    final file = await picker.pickImage(source: source, maxWidth: 1600, maxHeight: 2000, imageQuality: 92);
    if (file != null && mounted) {
      (isPerson ? person : garment).value = file;
      setState(() {});
    }
  }
  void open(int index) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppScreen(
    index: index, person: person, garment: garment, pick: pick, savedLooks: savedLooks,
    onSave: (file) { setState(() { if (!savedLooks.any((f) => f.path == file.path)) savedLooks.add(file); }); })));
  @override void dispose() { person.dispose(); garment.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: IndexedStack(index: tab, children: [
      HomeScreen(onOpen: open),
      AppScreen(index: 5, person: person, garment: garment, pick: pick, savedLooks: savedLooks, onSave: (f) { setState(() { if (!savedLooks.any((x) => x.path == f.path)) savedLooks.add(f); }); }),
      AppScreen(index: 15, person: person, garment: garment, pick: pick, savedLooks: savedLooks, onSave: (_) {}),
      AppScreen(index: 16, person: person, garment: garment, pick: pick, savedLooks: savedLooks, onSave: (_) {}),
    ])),
    bottomNavigationBar: NavigationBar(backgroundColor: const Color(0xFF10111D), indicatorColor: const Color(0xFF432047), selectedIndex: tab,
      onDestinationSelected: (i) => setState(() => tab = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.checkroom_outlined), selectedIcon: Icon(Icons.checkroom), label: 'Try On'),
        NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'My Looks'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ]));
}

class HomeScreen extends StatelessWidget {
  final void Function(int) onOpen;
  const HomeScreen({super.key, required this.onOpen});
  @override Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF090815), Color(0xFF070812), Color(0xFF10091D)])),
    child: ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 28), children: [
      Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: const LinearGradient(colors: [Color(0xFFFF36DE), Color(0xFF792BFF)])), child: const Icon(Icons.checkroom_rounded, color: Colors.white, size: 27)),
        const SizedBox(width: 10),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('TryOut', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: ink, height: 1.0)),
          SizedBox(height: 3), Text('AI VIRTUAL TRY-ON', style: TextStyle(fontSize: 9, letterSpacing: 2.1, fontWeight: FontWeight.w800, color: muted))
        ])),
        Container(decoration: BoxDecoration(color: const Color(0xFF21152D), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFC857))), child: TextButton.icon(onPressed: () => onOpen(21), icon: const Icon(Icons.workspace_premium, color: Color(0xFFFFC857), size: 17), label: const Text('PRO', style: TextStyle(color: Color(0xFFFFD875), fontWeight: FontWeight.w900)))),
      ]),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF32106C), Color(0xFF7518A8), Color(0xFF21104D)]),
        border: Border.all(color: const Color(0xFFDA49FF), width: 1.2),
        boxShadow: [BoxShadow(color: purple.withValues(alpha: .20), blurRadius: 24, spreadRadius: 1)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('YOUR NEXT LOOK\nSTARTS HERE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 10),
          const Text('Try Any Outfit\nwith AI', style: TextStyle(color: Colors.white, fontSize: 30, height: 1.03, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text('Choose a photo, pick a style, and explore your look.', style: TextStyle(color: Colors.white.withValues(alpha: 0.86), height: 1.4)),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: FilledButton.icon(onPressed: () => onOpen(5), icon: const Icon(Icons.auto_awesome, size: 18), label: const Text('Try Now'), style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF3DE4), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)))),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: () => onOpen(15), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14)), child: const Icon(Icons.photo_library_outlined))
          ]),
          const SizedBox(height: 15),
          Row(children: [
            _heroPill(Icons.photo_camera_outlined, 'Your photo'),
            const SizedBox(width: 7), const Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
            const SizedBox(width: 7), _heroPill(Icons.checkroom_outlined, 'Choose style'),
            const SizedBox(width: 7), const Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
            const SizedBox(width: 7), _heroPill(Icons.auto_awesome, 'Preview')
          ])
        ])),
      const SizedBox(height: 25),
      Row(children: [const Expanded(child: Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ink))), TextButton(onPressed: () => onOpen(5), child: const Text('See all  →', style: TextStyle(color: purple)))]),
      const SizedBox(height: 9),
      Row(children: [
        Expanded(child: _homeAction(Icons.checkroom_rounded, 'Try Outfit', 'Start a look', () => onOpen(5))),
        const SizedBox(width: 9), Expanded(child: _homeAction(Icons.photo_library_outlined, 'My Photos', 'Choose photo', () => onOpen(7))),
        const SizedBox(width: 9), Expanded(child: _homeAction(Icons.favorite_border_rounded, 'My Looks', 'Saved looks', () => onOpen(15)))
      ]),
      const SizedBox(height: 25),
      Row(children: [const Expanded(child: Text('Browse Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ink))), TextButton(onPressed: () => onOpen(5), child: const Text('See all  →', style: TextStyle(color: purple)))]),
      const SizedBox(height: 10),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, mainAxisSpacing: 9, crossAxisSpacing: 9, childAspectRatio: .82, children: [
        _categoryTile(Icons.checkroom, 'Tops', () => onOpen(6)), _categoryTile(Icons.dry_cleaning, 'Dresses', () => onOpen(6)),
        _categoryTile(Icons.work_outline, 'Formal', () => onOpen(6)), _categoryTile(Icons.directions_run, 'Sporty', () => onOpen(6)),
        _categoryTile(Icons.woman_2_outlined, 'Traditional', () => onOpen(6)), _categoryTile(Icons.style_outlined, 'Jackets', () => onOpen(6)),
        _categoryTile(Icons.face_3_outlined, 'Kids', () => onOpen(6)), _categoryTile(Icons.grid_view_rounded, 'All Styles', () => onOpen(6))
      ]),
      const SizedBox(height: 24),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF11101E), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF40204F))), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.info_outline, color: purple), SizedBox(width: 10), Expanded(child: Text('Preview build: photo selection and navigation are available. Real AI-generated clothing results will be enabled after the UI pass and AI service integration.', style: TextStyle(color: muted, height: 1.45, fontSize: 12)))
      ]))
    ]));
  static Widget _heroPill(IconData icon, String label) => Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8), decoration: BoxDecoration(color: Colors.black.withValues(alpha: .18), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 13), const SizedBox(width: 4), Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)))])));
  static Widget _homeAction(IconData icon, String title, String subtitle, VoidCallback tap) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.fromLTRB(8, 15, 8, 14), decoration: BoxDecoration(color: const Color(0xFF151321), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF44214F))), child: Column(children: [Container(width: 42, height: 42, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: const LinearGradient(colors: [Color(0xFF44205C), Color(0xFF24123B)])), child: Icon(icon, color: purple, size: 23)), const SizedBox(height: 9), Text(title, textAlign: TextAlign.center, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: muted, fontSize: 9))])));
  static Widget _categoryTile(IconData icon, String title, VoidCallback tap) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(15), child: Container(decoration: BoxDecoration(color: const Color(0xFF151321), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF35213F))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: purple, size: 27), const SizedBox(height: 8), Text(title, textAlign: TextAlign.center, style: const TextStyle(color: ink, fontSize: 10, fontWeight: FontWeight.w700))])));
}
class ActionCard extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const ActionCard({super.key, required this.icon, required this.title, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18),
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16), decoration: BoxDecoration(color: const Color(0xFF151625), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF392343))),
      child: Column(children: [Icon(icon, color: purple, size: 26), const SizedBox(height: 8), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: ink))])));
}

class AppScreen extends StatefulWidget {
  final int index;
  final ValueNotifier<XFile?> person, garment;
  final Future<void> Function(bool, ImageSource) pick;
  final List<XFile> savedLooks;
  final void Function(XFile) onSave;
  const AppScreen({super.key, required this.index, required this.person, required this.garment, required this.pick, required this.savedLooks, required this.onSave});
  @override State<AppScreen> createState() => _AppScreenState();
}
class _AppScreenState extends State<AppScreen> {
  int selectedCategory = 0, selectedGarment = -1;
  bool notifications = true, darkMode = false;
  Future<void> choosePhoto(bool isPerson) async {
    final source = await showModalBottomSheet<ImageSource>(context: context, builder: (c) => SafeArea(child: Wrap(children: [
      ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Take Photo'), onTap: () => Navigator.pop(c, ImageSource.camera)),
      ListTile(leading: const Icon(Icons.photo_library), title: const Text('Choose from Gallery'), onTap: () => Navigator.pop(c, ImageSource.gallery)),
    ])));
    if (source != null) { await widget.pick(isPerson, source); if (mounted) setState(() {}); }
  }
  void go(int index) => Navigator.push(context, MaterialPageRoute(builder: (_) => AppScreen(index: index, person: widget.person, garment: widget.garment, pick: widget.pick, savedLooks: widget.savedLooks, onSave: widget.onSave)));
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: widget.index == 4 ? null : const BackButton(), title: Text(screenTitles[widget.index], style: const TextStyle(fontWeight: FontWeight.w800))),
    body: _content());
  Widget _content() {
    switch (widget.index) {
      case 0: return _intro('TryOut','Your Style. Your Look.','Try clothes virtually before you buy.', Icons.checkroom, 'Get Started', () => go(1));
      case 1: return _intro('Virtual Try-On Made Easy','Upload your photo, choose clothes and preview your workflow.','Screen 1 of 3', Icons.photo_camera, 'Next', () => go(2));
      case 2: return _intro('Your Wardrobe, Digitally!','Explore categories and keep your favorite looks organized.','Screen 2 of 3', Icons.checkroom, 'Next', () => go(3));
      case 3: return _intro('AI Fashion Try-On','The AI model will be connected in Phase 2 after device testing.','Screen 3 of 3', Icons.auto_awesome, 'Get Started', () => go(4));
      case 4: return HomeScreen(onOpen: go);
      case 5: return _categoryScreen();
      case 6: return _clothingScreen();
      case 7: return _photoScreen(true);
      case 8: return _cropScreen();
      case 9: return _photoScreen(false);
      case 10: return _processingScreen();
      case 11: return _resultScreen();
      case 12: return _editScreen();
      case 13: return _saveShareScreen();
      case 14: return _wardrobeScreen();
      case 15: return _looksScreen();
      case 16: return _profileScreen();
      case 17: return _settingsScreen();
      case 18: return _helpScreen();
      case 19: return _menuScreen();
      case 21: return _proScreen();
      default: return _threeDScreen();
    }
  }
  Widget _intro(String title, String subtitle, String footer, IconData icon, String button, VoidCallback action) => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 130, height: 130, decoration: const BoxDecoration(shape: BoxShape.circle, color: purpleLight), child: Icon(icon, color: purple, size: 68)),
    const SizedBox(height: 28), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 12), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)),
    const SizedBox(height: 22), Text(footer, style: const TextStyle(color: muted, fontSize: 12)),
    const SizedBox(height: 26), SizedBox(width: double.infinity, child: FilledButton(onPressed: action, child: Text(button)))
  ])));
  static const _garmentImages = <String>[
    'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1610030469668-8e9f641aafc8?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1603252110481-7ba873bf42ab?w=600&auto=format&fit=crop',
  ];
  Widget _categoryScreen() => ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 28), children: [
    const Text('Choose Category', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 18),
    Wrap(spacing: 8, children: List.generate(categories.length, (i) => ChoiceChip(label: Text(categories[i]), selected: selectedCategory == i, onSelected: (_) => setState(() => selectedCategory = i)))),
    const SizedBox(height: 22),
    const Text('Explore styles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 12),
    GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: clothes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: .76, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (_, i) {
        final selected = selectedGarment == i;
        return InkWell(
          onTap: () => setState(() => selectedGarment = i),
          borderRadius: BorderRadius.circular(17),
          child: AnimatedContainer(duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(color: const Color(0xFF151625), borderRadius: BorderRadius.circular(17), border: Border.all(color: selected ? purple : const Color(0xFFE6DFFF), width: selected ? 2.5 : 1.2), boxShadow: selected ? [BoxShadow(color: purple.withValues(alpha: .24), blurRadius: 14)] : []),
            child: Stack(children: [
              Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(_garmentImages[i], fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF20172B), child: Icon(_garmentIcon(i), color: purple, size: 44))))),
              Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xCC070812)])))),
              if (selected) const Positioned(top: 8, right: 8, child: CircleAvatar(radius: 13, backgroundColor: purple, child: Icon(Icons.check, size: 17, color: Colors.white))),
              Positioned(left: 6, right: 6, bottom: 10, child: Text(clothes[i], textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))),
            ])));
      }),
    const SizedBox(height: 18),
    FilledButton(onPressed: selectedGarment < 0 ? null : () => go(7), child: const Text('Next: Choose Photo'))
  ]);
  IconData _garmentIcon(int i) => switch (i) {
    0 => Icons.checkroom, 1 => Icons.woman, 2 => Icons.dry_cleaning, 3 => Icons.style,
    4 => Icons.woman_2, 5 => Icons.auto_awesome, 6 => Icons.sports, 7 => Icons.layers, _ => Icons.checkroom
  };
  Widget _clothingScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Select Clothing', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 12), Wrap(spacing: 8, children: ['Tops','Dresses','Jeans'].map((s) => ChoiceChip(label: Text(s), selected: false, onSelected: (_) {})).toList()),
    const SizedBox(height: 18), Container(height: 190, decoration: BoxDecoration(color: const Color(0xFF151625), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE6DFFF))), child: widget.garment.value == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.checkroom, size: 56, color: purple), SizedBox(height: 8), Text('Choose a clothing photo', style: TextStyle(color: ink))])) : ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(widget.garment.value!.path), fit: BoxFit.contain))),
    const SizedBox(height: 14), OutlinedButton.icon(onPressed: () => choosePhoto(false), icon: const Icon(Icons.photo_library), label: const Text('Upload Clothing Photo')),
    const SizedBox(height: 10), FilledButton(onPressed: () => go(9), child: const Text('Next'))
  ]);
  Widget _photoScreen(bool isPerson) {
    final file = isPerson ? widget.person.value : widget.garment.value;
    return ListView(padding: const EdgeInsets.all(18), children: [
      Text(isPerson ? 'Choose Your Photo' : 'Choose Clothing Photo', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
      const SizedBox(height: 6), const Text('Select a photo or take a new one', style: TextStyle(color: muted)),
      const SizedBox(height: 20), InkWell(onTap: () => choosePhoto(isPerson), child: Container(height: 280, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: purple.withValues(alpha: .4))), child: file == null ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 52, color: purple), SizedBox(height: 12), Text('Take Photo', style: TextStyle(color: ink, fontWeight: FontWeight.w800)), Text('or choose from gallery', style: TextStyle(color: muted))]) : ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(file.path), fit: BoxFit.contain)))),
      const SizedBox(height: 14), OutlinedButton.icon(onPressed: () => choosePhoto(isPerson), icon: const Icon(Icons.photo_library), label: const Text('Choose from Gallery')),
      if (file != null) ...[const SizedBox(height: 12), FilledButton(onPressed: () => go(isPerson ? 8 : 10), child: const Text('Next'))]
    ]);
  }
  Widget _cropScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Crop Photo', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 14),
    Container(height: 390, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFF151625), borderRadius: BorderRadius.circular(20)), child: widget.person.value == null ? const Text('Choose a photo first', style: TextStyle(color: muted)) : Image.file(File(widget.person.value!.path), fit: BoxFit.contain)),
    const SizedBox(height: 12), const Text('Preview is available. Fine crop/rotate controls will be added as a separate image-editing implementation.', style: TextStyle(color: muted)),
    const SizedBox(height: 14), FilledButton(onPressed: () => go(9), child: const Text('Done'))
  ]);
  Widget _processingScreen() => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.auto_awesome, color: purple, size: 48), const SizedBox(height: 24),
    const Text('Preparing Your Look', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 18), const SizedBox(width: 68, height: 68, child: CircularProgressIndicator(strokeWidth: 5, color: purple)),
    const SizedBox(height: 22), const Text('AI try-on is not enabled in Phase 1.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.5)),
    const SizedBox(height: 8), const Text('This screen is a UI preview only. No fake result will be generated.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
    const SizedBox(height: 24), FilledButton(onPressed: () => go(11), child: const Text('View Result Screen Preview'))
  ])));
  Widget _resultScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Your Try-On Result', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 14),
    Container(height: 360, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.image_search, color: purple, size: 56), SizedBox(height: 12), Text('Result preview placeholder', style: TextStyle(color: ink, fontWeight: FontWeight.w700)), SizedBox(height: 6), Text('Real output arrives in Phase 2', style: TextStyle(color: muted))]))),
    const SizedBox(height: 12), Row(children: [Expanded(child: OutlinedButton(onPressed: () => go(12), child: const Text('Edit Look'))), const SizedBox(width: 10), Expanded(child: FilledButton(onPressed: () => go(13), child: const Text('Save')))]),
    const SizedBox(height: 10), OutlinedButton(onPressed: () => go(5), child: const Text('Try Another'))
  ]);
  Widget _editScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Edit Look', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 16),
    Container(height: 310, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Center(child: widget.person.value == null ? const Icon(Icons.person, color: purple, size: 80) : Image.file(File(widget.person.value!.path), fit: BoxFit.contain))),
    const SizedBox(height: 14), Wrap(spacing: 8, runSpacing: 8, children: ['Crop','Adjust','Filter','Background'].map((s) => ActionChip(label: Text(s), avatar: const Icon(Icons.tune, size: 16, color: purple), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$s editing will be wired after the UI pass.'))))).toList()),
    const SizedBox(height: 18), FilledButton(onPressed: () => go(13), child: const Text('Save Changes'))
  ]);
  Widget _saveShareScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Save & Share', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 18),
    Container(height: 330, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Center(child: widget.person.value == null ? const Icon(Icons.image, size: 60, color: purple) : Image.file(File(widget.person.value!.path), fit: BoxFit.contain))),
    const SizedBox(height: 14), OutlinedButton.icon(onPressed: () { if (widget.person.value != null) { widget.onSave(widget.person.value!); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo saved to My Looks (source photo only; AI result is not generated).'))); } }, icon: const Icon(Icons.bookmark_add), label: const Text('Save to My Looks')),
    const SizedBox(height: 8), OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share becomes available for generated results in Phase 2.'))), icon: const Icon(Icons.share), label: const Text('Share')),
    const SizedBox(height: 8), FilledButton(onPressed: () => go(15), child: const Text('View My Looks'))
  ]);
  Widget _wardrobeScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('My Wardrobe', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
    Wrap(spacing: 8, children: ['All','Tops','Dresses','Jeans'].map((s) => ChoiceChip(label: Text(s), selected: s == 'All', onSelected: (_) {})).toList()),
    const SizedBox(height: 18), GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 9, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: .8, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => InkWell(onTap: () => choosePhoto(false), child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6DFFF))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.checkroom, size: 38, color: purple), const SizedBox(height: 8), Text(i == 8 ? 'Add New +' : clothes[i], style: const TextStyle(color: ink))])))),
    const SizedBox(height: 12), FilledButton(onPressed: () => choosePhoto(false), child: const Text('Add Clothing Photo'))
  ]);
  Widget _looksScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('My Looks / History', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
    Wrap(spacing: 8, children: ['All','Saved','History'].map((s) => ChoiceChip(label: Text(s), selected: s == 'All', onSelected: (_) {})).toList()),
    const SizedBox(height: 18), if (widget.savedLooks.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Column(children: [Icon(Icons.photo_library_outlined, size: 56, color: purple), SizedBox(height: 12), Text('No saved looks yet', style: TextStyle(fontWeight: FontWeight.w800, color: ink)), SizedBox(height: 6), Text('Save photos here while the AI model is being built in Phase 2.', textAlign: TextAlign.center, style: TextStyle(color: muted))])) else GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: widget.savedLooks.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .7, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(File(widget.savedLooks[i].path), fit: BoxFit.cover))),
    const SizedBox(height: 12), FilledButton(onPressed: () => go(5), child: const Text('Create New Look'))
  ]);
  Widget _proScreen() => ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 28), children: [
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF31105E), Color(0xFF7B1FA2), Color(0xFF180D35)]), border: Border.all(color: const Color(0xFFFFD66B), width: 1.3)), child: Column(children: [
      const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD66B), size: 58),
      const SizedBox(height: 8), const Text('TryOut PRO', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: Colors.white)),
      const SizedBox(height: 6), const Text('Unlock your full style potential', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 20),
      for (final benefit in ['Unlimited virtual try-ons','HD quality results • No watermark','Premium styles and collections','Priority processing','Save looks to your cloud','Ad-free experience']) Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [const Icon(Icons.check_circle, color: Color(0xFFFF4DE1), size: 20), const SizedBox(width: 10), Expanded(child: Text(benefit, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))]))
    ])),
    const SizedBox(height: 18), const Text('Choose your plan', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: _planCard('Monthly','₹499','per month',false)),
      const SizedBox(width: 10), Expanded(child: _planCard('Yearly','₹2,999','₹249/month • save 50%',true))
    ]),
    const SizedBox(height: 12), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF151321), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF40204F))), child: const Text('Subscription UI preview. No payment is being charged and subscription purchase is not connected yet.', style: TextStyle(color: muted, fontSize: 12, height: 1.45))),
    const SizedBox(height: 16), FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PRO billing will be connected after the UI and testing phase.'))), icon: const Icon(Icons.lock_outline), label: const Text('Continue to PRO')),
    const SizedBox(height: 8), Center(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Not now', style: TextStyle(color: muted))))
  ]);
  Widget _planCard(String title, String price, String detail, bool featured) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: featured ? const Color(0xFF271333) : const Color(0xFF151321), borderRadius: BorderRadius.circular(18), border: Border.all(color: featured ? purple : const Color(0xFF40204F), width: featured ? 1.8 : 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (featured) const Text('POPULAR', style: TextStyle(color: purple, fontSize: 10, fontWeight: FontWeight.w900)), Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(price, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)), Text(detail, style: const TextStyle(color: muted, fontSize: 10))]));
  Widget _profileScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Row(children: [CircleAvatar(radius: 28, backgroundColor: purpleLight, child: Icon(Icons.person, color: purple, size: 30)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Guest User', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: ink)), Text('Local profile', style: TextStyle(color: muted))])])),
    const SizedBox(height: 12), for (final item in [(Icons.checkroom,'My Wardrobe',14),(Icons.view_in_ar,'3D View — Rotate Model',20),(Icons.favorite_border,'My Looks',15),(Icons.settings_outlined,'Settings',17),(Icons.help_outline,'Help & Support',18),(Icons.info_outline,'About TryOut',17),(Icons.star_border,'Rate App',17),(Icons.share_outlined,'Share App',13)]) ListTile(leading: Icon(item.$1, color: purple), title: Text(item.$2, style: const TextStyle(color: ink)), trailing: const Icon(Icons.chevron_right), onTap: () => go(item.$3))
  ]);
  Widget _settingsScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Settings', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
    SwitchListTile(value: notifications, activeThumbColor: purple, title: const Text('Notifications', style: TextStyle(color: ink)), subtitle: const Text('Feature updates and reminders', style: TextStyle(color: muted)), onChanged: (v) => setState(() => notifications = v)),
    SwitchListTile(value: darkMode, activeThumbColor: purple, title: const Text('Dark Mode', style: TextStyle(color: ink)), subtitle: const Text('Theme preference preview', style: TextStyle(color: muted)), onChanged: (v) => setState(() => darkMode = v)),
    for (final s in ['Language','Privacy Policy','Terms & Conditions','Clear Cache','About App']) ListTile(leading: const Icon(Icons.chevron_right, color: purple), title: Text(s, style: const TextStyle(color: ink)), onTap: () => showDialog<void>(context: context, builder: (c) => AlertDialog(title: Text(s), content: const Text('This settings destination will be connected in the next implementation pass.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))])))
  ]);
  Widget _helpScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Help & Support', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
    for (final item in [('Frequently Asked Questions','Common questions'),('Contact Us','Get in touch with support'),('Report a Problem','Help us improve')]) Card(color: const Color(0xFF151625), child: ListTile(leading: const Icon(Icons.help_outline, color: purple), title: Text(item.$1, style: const TextStyle(color: ink, fontWeight: FontWeight.w700)), subtitle: Text(item.$2, style: const TextStyle(color: muted)), trailing: const Icon(Icons.chevron_right), onTap: () => showDialog<void>(context: context, builder: (c) => AlertDialog(title: Text(item.$1), content: const Text('Support content will be added before production release.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close'))])))),
    const SizedBox(height: 14), const Center(child: Text('TryOut Support • Phase 1 UI', style: TextStyle(color: muted)))
  ]);
  double _modelAngle = 0;
  Widget _threeDScreen() => StatefulBuilder(builder: (context, setViewerState) {
    return ListView(padding: const EdgeInsets.all(18), children: [
      const Text('3D Model Viewer', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: ink)),
      const SizedBox(height: 6),
      const Text('Drag left or right to explore the front, side and back view.', style: TextStyle(color: muted)),
      const SizedBox(height: 18),
      GestureDetector(
        onHorizontalDragUpdate: (details) => setViewerState(() => _modelAngle = (_modelAngle + details.delta.dx * 0.012) % (2 * 3.141592653589793)),
        child: Container(height: 420, decoration: BoxDecoration(color: const Color(0xFF151625), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE6DFFF))),
          child: Stack(alignment: Alignment.center, children: [
            Positioned(top: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: purpleLight, borderRadius: BorderRadius.circular(20)), child: const Text('360° PREVIEW', style: TextStyle(color: purple, fontSize: 11, fontWeight: FontWeight.w800)))),
            if (widget.person.value != null)
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(_modelAngle),
                child: SizedBox(width: 250, height: 340, child: Image.file(File(widget.person.value!.path), fit: BoxFit.contain)),
              )
            else
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(_modelAngle),
                child: Container(width: 190, height: 290, decoration: BoxDecoration(color: purpleLight, borderRadius: BorderRadius.circular(100)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.accessibility_new, size: 100, color: purple), Text('3D model preview', style: TextStyle(color: ink, fontWeight: FontWeight.w700))])),
              ),
            Positioned(bottom: 16, child: Text('Angle: ${((_modelAngle * 180 / 3.141592653589793) % 360).round()}°', style: const TextStyle(color: muted, fontWeight: FontWeight.w700))),
          ]),
        ),
      ),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => setViewerState(() => _modelAngle = 0), icon: const Icon(Icons.face), label: const Text('Front'))),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton.icon(onPressed: () => setViewerState(() => _modelAngle = 1.57079632679), icon: const Icon(Icons.rotate_90_degrees_ccw), label: const Text('Side'))),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton.icon(onPressed: () => setViewerState(() => _modelAngle = 3.14159265359), icon: const Icon(Icons.sync), label: const Text('Back'))),
      ]),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: () => choosePhoto(true), icon: const Icon(Icons.person_add_alt_1), label: const Text('Load Your Photo')),
      const SizedBox(height: 10),
      const Text('Phase 1 viewer: drag/angle controls and screen UI are implemented, but this is not a true 3D body mesh. Real front/side/back geometry requires a 3D model or reconstruction pipeline, which will be integrated separately after the UI phase.', style: TextStyle(color: muted, height: 1.45, fontSize: 12)),
    ]);
  });
  Widget _menuScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('TryOut', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 8), const Text('Virtual Try-On', style: TextStyle(color: muted)), const SizedBox(height: 20),
    for (final item in [(Icons.home_outlined,'Home',4),(Icons.checkroom,'Try On',5),(Icons.view_in_ar,'3D View — Rotate Model',20),(Icons.grid_view,'My Looks',15),(Icons.checkroom_outlined,'My Wardrobe',14),(Icons.history,'History',15),(Icons.person_outline,'Profile',16),(Icons.settings_outlined,'Settings',17),(Icons.help_outline,'Help & Support',18)]) ListTile(leading: Icon(item.$1, color: purple), title: Text(item.$2, style: const TextStyle(color: ink)), trailing: const Icon(Icons.chevron_right), onTap: () => go(item.$3)),
    const Divider(), ListTile(leading: const Icon(Icons.logout, color: purple), title: const Text('Log out / Guest mode', style: TextStyle(color: ink)), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are using TryOut in guest mode.'))))
  ]);
}
