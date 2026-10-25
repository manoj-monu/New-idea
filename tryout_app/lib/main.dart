import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const TryOutApp());

const purple = Color(0xFF5420C8);
const purpleLight = Color(0xFFF0E9FF);
const ink = Color(0xFF17123A);
const muted = Color(0xFF77758D);
const pageBg = Color(0xFFFAF9FF);
const categories = ['Women', 'Men', 'Kids'];
const clothes = ['Tops', 'Dresses', 'Jeans', 'Jackets', 'Sarees', 'Traditional', 'Sportswear', 'Innerwear', 'Shirts'];
const screenTitles = ['Splash Screen','Onboarding 1','Onboarding 2','Onboarding 3','Home Screen','Choose Category','Select Clothing','Choose Your Photo','Crop Photo','Choose Clothing Photo','Processing','Try-On Result','Edit Look','Save & Share','My Wardrobe','My Looks / History','Profile','Settings','Help & Support','Side Menu','3D View'];

class TryOutApp extends StatelessWidget {
  const TryOutApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'TryOut', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: pageBg,
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
      appBarTheme: const AppBarTheme(backgroundColor: pageBg, foregroundColor: ink),
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
    onSave: (file) { setState(() { if (!savedLooks.any((f) => f.path == file.path)) savedLooks.add(file); }); }));
  @override void dispose() { person.dispose(); garment.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: IndexedStack(index: tab, children: [
      HomeScreen(onOpen: open),
      AppScreen(index: 5, person: person, garment: garment, pick: pick, savedLooks: savedLooks, onSave: (f) { setState(() { if (!savedLooks.any((x) => x.path == f.path)) savedLooks.add(f); }); }),
      AppScreen(index: 15, person: person, garment: garment, pick: pick, savedLooks: savedLooks, onSave: (_) {}),
      AppScreen(index: 16, person: person, garment: garment, pick: pick, savedLooks: savedLooks, onSave: (_) {}),
    ])),
    bottomNavigationBar: NavigationBar(backgroundColor: Colors.white, indicatorColor: purpleLight, selectedIndex: tab,
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
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(18, 16, 18, 28), children: [
    Row(children: [const Icon(Icons.checkroom, color: purple, size: 30), const SizedBox(width: 8),
      const Expanded(child: Text('TryOut', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink))),
      IconButton(onPressed: () => onOpen(19), icon: const Icon(Icons.menu, color: ink))]),
    Container(height: 225, margin: const EdgeInsets.only(top: 10), padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFF32108F), Color(0xFF8A43E8)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Virtual Try-On', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8), const Text('Try clothes before you buy', style: TextStyle(color: Colors.white70)),
        const Spacer(), Align(alignment: Alignment.bottomLeft, child: FilledButton(onPressed: () => onOpen(5), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: purple), child: const Text('Try Now  →')))
      ])),
    const SizedBox(height: 24), const Text('Quick Actions', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 12), Row(children: [
      Expanded(child: ActionCard(icon: Icons.auto_awesome, title: 'Try On Clothes', onTap: () => onOpen(5))),
      const SizedBox(width: 8), Expanded(child: ActionCard(icon: Icons.photo_library_outlined, title: 'My Photos', onTap: () => onOpen(7))),
      const SizedBox(width: 8), Expanded(child: ActionCard(icon: Icons.favorite_border, title: 'My Looks', onTap: () => onOpen(15))),
    ]),
    const SizedBox(height: 24), const Text('Popular Categories', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 12), Wrap(spacing: 8, runSpacing: 8, children: ['Women','Men','Kids','Traditional'].map((s) => ActionChip(label: Text(s), avatar: const Icon(Icons.checkroom, size: 18, color: purple), onPressed: () => onOpen(6))).toList()),
    const SizedBox(height: 20), const Text('Phase 1: screens and navigation. Real AI generation will be integrated in Phase 2; this build never fabricates a try-on result.', style: TextStyle(color: muted, height: 1.45)),
  ]);
}
class ActionCard extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const ActionCard({super.key, required this.icon, required this.title, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18),
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE6DFFF))),
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
  Widget _categoryScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Choose Category', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 18),
    Wrap(spacing: 8, children: List.generate(categories.length, (i) => ChoiceChip(label: Text(categories[i]), selected: selectedCategory == i, onSelected: (_) => setState(() => selectedCategory = i))),
    const SizedBox(height: 22), const Text('Explore styles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 12), GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: clothes.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: .82, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => InkWell(onTap: () { selectedGarment = i; go(6); }, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6DFFF))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.checkroom, color: purple, size: 38), const SizedBox(height: 8), Text(clothes[i], style: const TextStyle(color: ink, fontWeight: FontWeight.w600))])))),
    const SizedBox(height: 18), FilledButton(onPressed: () => go(7), child: const Text('Next: Choose Photo'))
  ]);
  Widget _clothingScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Select Clothing', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 12), Wrap(spacing: 8, children: ['Tops','Dresses','Jeans'].map((s) => ChoiceChip(label: Text(s), selected: false, onSelected: (_) {})).toList()),
    const SizedBox(height: 18), Container(height: 190, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE6DFFF))), child: widget.garment.value == null ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.checkroom, size: 56, color: purple), SizedBox(height: 8), Text('Choose a clothing photo', style: TextStyle(color: ink))])) : ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(widget.garment.value!.path), fit: BoxFit.contain))),
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
    Container(height: 390, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: widget.person.value == null ? const Text('Choose a photo first', style: TextStyle(color: muted)) : Image.file(File(widget.person.value!.path), fit: BoxFit.contain)),
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
    const SizedBox(height: 14), Wrap(spacing: 8, runSpacing: 8, children: ['Crop','Adjust','Filter','Background'].map((s) => ActionChip(label: Text(s), avatar: const Icon(Icons.tune, size: 16, color: purple), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$s editing will be wired after the UI pass.')))).toList()),
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
  Widget _profileScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Row(children: [CircleAvatar(radius: 28, backgroundColor: purpleLight, child: Icon(Icons.person, color: purple, size: 30)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Guest User', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: ink)), Text('Local profile', style: TextStyle(color: muted))])])),
    const SizedBox(height: 12), for (final item in [(Icons.checkroom,'My Wardrobe',14),(Icons.view_in_ar,'3D View — Rotate Model',20),(Icons.favorite_border,'My Looks',15),(Icons.settings_outlined,'Settings',17),(Icons.help_outline,'Help & Support',18),(Icons.info_outline,'About TryOut',17),(Icons.star_border,'Rate App',17),(Icons.share_outlined,'Share App',13)]) ListTile(leading: Icon(item.$1, color: purple), title: Text(item.$2, style: const TextStyle(color: ink)), trailing: const Icon(Icons.chevron_right), onTap: () => go(item.$3))
  ]);
  Widget _settingsScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Settings', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
    SwitchListTile(value: notifications, activeColor: purple, title: const Text('Notifications', style: TextStyle(color: ink)), subtitle: const Text('Feature updates and reminders', style: TextStyle(color: muted)), onChanged: (v) => setState(() => notifications = v)),
    SwitchListTile(value: darkMode, activeColor: purple, title: const Text('Dark Mode', style: TextStyle(color: ink)), subtitle: const Text('Theme preference preview', style: TextStyle(color: muted)), onChanged: (v) => setState(() => darkMode = v)),
    for (final s in ['Language','Privacy Policy','Terms & Conditions','Clear Cache','About App']) ListTile(leading: const Icon(Icons.chevron_right, color: purple), title: Text(s, style: const TextStyle(color: ink)), onTap: () => showDialog<void>(context: context, builder: (c) => AlertDialog(title: Text(s), content: const Text('This settings destination will be connected in the next implementation pass.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))])))
  ]);
  Widget _helpScreen() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Help & Support', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
    for (final item in [('Frequently Asked Questions','Common questions'),('Contact Us','Get in touch with support'),('Report a Problem','Help us improve')]) Card(color: Colors.white, child: ListTile(leading: const Icon(Icons.help_outline, color: purple), title: Text(item.$1, style: const TextStyle(color: ink, fontWeight: FontWeight.w700)), subtitle: Text(item.$2, style: const TextStyle(color: muted)), trailing: const Icon(Icons.chevron_right), onTap: () => showDialog<void>(context: context, builder: (c) => AlertDialog(title: Text(item.$1), content: const Text('Support content will be added before production release.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close'))])))),
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
        child: Container(height: 420, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE6DFFF))),
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
