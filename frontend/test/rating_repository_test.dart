import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_rating_repository.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';

void main() {
  group('RatingRepository', () {
    late ImplRatingRepository ratingRepository;
    late User john;
    late User emma;

    setUp(() {
      ratingRepository = ImplRatingRepository();
      john = User(id: 0, firstName: "John", lastName: "Doe", points: 150);
      emma = User(id: 101, firstName: "Emma", lastName: "Watson", points: 120);
    });
    test('initial ratings are present for john', () async {
      final ratings = await ratingRepository.fetch(john);
      expect(ratings.length, 5);
      expect(ratings.every((r) => r.toUser.id == john.id), isTrue);
      expect(
        ratings.map((r) => r.comment),
        containsAll([
          "Very punctual and friendly driver!",
          "Good conversation, made the journey enjoyable",
          "Great music selection and comfortable ride",
          "Safe driver, would ride again",
          "Very professional and friendly",
        ]),
      );
    });

    test('fetch returns all ratings for a user', () async {
      final ratings = await ratingRepository.fetch(john);
      expect(ratings, isNotEmpty);
      expect(ratings.every((r) => r.toUser.id == john.id), isTrue);
    });

    test('create adds a new rating', () async {
      final newUser = User(
        id: 200,
        firstName: "Test",
        lastName: "User",
        points: 50,
      );
      final rating = Rating(
        id: 999,
        fromUser: newUser,
        toUser: john,
        stars: 5,
        comment: "Excellent!",
      );
      await ratingRepository.create(rating);
      final ratings = await ratingRepository.fetch(john);
      expect(ratings.any((r) => r.id == 999), isTrue);
    });

    test('create fails for duplicate rating id', () async {
      final rating = Rating(
        id: 1000,
        fromUser: emma,
        toUser: john,
        stars: 4,
        comment: "Duplicate",
      );
      await ratingRepository.create(rating);
      await expectLater(
        () async =>
            await ratingRepository.create(rating), //create the rating again
        throwsException,
      );
    });

    test('update modifies an existing rating', () async {
      final ratings = await ratingRepository.fetch(john);
      final rating = ratings.first;
      final updated = Rating(
        id: rating.id,
        fromUser: rating.fromUser,
        toUser: rating.toUser,
        stars: 3,
        comment: "Updated comment",
      );
      await ratingRepository.update(updated);
      final updatedRatings = await ratingRepository.fetch(john);
      expect(updatedRatings.any((r) => r.comment == "Updated comment"), isTrue);
    });

    test('delete removes a rating', () async {
      final ratings = await ratingRepository.fetch(john);
      final rating = ratings.first;
      await ratingRepository.delete(rating);
      final afterDelete = await ratingRepository.fetch(john);
      expect(afterDelete.any((r) => r.id == rating.id), isFalse);
    });
    test('does not allow duplicate rating IDs', () async {
      final rating = Rating(
        id: 3000,
        fromUser: emma,
        toUser: john,
        stars: 5,
        comment: "First rating",
      );
      await ratingRepository.create(rating);

      final duplicateRating = Rating(
        id: 3000, // same ID as above
        fromUser: john,
        toUser: emma,
        stars: 2,
        comment: "Duplicate rating",
      );

      expect(
        () async => await ratingRepository.create(duplicateRating),
        throwsException,
      );
    });
    test('watch emits ratings updates', () async {
      final newUser = User(
        id: 201,
        firstName: "Watcher",
        lastName: "User",
        points: 60,
      );
      final rating = Rating(
        id: 2000,
        fromUser: newUser,
        toUser: john,
        stars: 5,
        comment: "Watched!",
      );
      final stream = ratingRepository.watch(john);
      final future = expectLater(
        stream,
        emits(
          predicate<List<Rating>>(
            (ratings) => ratings.any((r) => r.id == 2000),
          ),
        ),
      );

      await ratingRepository.create(rating);
      await future;
    });
  });
}
