# NGL Flutter

**NGL Flutter** — это Flutter-пакет для интеграции 3D-визуализации молекулярных структур, используя библиотеку [NGL.js](https://nglviewer.org/). Пакет позволяет загружать и отображать модели лигандов из базы данных Protein Data Bank (PDB) и предоставляет удобный API для взаимодействия с 3D-визуализацией.

## Возможности

- Загрузка 3D-моделей лигандов из PDB.
- Визуализация в формате "шары и палочки" с использованием цветовой схемы CPK.
- Взаимодействие с моделью: поворот, зум, перемещение.
- Получение информации об атомах при клике.
- Экспорт визуализации в формате изображения.

## Установка

1. Добавьте пакет в `pubspec.yaml` вашего проекта:
   ```yaml
   dependencies:
     ngl_flutter:
       git:
         url: https://github.com/denisnadey/ngl_flutter.git
   ```
2. Установите зависимости:
   ```bash
   flutter pub get
   ```

## Использование

### Импортируйте пакет

```dart
import 'package:ngl_flutter/ngl_viewer_widget.dart';
```

### Добавьте виджет в ваш UI

```dart
import 'package:flutter/material.dart';
import 'package:ngl_flutter/ngl_viewer_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NGL Viewer Example'),
        ),
        body: NGLViewerWidget(
          ligandId: 'HEM', // Укажите ID лиганда
          controller: NGLViewerController(),
        ),
      ),
    );
  }
}
```

### API контроллера

- **`loadLigand(String ligandId)`**: Загружает лиганд по ID.
- **`captureImage(Function(String base64Image) onImageCaptured)`**: Захватывает изображение текущей сцены и возвращает его в формате Base64.
- **`reload()`**: Перезагружает WebView.

Пример использования контроллера:

```dart
final controller = NGLViewerController();

controller.loadLigand('ATP');
controller.captureImage((base64Image) {
  print('Изображение: $base64Image');
});
```

### Структура HTML и JavaScript

Файл `index.html`, используемый WebView, подключает библиотеку [NGL.js](https://nglviewer.org/ngl/api/) и предоставляет следующие функции:

- **`loadLigand(ligandId)`**: Загружает модель лиганда из PDB.
- **`captureImage()`**: Генерирует изображение текущей сцены.

## Требования

- Flutter 3.6.0 или новее.
- Поддержка WebView для Android и iOS.

## Как это работает

1. Flutter вызывает функции JavaScript через `WebViewController.runJavaScript`.
2. NGL.js загружает и визуализирует модель.
3. Результаты (например, изображение) передаются обратно в Flutter через JavaScript каналы.
