import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/widgets/neopop_button.dart';

/// A screen demonstrating various NeoPop UI components.
class NeoPopExampleScreen extends StatelessWidget {
  /// Creates a NeoPopExampleScreen.
  const NeoPopExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeoPop Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionTitle(title: 'Elevated Buttons'),

              // Basic NeoPop button
              CustomNeoPopButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Basic button pressed!')),
                  );
                },
                color: Colors.blue,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    'Basic Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // NeoPop button with custom depth
              CustomNeoPopButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deep button pressed!')),
                  );
                },
                color: Colors.green,
                depth: 10,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    'Deep Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _SectionTitle(title: 'Flat Buttons'),

              // Flat NeoPop button
              CustomNeoPopButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Flat button pressed!')),
                  );
                },
                color: Colors.amber,
                buttonPosition: Position.center,
                parentColor: Colors.grey.shade200,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    'Flat Button',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _SectionTitle(title: 'Buttons with Borders'),

              // NeoPop button with border
              CustomNeoPopButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bordered button pressed!')),
                  );
                },
                color: Colors.orange,
                border: Border.all(color: Colors.red, width: 2),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    'Bordered Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Flat button with border
              CustomNeoPopButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Flat bordered button pressed!'),
                    ),
                  );
                },
                color: Colors.black,
                buttonPosition: Position.center,
                border: Border.all(color: Colors.white, width: 2),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    'Flat Bordered Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _SectionTitle(title: 'Special Effects'),

              // NeoPop button with shimmer effect
              CustomNeoPopButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shimmer button pressed!')),
                  );
                },
                color: Colors.purple,
                shimmer: true,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    'Shimmer Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _SectionTitle(title: 'Adjacent Buttons'),

              // Horizontally adjacent buttons
              Row(
                children: [
                  Expanded(
                    child: CustomNeoPopButton(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Left button pressed!')),
                        );
                      },
                      color: Colors.blue,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Left',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomNeoPopButton(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Right button pressed!'),
                          ),
                        );
                      },
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Right',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Vertically adjacent buttons
              Column(
                children: [
                  CustomNeoPopButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Top button pressed!')),
                      );
                    },
                    color: Colors.teal,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Top Button',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomNeoPopButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bottom button pressed!')),
                      );
                    },
                    color: Colors.indigo,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          'Bottom Button',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A section title widget for the example screen.
class _SectionTitle extends StatelessWidget {
  /// Creates a section title.
  const _SectionTitle({required this.title});

  /// The title text.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
