import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/babies.dart';
import 'models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Dog(name: 'dog06', breed: 'breed06', age: 3),
        ),

        /// 초기 데이터로 빌드 1번, Future가 끝나면 또 리빌드로 총 빌드 2번함.
        FutureProvider(
          // Future 가 끝날 동안 표시될 초기 데이터
          initialData: 0,
          create: (context) {
            // ChangeNotifierProvider 가 상위 위젯이기때문에 가져올수 있음.
            final int dogAge = context.read<Dog>().age;
            final babies = Babies(age: dogAge);
            // Future를 리턴하는 거라면 FutureProvider 내에서 사용될수 있다.
            // getBabies의 리턴 타입이 int이기때문에 FutureProvider<int>
            return babies.getBabies();
          },
        ),
        StreamProvider(
          initialData: 'Bark 0 times',
          create: (context) {
            // ChangeNotifierProvider 가 상위 위젯이기때문에 가져올수 있음.
            // final int dogAge = context.watch<Dog>().age;
            /// create 는 한번만 불리기때문에 리빌드 될 일이 없는데 watch를 주면 문맥이 안맞아서 error 발생
            final int dogAge = context.read<Dog>().age;

            final babies = Babies(age: dogAge * 2);
            return babies.bark();
          },
        )
      ],
      child: MaterialApp(
        title: 'Provider 06',
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
        title: Text('Provider 06'),
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
        SizedBox(height: 10.0),
        Text(
          // Babies.getBabies의 return 타입이 int 이기때문에 타입을 int 로 지정.
          '- number of babies: ${context.read<int>()}',
          // watch 는 future의 delayed 3초가 끝나도 리빌드 하지않음. listen false기 때문에.
          /// '- number of babies: ${context.watch<int>()}',
          // watch 는 future의 delayed 3초가 끝나면 값의 변화를 감지하고 리빌드함.
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Text(
          // '- ${context.read<String>()}', // read의 경우 listen false 라서 yield 받아도 리빌드 되지않음.
          '- ${context.watch<String>()}',
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
