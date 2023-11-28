// import 'package:flutter/material.dart';

// void main() => runApp(Compressor());

// class Compressor extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BouncyContainer(),
//     );
//   }
// }

// class BouncyContainer extends StatefulWidget {
//   @override
//   _BouncyContainerState createState() => _BouncyContainerState();
// }

// class _BouncyContainerState extends State<BouncyContainer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//       // You can adjust the duration to control the bounce speed
//     );

//     _animation = Tween<double>(
//       begin: 1.0,
//       end: 0.8,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//         // You can experiment with different curves for different effects
//       ),
//     );

//     _controller.repeat(
//         reverse: true); // Reversing the animation for a bouncing effect
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _animation.value,
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(180),
//                     border: Border.all(width: 2, color: Colors.black),
//                     color: Colors.cyan,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.amber, spreadRadius: 30, blurRadius: 20)
//                     ]),
//                 width: 200,
//                 height: 200,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // routes: {
      //   '/login': (context) => LoginScreen(),
      //   // Add more routes if needed
      // },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);

    //  _controller.repeat(reverse: true);
    _controller.forward().whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp2()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Center(
                  child: Container(
                    width: double.infinity * 100,
                    height: double.infinity * 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 77, 126, 127),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.cyan,
                          spreadRadius: 15,
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(),
                        ),
                        const Text(
                          'Images Compressor',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.cyan),
                        ),
                        const Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'powered by',
                                  style: TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                                Text(
                                  '   J Technologies',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                      color: Colors.cyan),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Compressor(),
    );
  }
}

class Compressor extends StatefulWidget {
  const Compressor({super.key});

  @override
  State<Compressor> createState() => _CompressorState();
}

class _CompressorState extends State<Compressor> {
  String items = '10';

  File? orignalImage;
  File? compressedImage;
  String filePath = "storage/emulated/0/Download";

  double downloading = 0.0;
  bool isCompressing = false;

  int? orignalSize;
  double? size;
  double? twoDecimal;
  int? compressedSize;
  double? compressSize;
  double? compressedTwoDecimal;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        orignalImage = File(pickedFile.path);
        compressedImage = null;
        orignalSize = orignalImage?.lengthSync();
        size = (orignalSize! / 1024).toDouble();
        twoDecimal = double.parse(size!.toStringAsFixed(2));
      });
    }
  }

  Future compressImage() async {
    try {
      if (orignalImage == null) return null;
      setState(() {
        isCompressing = true;
      });
      final compressed = await FlutterImageCompress.compressAndGetFile(
        orignalImage!.path,
        "$filePath/compressed.jpg",
        quality: int.parse(items),
      );
      setState(() {
        isCompressing = false;
      });
      if (compressed != null) {
        setState(() {
          compressedImage = File(compressed.path);

          compressedSize = compressedImage?.lengthSync();
          compressSize = (compressedSize! / 1024).toDouble();
          compressedTwoDecimal = double.parse(compressSize!.toStringAsFixed(2));
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Image Compressed")));
        });

        // print(compressedImage!.length());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Compressor'),
          centerTitle: true,
          backgroundColor: Colors.cyan,
          leading: IconButton(
              onPressed: () {
                try {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Info()));
                } catch (e) {
                  print('error: ${e}');
                }
              },
              icon: const Icon(Icons.info)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 104, 102, 96)),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50)),
                    color: Color.fromARGB(255, 77, 126, 127),
                  ),
                  height: 500,
                  //  width: MediaQuery.of(context).devicePixelRatio,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                child: InkWell(
                                  onLongPress: pickImage,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Original',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.cyan, width: 2)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            orignalImage != null
                                                ? Image.file(orignalImage!)
                                                : TextButton.icon(
                                                    onPressed: pickImage,
                                                    icon: const Icon(
                                                        Icons.image,
                                                        color: Colors.cyan),
                                                    label: const Text(
                                                      'Select Image',
                                                      style: TextStyle(
                                                          color: Colors.cyan),
                                                    ),
                                                  ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Size: ${twoDecimal ?? ' '} kb',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.cyan),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                child: GestureDetector(
                                  onTap: compressedImage != null
                                      ? compressImage
                                      : null,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Compressed',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyan),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.cyan, width: 2)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            isCompressing
                                                ? const Column(
                                                    children: [
                                                      CircularProgressIndicator(),
                                                      Text('Compressing...'),
                                                    ],
                                                  )
                                                : compressedImage != null
                                                    ? Image.file(
                                                        compressedImage!)
                                                    : TextButton.icon(
                                                        onPressed:
                                                            compressImage,
                                                        icon: const Icon(
                                                          Icons.compress,
                                                          color: Colors.cyan,
                                                        ),
                                                        label: const Text(
                                                          'Compress Image',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.cyan),
                                                        )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Size: ${compressedTwoDecimal ?? ' '} kb',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.cyan),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    value: items,
                    focusColor: Colors.cyan,
                    onChanged: (newValue) {
                      setState(() {
                        items = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      label: const Text(
                        'Reduce Size',
                        style: TextStyle(color: Colors.cyan),
                      ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.cyan, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.cyan, width: 2),
                      ),
                    ),
                    items: [
                      '10',
                      '20',
                      '35',
                      '45',
                      '65',
                      '85',
                      '90',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        // child: Text(value),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value),
                            const Text(
                                '%'), // Adding percentage sign as a separate widget
                          ],
                        ),
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
          backgroundColor: Colors.cyan,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Compressor()));
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '1: Once image is selected then you can long press the image it select another one.\n\n2: As image is selected and you want to compress it again then double tap on compressed image they will again compress it.\n\n3: Below their is quality mentioned and you can reduce the as you want, just select below value they will reduce size upto that percents.\n\n4: As you press the compress button they will auto compress and download the image to your download folder in you phone.\n\n5: The key feature is that they can compress and download the images offline, you do not have to use internet for it.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
