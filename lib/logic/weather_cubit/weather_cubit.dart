import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_state.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> getWeather({String? city}) async {
    emit(WeatherLoading());
    try {
      // 1. إذا قام المستخدم بالبحث عن مدينة معينة يدوياً
      if (city != null && city.isNotEmpty) {
        final weather = await repository.fetchWeather(city);
        emit(WeatherSuccess(weather));
        return;
      }

      // 2. عند فتح التطبيق لأول مرة:
      // نطلب بيانات "القاهرة" فوراً كعرض مؤقت سريع جداً لكسر شاشة التحميل
      try {
        final quickWeather = await repository.fetchWeather("Cairo");
        emit(WeatherSuccess(quickWeather));
      } catch (_) {
        // في حال فشل طلب القاهرة المبدئي (مشكلة إنترنت مثلاً)
      }

      // 3. الآن نحاول جلب الموقع الحقيقي للمستخدم في الخلفية
      // إذا نجح، سيتم تحديث الشاشة ببيانات مدينته الحقيقية تلقائياً
      final positionWeather = await repository.fetchWeather(null);
      emit(WeatherSuccess(positionWeather));

    } catch (e) {
      // إذا لم نكن قد عرضنا بيانات القاهرة بنجاح وفشل كل شيء، نظهر الخطأ
      if (state is! WeatherSuccess) {
        emit(WeatherFailure("تأكد من اتصالك بالإنترنت أو تفعيل الموقع"));
      }
    }
  }
}