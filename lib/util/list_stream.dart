import 'package:rxdart/subjects.dart';
//how does the firebase stream get added to this one?
//if it is instantiated separately how do you dispose of it?

class ListStream<Element> {
  final BehaviorSubject<List<Element>> _subject = BehaviorSubject();
  List<Element> _items;

  ListStream({List<Element> items}) : _items = items ?? [];

  List<Element> get items {
    return _items;
  }

  Stream<List<Element>> get stream {
    return _subject.stream;
  }

  void insert({Element item}) {
    _items.add(item);
    _subject.add(List.unmodifiable(_items));
  }

  void insertAll({List<Element> items}) {
    _items.addAll(items);
    _subject.add(List.unmodifiable(_items));
  }

  void remove({Element item}) {
    _items.remove(item);
    _subject.add(List.unmodifiable(_items));
  }

  void map(Element Function(Element) closure) {
    _items = _items.map(closure).toList();
    _subject.add(List.unmodifiable(_items));
  }

  void removeAll() {
    _items = [];
    _subject.add(List.unmodifiable(_items));
  }

  dispose() {
    _subject.close();
  }
}
