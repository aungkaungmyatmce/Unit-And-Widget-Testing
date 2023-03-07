import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_and_widget_testing/article.dart';
import 'package:unit_and_widget_testing/news_change_notifier.dart';
import 'package:unit_and_widget_testing/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test('Initial values are correct', () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group('Get articals', () {
    final articlesFromService = [
      Article(title: 'Test 1', content: 'Text 1 content'),
      Article(title: 'Test 2', content: 'Text 2 content'),
      Article(title: 'Test 3', content: 'Text 3 content'),
    ];

    void arrangeNewsServiceReturnsArticles() {
      when(() => mockNewsService.getArticles())
          .thenAnswer((_) async => articlesFromService);
    }

    test('get articles using the NewsService', () async {
      arrangeNewsServiceReturnsArticles();
      await sut.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test('indicate loading of data', () async {
      arrangeNewsServiceReturnsArticles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles, articlesFromService);
      expect(sut.isLoading, false);
    });
  });
}
