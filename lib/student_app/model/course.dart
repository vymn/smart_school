import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Course({required this.id, required this.title, required this.lessons});

  @override
  List<Object?> get props => [title, lessons, id];

//   from map and to map functions
  static Course fromMap(Map<String, dynamic> map) => Course(
        id: map['id'],
        title: map['title'],
        lessons: map['lessons']
            .map((lessonMap) => Lesson.fromMap(lessonMap))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'lessons': lessons.map((lesson) => lesson.toMap()).toList(),
      };
}

class Lesson extends Equatable {
  final String title;
  final String videoUrl;
  final bool? isPlaying;
  const Lesson({
    required this.title,
    required this.videoUrl,
    this.isPlaying,
  });

  @override
  List<Object?> get props => [title, videoUrl];

//   from map and to map functions
  static Lesson fromMap(Map<String, dynamic> map) => Lesson(
        title: map['title'],
        videoUrl: map['videoUrl'],
        isPlaying: false,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'videoUrl': videoUrl,
      };
}
