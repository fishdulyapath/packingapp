import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_observer.dart';
import 'package:mobilepacking/blocs/boxcartlist/boxcartlist_bloc.dart';
import 'package:mobilepacking/blocs/boxscan/boxscan_bloc.dart';
import 'package:mobilepacking/blocs/boxsend/boxsend_bloc.dart';
import 'package:mobilepacking/blocs/customer/customer_bloc.dart';
import 'package:mobilepacking/blocs/doccardetail/doccardetail_bloc.dart';
import 'package:mobilepacking/blocs/doclistcarpack/doclistcarpack_bloc.dart';
import 'package:mobilepacking/blocs/doclistsend/doclistsend_bloc.dart';
import 'package:mobilepacking/blocs/docsend/docsend_bloc.dart';
import 'package:mobilepacking/blocs/docsenddetail/docsenddetail_bloc.dart';
import 'package:mobilepacking/blocs/dropoff/dropoff_bloc.dart';
import 'package:mobilepacking/blocs/boxlist/boxlist_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/doclist/doclist_bloc.dart';
import 'package:mobilepacking/blocs/login/bloc/login_bloc.dart';
import 'package:mobilepacking/blocs/product/product_bloc.dart';
import 'package:mobilepacking/blocs/productdetail/productdetail_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/store_form_cart/store_form_cart_bloc.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';

import 'package:mobilepacking/repositories/branch_repository.dart';

import 'package:mobilepacking/repositories/doclistcar_repository.dart';
import 'package:mobilepacking/repositories/doclistsend_repository.dart';
import 'package:mobilepacking/repositories/packingdoc_repository.dart';
import 'package:mobilepacking/repositories/product_repository.dart';
import 'package:mobilepacking/repositories/store_repository.dart';
import 'package:mobilepacking/repositories/warehouse_location_repository.dart';
import 'package:mobilepacking/screens/login_page.dart';
import 'package:mobilepacking/screens/packingBox/cubit/packingFM_cubit.dart';
import 'package:mobilepacking/screens/packingSO/cubit/packingSO_cubit.dart';
import 'package:mobilepacking/screens/splash_page.dart';
import 'package:mobilepacking/screens/main_menu.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await GetStorage.init("AppConfig");
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StoreBloc>(
          create: (_) => StoreBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<DoclistCarBloc>(
          create: (_) => DoclistCarBloc(
              productRepository: ProductRepository(),
              doclistCarRepository: DoclistCarRepository()),
        ),
        BlocProvider<DocdetailsendBloc>(
          create: (_) => DocdetailsendBloc(
              productRepository: ProductRepository(),
              docListRepository: DoclistSendRepository()),
        ),
        BlocProvider<DocsendBloc>(
          create: (_) => DocsendBloc(
              productRepository: ProductRepository(),
              docListRepository: DoclistSendRepository()),
        ),
        BlocProvider<DoclistSendBloc>(
          create: (_) => DoclistSendBloc(
              productRepository: ProductRepository(),
              doclistSendRepository: DoclistSendRepository()),
        ),
        BlocProvider<DocdetailcarBloc>(
          create: (_) => DocdetailcarBloc(
              productRepository: ProductRepository(),
              docListRepository: DoclistCarRepository()),
        ),
        BlocProvider<DoclistBloc>(
          create: (_) => DoclistBloc(
              productRepository: ProductRepository(),
              docListRepository: DocListRepository()),
        ),
        BlocProvider<BoxscanBloc>(
          create: (_) => BoxscanBloc(
              productRepository: ProductRepository(),
              docListRepository: DocListRepository()),
        ),
        BlocProvider<BoxsendBloc>(
          create: (_) => BoxsendBloc(
              productRepository: ProductRepository(),
              docListRepository: DocListRepository()),
        ),
        BlocProvider<BoxlistBloc>(
          create: (_) => BoxlistBloc(
              productRepository: ProductRepository(),
              docListRepository: DocListRepository()),
        ),
        BlocProvider<BoxcartlistBloc>(
          create: (_) => BoxcartlistBloc(
              productRepository: ProductRepository(),
              docListRepository: DocListRepository()),
        ),
        BlocProvider<DocdetailBloc>(
          create: (_) => DocdetailBloc(
              productRepository: ProductRepository(),
              docListRepository: DocListRepository()),
        ),
        BlocProvider<BranchBloc>(
          create: (_) => BranchBloc(branchRepository: BranchRepository())
            ..add(BranchLoad(storeType: StoreType.Initial)),
        ),
        BlocProvider<WarehouseLocationBloc>(
          create: (_) => WarehouseLocationBloc(
              warehouseLocationRepository: WarehouseLocationRepository())
            ..add(WarehouseLocationLoad()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<ProductDetailBloc>(
          create: (_) =>
              ProductDetailBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<DropoffBloc>(
          create: (_) => DropoffBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<CustomerBloc>(
          create: (_) => CustomerBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<StoreFormBloc>(
          create: (context) =>
              StoreFormBloc(storeRepository: StoreRepository()),
        ),
        BlocProvider<StoreFormCartBloc>(
          create: (context) =>
              StoreFormCartBloc(storeRepository: StoreRepository()),
        ),
        BlocProvider<PackingFMCubit>(
            create: (_) => PackingFMCubit(storeRepository: StoreRepository())),
        BlocProvider<PackingSOCubit>(
            create: (_) => PackingSOCubit(storeRepository: StoreRepository())),
        BlocProvider<AuthenticationBloc>(
            create: (_) =>
                AuthenticationBloc(authenticationProvider: AuthRepository())),
        BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(authRepo: AuthRepository())),
      ],
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator {
    return _navigatorKey.currentState!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white), // 1
        ),
        primaryColor: Color.fromRGBO(100, 181, 246, 1),
        accentColor: Colors.cyan[600],
        fontFamily: 'Roboto',
      ),
      title: 'SML Mobile Tools',
      home: SplashPage(),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:

//  Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Mainmenu()));

                _navigator.pushAndRemoveUntil<void>(
                  Mainmenu.route(),
                  (route) => false,
                );

                break;
              case AuthenticationStatus.refreshauthenticated:
                break;
              case AuthenticationStatus.unauthenticated:
              case AuthenticationStatus.unknown:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
