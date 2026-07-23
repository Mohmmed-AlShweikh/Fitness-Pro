import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  final elapsed = Duration.zero.obs;
  final isRunning = false.obs;
  final restSeconds = 60.obs;
  final restTotalSeconds = 60.obs; // track total for progress ring
  final restRunning = false.obs;

  Timer? _workoutTimer;
  Timer? _restTimer;

  void startWorkout() {
    isRunning.value = true;
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed.value += const Duration(seconds: 1);
    });
  }

  void pauseWorkout() {
    isRunning.value = false;
    _workoutTimer?.cancel();
  }

  void resetWorkout() {
    pauseWorkout();
    elapsed.value = Duration.zero;
  }

  void startRest({int seconds = 60}) {
    restTotalSeconds.value = seconds;
    restSeconds.value = seconds;
    restRunning.value = true;
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (restSeconds.value > 0) {
        restSeconds.value--;
      } else {
        restRunning.value = false;
        _restTimer?.cancel();
        Get.snackbar('⏰', 'rest_time_up'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
      }
    });
  }

  void stopRest() {
    restRunning.value = false;
    restSeconds.value = restTotalSeconds.value;
    _restTimer?.cancel();
  }

  String get formattedElapsed {
    final h = elapsed.value.inHours;
    final m = elapsed.value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = elapsed.value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void onClose() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    super.onClose();
  }
}
