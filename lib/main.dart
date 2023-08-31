import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorize_mvvm_bloc/memorize_view.dart';
import 'package:memorize_mvvm_bloc/vm_memorize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // <----------- ใช้แบบ BlocProvider ----------->
  // @override
  // Widget build(context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: BlocProvider(
  //       create: (context) => MemorizeCubit(),
  //       child: const MemorizeView(),
  //     )
  //   );
  // }

  // <----------- ใช้แบบ MutliBlocProvider ----------->
  @override
  Widget build(context) {
    BlocProvider memorize = BlocProvider<MemorizeCubit>(create: (context) => MemorizeCubit());

    return MultiBlocProvider(
      providers: [memorize], 
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MemorizeView(),
      ),
    );
  }
}