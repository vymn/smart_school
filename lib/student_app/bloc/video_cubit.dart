import 'package:bloc/bloc.dart';

class VideoCubit extends Cubit<String?> {
  VideoCubit() : super(null);

  void playVideo(String videoUrl) {
    emit(videoUrl); // Emits the video URL for playback
  }

  void stopVideo() {
    emit(null); // Stops the video
  }
}
