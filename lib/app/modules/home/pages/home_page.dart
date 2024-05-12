import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFF1b1a1f),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.scrollControllerHome,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: const Color(0xFF1b1a1f),
                  automaticallyImplyLeading: false,
                  title: const Text(
                    'Isekai - Encrypt',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Microsoft New Tai Lue',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                  pinned: true,
                  snap: true,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Container(),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Um pedaço do meu app...',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Microsoft New Tai Lue',
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.processing.value
                            ? null
                            : () async {
                                if (controller.processing.value) return;

                                String? result = await FilePicker.platform
                                    .getDirectoryPath();

                                if (result != null) {
                                  Directory selectedDirectory =
                                      Directory(result);
                                  if (selectedDirectory.existsSync()) {
                                    controller.outputController.clear();
                                    Directory tempDir =
                                        await getTemporaryDirectory();
                                    String directoryName =
                                        path.basename(selectedDirectory.path);
                                    Directory finalOutputDirectory = Directory(
                                      path.join(
                                        selectedDirectory.parent.path,
                                        "${directoryName}Encrypted",
                                      ),
                                    );
                                    finalOutputDirectory.createSync(
                                        recursive: true);
                                    controller.outputController.add(
                                      'Diretório de saída criado: ${finalOutputDirectory.path}',
                                    );
                                    Directory outputDirectory = Directory(
                                      path.join(
                                        tempDir.path,
                                        "${directoryName}Encrypted",
                                      ),
                                    );
                                    outputDirectory.createSync(recursive: true);

                                    await encryptFile(
                                      selectedDirectory.path,
                                      outputDirectory.path,
                                    );

                                    File keyFile = File(
                                        "${outputDirectory.parent.path}/$directoryName"
                                        "Encrypted.key");

                                    String outputPath = path.join(
                                      finalOutputDirectory.path,
                                      "${path.basename(outputDirectory.path)}.zip",
                                    );
                                    if (await keyFile.exists()) {
                                      // Renomear o arquivo para key.txt
                                      String newFilePath =
                                          "${finalOutputDirectory.path}/key.txt";
                                      await keyFile.rename(newFilePath);
                                    }
                                    await zipDirectory(
                                      outputDirectory.path,
                                      outputPath,
                                    );
                                    await deleteFolder(outputDirectory.path);
                                  }
                                }
                              },
                        child: Obx(() => Text(controller.processing.value
                            ? "Codificando..."
                            : "Abrir pasta")),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight - 200,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Logs:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Obx(
                                () => ListView(
                                  controller: controller.scrollControllerLog,
                                  children: controller.outputController
                                      .map(
                                        (line) => Text(line),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => Visibility(
                          visible: controller.processingMessage.isNotEmpty,
                          child: Text(controller.processingMessage.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> encryptFile(String inputPath, String outputPath) async {
    controller.processingMessage.value = '';
    controller.processing.value = true;

    Directory(outputPath).createSync(recursive: true);

    var process = await Process.start(
      'assets/mcrputil',
      ['encrypt', inputPath, outputPath],
      runInShell: false,
    );

    process.stdout.transform(utf8.decoder).listen((data) {
      List<String> lines = data.split('\n');
      for (String line in lines) {
        if (line.isNotEmpty) {
          controller.outputController.add(line);
          controller.scrollControllerLog.jumpTo(
            controller.scrollControllerLog.position.maxScrollExtent,
          );
        }
      }
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      List<String> lines = data.split('\n');
      for (String line in lines) {
        if (line.isNotEmpty) {
          controller.outputController.add(line);
          controller.scrollControllerLog.jumpTo(
            controller.scrollControllerLog.position.maxScrollExtent,
          );
        }
      }
    });

    var exitCode = await process.exitCode;
    if (exitCode == 0) {
      controller.processingMessage.value =
          'Arquivos criptografados com sucesso.';
    } else {
      controller.processingMessage.value =
          'Ocorreu um erro durante a criptografia dos arquivos.';
    }

    controller.processing.value = false;
  }

  Future<void> zipDirectory(String directoryPath, String outputPath) async {
    var encoder = ZipFileEncoder();
    encoder.create(outputPath);

    await _addFilesToZip(encoder, Directory(directoryPath), '');

    encoder.close();
  }

  Future<void> _addFilesToZip(
      ZipFileEncoder encoder, Directory directory, String relativePath) async {
    List<FileSystemEntity> entities = directory.listSync();

    for (FileSystemEntity entity in entities) {
      String entityRelativePath =
          path.join(relativePath, path.basename(entity.path));

      if (entity is File) {
        encoder.addFile(entity, entityRelativePath);
      } else if (entity is Directory) {
        await _addFilesToZip(encoder, entity, entityRelativePath);
      }
    }
  }

  Future<void> deleteFolder(String folderPath) async {
    try {
      final folder = Directory(folderPath);

      if (await folder.exists()) {
        final entities = await folder.list().toList();

        for (final entity in entities) {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await deleteFolder(entity.path);
          }
        }

        await folder.delete();
      }
    } catch (e) {
      //erro
    }
  }
}
