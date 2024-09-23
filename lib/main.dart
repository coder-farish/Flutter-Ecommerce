import 'package:flutter/material.dart';
import 'package:myproject/screens/order_list.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'utils/theme_notifier.dart';
import 'screens/admin_panel.dart';
import 'screens/items_management.dart';
import 'screens/manual.dart';
import 'screens/user_management_screen.dart';
import 'screens/item_search.dart';
import 'utils/whishlist_provider.dart';
import 'utils/cart_provider.dart'; // Import CartProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => WishlistProvider()), // Provide WishlistProvider
        ChangeNotifierProvider(
            create: (_) => CartProvider()), // Provide CartProvider
      ],
      child: const ClothingStoreApp(),
    ),
  );
}

class ClothingStoreApp extends StatelessWidget {
  const ClothingStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FFM Clothing Store',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeNotifier.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            onGenerateRoute: (settings) {
              final args = settings.arguments as Map<String, dynamic>?;

              switch (settings.name) {
                case '/home':
                  return MaterialPageRoute(
                      builder: (context) => const HomeScreen());
                case '/profile':
                  return MaterialPageRoute(
                      builder: (context) => ProfileScreen());
                case '/onboarding':
                  return MaterialPageRoute(
                      builder: (context) => const OnboardingScreen());
                case '/login':
                  return MaterialPageRoute(
                      builder: (context) => const LoginScreen());
                case '/signup':
                  return MaterialPageRoute(
                      builder: (context) => const SignupScreen());
                case '/cart':
                  return MaterialPageRoute(builder: (context) => CartScreen());
                case '/checkout':
                  return MaterialPageRoute(
                      builder: (context) => CheckoutScreen());
                case '/wishlist':
                  return MaterialPageRoute(
                      builder: (context) => WishlistScreen());
                case '/order-confirmation':
                  return MaterialPageRoute(
                    builder: (context) => OrderConfirmationScreen(
                      orderId: args?['orderId'] ?? '',
                      totalAmount: args?['totalAmount'] ?? 0.0,
                      shippingFee: args?['shippingFee'] ?? 0.0,
                      subTotal: args?['subTotal'] ?? 0.0,
                      paymentMode: args?['paymentMode'] ?? '',
                      cartItems: args?['cartItems'] ?? [],
                    ),
                  );
                case '/admin-panel':
                  return MaterialPageRoute(
                      builder: (context) => const AdminPanelScreen());
                case '/items-management':
                  return MaterialPageRoute(
                      builder: (context) => const ItemsManagementScreen());
                case '/data-management':
                  return MaterialPageRoute(
                      builder: (context) => const ManualAddScreen());
                case '/users-management':
                  return MaterialPageRoute(
                      builder: (context) => const UsersManagementScreen());
                case '/ordersm':
                  return MaterialPageRoute(builder: (context) => OrdersPage());

                case '/item-search':
                  return MaterialPageRoute(
                      builder: (context) =>
                          ItemSearchScreen(product: const {}));
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
