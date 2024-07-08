// room_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';
import '../models/image_model.dart';

class RoomState {
  final bool isLoading;
  final bool hasError;
  final List<ImageModel> images;
  final bool showFloatingButton;

  const RoomState({
    required this.isLoading,
    required this.hasError,
    required this.images,
    required this.showFloatingButton,
  });

  factory RoomState.initial() {
    return const RoomState(
      isLoading: false,
      hasError: false,
      images: [],
      showFloatingButton: false,
    );
  }

  RoomState copyWith({
    bool? isLoading,
    bool? hasError,
    List<ImageModel>? images,
    bool? showFloatingButton,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      images: images ?? this.images,
      showFloatingButton: showFloatingButton ?? this.showFloatingButton,
    );
  }
}

class RoomCubit extends Cubit<RoomState> {
  RoomCubit() : super(RoomState.initial());

  Future<void> fetchImages(String complexity, String texture, String color) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await http.get(Uri.parse(
          '${Config.baseUrl}/api/v1/outputimage/getAllDataByAllValue/$complexity/$texture/$color'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ImageModel> images = data.map((item) => ImageModel.fromJson(item)).toList();
        emit(state.copyWith(images: images, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, hasError: true));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  void showFloatingButton(bool show) {
    emit(state.copyWith(showFloatingButton: show));
  }
}
