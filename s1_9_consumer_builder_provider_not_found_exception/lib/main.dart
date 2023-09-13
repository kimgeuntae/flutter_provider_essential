import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider 09',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class Foo with ChangeNotifier {
  String value = 'Foo';

  void changeValue() {
    value = value == 'Foo' ? 'Bar' : 'Foo';
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider 09'),
      ),

      /// ProviderNotFoundException 의 해결방법
      /// 1. 가능하다면 위젯 트리를 더 위로올린다.
      /// 2. 빌더 패턴을 사용한다.
      /// 3. consumer를 사용한다(빌더 패턴을 사용하기때문에)
      body: ChangeNotifierProvider(
        create: (_) => Foo(),
        // Consumer 이용
        child: Consumer<Foo>(
          builder: (BuildContext context, Foo foo, Widget? _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${foo.value}',
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => foo.changeValue(),
                    child: Text(
                      'Change Value',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      /*
      // 빌더 패턴 이용
      body: ChangeNotifierProvider(
        create: (_) => Foo(),
        builder: (BuildContext context, Widget? _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // 중간에 빌더를 넣어줌으로써 return 위젯이 하위로 가고, 빌더의 context를 사용하면서 provider 를 사용할 수 있게됨.
                  '${context.watch<Foo>().value}',
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => context.read<Foo>().changeValue(),
                  child: Text(
                    'Change Value',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
       */
      /*
      // 조상 context를 가져다 써서 ProviderNotFoundException 가 발생함.
      body: ChangeNotifierProvider(
        create: (_) => Foo(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${context.watch<Foo>().value}',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => context.read<Foo>().changeValue(),
                child: Text(
                  'Change Value',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    */
    );
  }
}
