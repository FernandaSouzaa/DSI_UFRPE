import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Statup name generator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 62, 178, 99),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
        )),
        home: const RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 20);
  bool switchMode = false;

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        final tiles = _saved.map((pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        });
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(context: context, tiles: tiles).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text("Saved suggestions"),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.save_as_outlined),
            tooltip: "Saved suggestions",
          )
        ],
      ),
      body: switchMode
          ? CardMode(
              suggestions: _suggestions, saved: _saved, biggerFont: _biggerFont)
          : DefaultMode(
              suggestions: _suggestions,
              saved: _saved,
              biggerFont: _biggerFont),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            switchMode = !switchMode;
          });
        },
        backgroundColor: const Color.fromARGB(255, 62, 178, 99),
        child: const Icon(Icons.change_circle_outlined),
      ),
    );
  }
}

class DefaultMode extends StatefulWidget {
  final List<WordPair> suggestions;
  final Set<WordPair> saved;
  final TextStyle biggerFont;
  const DefaultMode(
      {super.key,
      required this.suggestions,
      required this.saved,
      required this.biggerFont});

  @override
  State<DefaultMode> createState() => _DefaultModeState();
}

class _DefaultModeState extends State<DefaultMode> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;
        if (index >= widget.suggestions.length) {
          widget.suggestions.addAll(generateWordPairs().take(10));
        }
        final alreadySaved = widget.saved.contains(widget.suggestions[index]);
        return ListTile(
          title: Text(
            widget.suggestions[index].asPascalCase,
            style: widget.biggerFont,
          ),
          trailing: InkWell(
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  widget.saved.remove(widget.suggestions[index]);
                } else {
                  widget.saved.add(widget.suggestions[index]);
                }
              });
            },
            child: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color:
                  alreadySaved ? const Color.fromARGB(255, 202, 35, 29) : null,
              semanticLabel: alreadySaved ? "Remove from saved" : "Save",
            ),
          ),
        );
      },
    );
  }
}

class CardMode extends StatefulWidget {
  final List<WordPair> suggestions;
  final Set<WordPair> saved;
  final TextStyle biggerFont;

  const CardMode(
      {super.key,
      required this.suggestions,
      required this.saved,
      required this.biggerFont});

  @override
  State<CardMode> createState() => _CardModeState();
}

class _CardModeState extends State<CardMode> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: const EdgeInsets.all(15),
      itemBuilder: ((context, i) {
        if (i >= widget.suggestions.length - 1) {
          widget.suggestions.addAll(generateWordPairs().take(10));
        }
        final alreadySaved = widget.saved.contains(widget.suggestions[i]);
        return Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                height: 160,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 62, 178, 99), width: 1)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            widget.suggestions[i].asPascalCase,
                            style: widget.biggerFont,
                          ),
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    if (alreadySaved) {
                                      widget.saved
                                          .remove(widget.suggestions[i]);
                                    } else {
                                      widget.saved.add(widget.suggestions[i]);
                                    }
                                  });
                                },
                                icon: Icon(
                                  alreadySaved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: alreadySaved
                                      ? const Color.fromARGB(255, 202, 35, 29)
                                      : const Color.fromARGB(255, 62, 178, 99),
                                ),
                                label: Text(
                                  alreadySaved ? 'Saved' : 'Save',
                                  style: TextStyle(
                                    color: alreadySaved
                                        ? const Color.fromARGB(255, 202, 35, 29)
                                        : const Color.fromARGB(
                                            255, 62, 178, 99),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
