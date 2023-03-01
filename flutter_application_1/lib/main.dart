import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

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
          backgroundColor: Color.fromARGB(255, 23, 211, 155),
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
  final _biggerFont = const TextStyle(fontSize: 18);
  bool switchMode = false;

  void pushSaved() {
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
            title: const Text("Saved Suggestions"),
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
            onPressed: pushSaved,
            icon: const Icon(Icons.list),
            tooltip: "Saved Suggestions",
          )
        ],
      ),
      body: switchMode
          ? CardMode(
              suggestions: _suggestions, saved: _saved, biggerFont: _biggerFont)
          : ListMode(
              suggestions: _suggestions,
              saved: _saved,
              biggerFont: _biggerFont),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            switchMode = !switchMode;
          });
        },
        backgroundColor: const Color.fromARGB(255, 23, 211, 155),
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

class ListMode extends StatefulWidget {
  final List<WordPair> suggestions;
  final Set<WordPair> saved;
  final TextStyle biggerFont;
  const ListMode(
      {super.key,
      required this.suggestions,
      required this.saved,
      required this.biggerFont});

  @override
  State<ListMode> createState() => ListModeState();
}

class ListModeState extends State<ListMode> {
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
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? const Color.fromARGB(255, 210, 22, 22) : null,
            semanticLabel: alreadySaved ? "Remove from saved" : "Save",
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                widget.saved.remove(widget.suggestions[index]);
              } else {
                widget.saved.add(widget.suggestions[index]);
              }
            });
          },
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
  State<CardMode> createState() => CardModeState();
}

class CardModeState extends State<CardMode> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: ((context, i) {
          if (i >= widget.suggestions.length - 1) {
            widget.suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = widget.saved.contains(widget.suggestions[i]);
          return Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  height: 200,
                  width: double.maxFinite,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (alreadySaved) {
                          widget.saved.remove(widget.suggestions[i]);
                        } else {
                          widget.saved.add(widget.suggestions[i]);
                        }
                      });
                    },
                    child: Card(
                      elevation: 6,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("${widget.suggestions[i]} Card",
                              style: widget.biggerFont),
                          Icon(
                            alreadySaved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: alreadySaved
                                ? const Color.fromARGB(255, 210, 22, 22)
                                : null,
                            semanticLabel:
                                alreadySaved ? "Remove from saved" : "Save",
                          )
                        ],
                      )),
                    ),
                  ),
                ),
              )
            ],
          );
        }));
  }
}
