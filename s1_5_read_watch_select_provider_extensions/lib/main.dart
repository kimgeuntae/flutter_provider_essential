import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Dog(name: 'dog05', breed: 'breed05', age: 3),
      child: MaterialApp(
        title: 'Provider 05',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider 05'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              // '- name: ${Provider.of<Dog>(context, listen: false).name}',
              '- name: ${context.watch<Dog>().name}', // select 써도 괜찮
              // watch: listen object의 변화를 감지하여 리빌드
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            BreedAndAge(),
          ],
        ),
      ),
    );
  }
}

class BreedAndAge extends StatelessWidget {
  const BreedAndAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          // '- breed: ${Provider.of<Dog>(context, listen: false).breed}',
          '- breed: ${context.select<Dog, String>((Dog dog) => dog.breed)}',
          // select: listen 하고 싶은 프로퍼티(breed)의 변화만 감지하여 리빌드
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Age(),
      ],
    );
  }
}

class Age extends StatelessWidget {
  const Age({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          // '- age: ${Provider.of<Dog>(context).age}',
          '- age: ${context.select<Dog, int>((Dog dog) => dog.age)}',
          // select: listen 하고 싶은 프로퍼티(age)의 변화만 감지하여 리빌드
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => context.read<Dog>().grow(),
          // 버튼은 리빌드 될 필요가 없기때문에 listen false를 강제하기 때문에 read 를 써서 listen false 해줘야함
          child: Text(
            'Grow',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    );
  }
}
