import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'try_on_service.dart';

void main() => runApp(const TryOutApp());

const ink = Color(0xFF080B16);
const panel = Color(0xFF12182A);
const purple = Color(0xFF9B4DFF);
const pink = Color(0xFFFF4FC8);
const muted = Color(0xFF9CA7C2);

class TryOutApp extends StatelessWidget {
  const TryOutApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TryOut',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ink,
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark),
      fontFamily: 'Roboto',
    ),
    home: const MainShell(),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final person = ValueNotifier<XFile?>(null);
  final garment = ValueNotifier<XFile?>(null);
  final picker = ImagePicker();

  Future<void> pick(bool isPerson, ImageSource source) async {
    final file = await picker.pickImage(source: source, maxWidth: 1200, maxHeight: 1600, imageQuality: 92);
    if (file == null || !mounted) return;
    (isPerson ? person : garment).value = file;
    if (isPerson) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your photo is selected. Now choose a garment.')));
    }
  }

  @override
  void dispose() { person.dispose(); garment.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onTry: () => setState(() => tab = 1)),
      TryOnPage(person: person, garment: garment, onPick: pick),
      const LooksPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0D1120),
        indicatorColor: purple.withValues(alpha: .22),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.checkroom_outlined), selectedIcon: Icon(Icons.checkroom), label: 'Try On'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'My Looks'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onTry;
  const HomePage({super.key, required this.onTry});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 28), children: [
    Row(children: [
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TryOut', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -.8)),
        Text('AI VIRTUAL TRY-ON', style: TextStyle(fontSize: 10, color: muted, letterSpacing: 2.2, fontWeight: FontWeight.w700)),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20), border: Border.all(color: purple.withValues(alpha: .55))), child: const Row(children: [Icon(Icons.auto_awesome, color: pink, size: 16), SizedBox(width: 6), Text('0 credits')]))
    ]),
    const SizedBox(height: 24),
    Container(
      padding: const EdgeInsets.all(22), height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF34205F), Color(0xFF17142F), Color(0xFF111827)]),
        border: Border.all(color: purple.withValues(alpha: .35)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.auto_awesome, color: pink, size: 28),
        const Spacer(),
        const Text('Your next look,\nreimagined.', style: TextStyle(fontSize: 29, height: 1.12, fontWeight: FontWeight.w800)),
        const SizedBox(height: 9),
        const Text('Try outfits on your photo.', style: TextStyle(color: Color(0xFFD0C8E7))),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: onTry, icon: const Icon(Icons.arrow_forward), label: const Text('Start virtual try-on')),
      ]),
    ),
    const SizedBox(height: 26),
    const SectionTitle('How it works', trailing: '3 simple steps'),
    const SizedBox(height: 12),
    const Row(children: [
      Expanded(child: StepTile(icon: Icons.person_outline, title: 'Your photo', subtitle: 'Choose a photo')),
      SizedBox(width: 10),
      Expanded(child: StepTile(icon: Icons.checkroom, title: 'Pick clothes', subtitle: 'Select a garment')),
      SizedBox(width: 10),
      Expanded(child: StepTile(icon: Icons.auto_awesome, title: 'Try it on', subtitle: 'Create your look')),
    ]),
    const SizedBox(height: 24),
    const SectionTitle('Explore styles', trailing: 'Coming soon'),
    const SizedBox(height: 12),
    const Wrap(spacing: 8, runSpacing: 8, children: [
      StyleChip(label: 'Casual', icon: Icons.weekend_outlined),
      StyleChip(label: 'Formal', icon: Icons.work_outline),
      StyleChip(label: 'Party', icon: Icons.celebration_outlined),
      StyleChip(label: 'Streetwear', icon: Icons.bolt_outlined),
    ]),
    const SizedBox(height: 18),
    const Text('On-device AI support is being validated for 4 GB RAM phones. Real try-on generation will be enabled only after the model passes device testing.', style: TextStyle(color: muted, fontSize: 12, height: 1.45)),
  ]);
}

class TryOnPage extends StatefulWidget {
  final ValueNotifier<XFile?> person;
  final ValueNotifier<XFile?> garment;
  final Future<void> Function(bool, ImageSource) onPick;
  const TryOnPage({super.key, required this.person, required this.garment, required this.onPick});
  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  final _service = TryOnService();
  bool _processing = false;
  String? _error;
  Uri? _result;

  Future<void> _generate() async {
    final personFile = widget.person.value;
    final garmentFile = widget.garment.value;
    if (personFile == null || garmentFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose both photos first.')));
      return;
    }
    setState(() { _processing = true; _error = null; _result = null; });
    try {
      final result = await _service.generate(person: personFile, garment: garmentFile);
      if (!mounted) return;
      setState(() => _result = result);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Create your look', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
    const SizedBox(height: 6),
    const Text('Add a person photo and a clothing photo.', style: TextStyle(color: muted)),
    const SizedBox(height: 22),
    ValueListenableBuilder<XFile?>(valueListenable: widget.person, builder: (context, file, _) => PhotoPickerCard(title: 'Your photo', subtitle: 'Full body works best', icon: Icons.person_outline, file: file, onTap: () => _sourceSheet(context, true))),
    const SizedBox(height: 14),
    ValueListenableBuilder<XFile?>(valueListenable: widget.garment, builder: (context, file, _) => PhotoPickerCard(title: 'Clothing photo', subtitle: 'Use a clear front view', icon: Icons.checkroom, file: file, onTap: () => _sourceSheet(context, false))),
    const SizedBox(height: 24),
    FilledButton.icon(
      onPressed: _processing ? null : _generate,
      icon: _processing
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.auto_awesome),
      label: Text(_processing ? 'Generating your look…' : 'Generate try-on'),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
    ),
    if (_processing) ...[
      const SizedBox(height: 12),
      const Text('AI is processing your photos. This may take a little while.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
    ],
    if (_error != null) ...[
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF321D2A), borderRadius: BorderRadius.circular(14)), child: Text(_error!, style: const TextStyle(color: Color(0xFFFFB9C6)))),
    ],
    if (_result != null) ...[
      const SizedBox(height: 22),
      const Text('Your generated look', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(_result.toString(), fit: BoxFit.contain, loadingBuilder: (context, child, progress) => progress == null ? child : const SizedBox(height: 240, child: Center(child: CircularProgressIndicator())), errorBuilder: (context, error, stack) => const Padding(padding: EdgeInsets.all(18), child: Text('The generated image could not be loaded. Please try again.')))),
      const SizedBox(height: 8),
      const Text('AI-generated preview. Fit and size are not guaranteed.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
    ],
    const SizedBox(height: 12),
    const Text('Your selected photos are sent to the AI provider through the TryOut server to generate this result.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
  ]);

  void _sourceSheet(BuildContext context, bool isPerson) {
    showModalBottomSheet<void>(context: context, backgroundColor: panel, builder: (ctx) => SafeArea(child: Padding(
      padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(isPerson ? 'Choose your photo' : 'Choose clothing photo', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        ListTile(leading: const Icon(Icons.photo_library_outlined), title: const Text('Gallery'), onTap: () { Navigator.pop(ctx); widget.onPick(isPerson, ImageSource.gallery); }),
        ListTile(leading: const Icon(Icons.camera_alt_outlined), title: const Text('Camera'), onTap: () { Navigator.pop(ctx); widget.onPick(isPerson, ImageSource.camera); }),
      ]),
    )));
  }
}

class PhotoPickerCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final XFile? file;
  final VoidCallback onTap;
  const PhotoPickerCard({super.key, required this.title, required this.subtitle, required this.icon, required this.file, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(22),
    child: Container(
      height: 190, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22), border: Border.all(color: purple.withValues(alpha: .32))),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: pink, size: 26), const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4), Text(file?.name ?? subtitle, style: const TextStyle(color: muted, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12), const Text('Tap to select  →', style: TextStyle(color: Color(0xFFC9A8FF), fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(width: 12),
        ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: 112, height: 150, child: file == null
          ? Container(color: const Color(0xFF20263B), child: Icon(icon, size: 42, color: muted))
          : Image.file(File(file!.path), fit: BoxFit.cover))),
      ]),
    ),
  );
}

class LooksPage extends StatelessWidget {
  const LooksPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Padding(padding: EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.photo_library_outlined, size: 54, color: purple),
    SizedBox(height: 16), Text('Your looks will live here', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
    SizedBox(height: 8), Text('Once real on-device try-on is integrated, you can save and revisit your generated looks.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.5)),
  ])));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22)), child: const Row(children: [
      CircleAvatar(radius: 28, backgroundColor: Color(0xFF34205F), child: Icon(Icons.person, color: Colors.white, size: 30)),
      SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Guest user', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('Local-first mode', style: TextStyle(color: muted))])),
    ])),
    const SizedBox(height: 18),
    const SettingsRow(icon: Icons.lock_outline, title: 'Privacy', subtitle: 'Photos stay on device in this build'),
    const SettingsRow(icon: Icons.memory_outlined, title: 'AI engine', subtitle: '4 GB device feasibility validation'),
    const SettingsRow(icon: Icons.info_outline, title: 'About TryOut', subtitle: 'Early development build'),
  ]);
}

class SectionTitle extends StatelessWidget {
  final String title, trailing;
  const SectionTitle(this.title, {super.key, required this.trailing});
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), Text(trailing, style: const TextStyle(color: muted, fontSize: 11))]);
}
class StepTile extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const StepTile({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: pink), const SizedBox(height: 12), Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: muted, fontSize: 10))]));
}
class StyleChip extends StatelessWidget {
  final String label; final IconData icon;
  const StyleChip({super.key, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Chip(avatar: Icon(icon, size: 16, color: pink), label: Text(label), backgroundColor: panel, side: BorderSide(color: purple.withValues(alpha: .3)));
}
class SettingsRow extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const SettingsRow({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 4), leading: Icon(icon, color: pink), title: Text(title), subtitle: Text(subtitle, style: const TextStyle(color: muted)), trailing: const Icon(Icons.chevron_right));
}
