import 'package:rest_api/app/http/controllers/customer_controller.dart';
import 'package:rest_api/app/http/controllers/order_controller.dart';
import 'package:rest_api/app/http/controllers/order_item_controller.dart';
import 'package:rest_api/app/http/controllers/product_controller.dart';
import 'package:rest_api/app/http/controllers/product_note_controller.dart';
import 'package:rest_api/app/http/controllers/auth_controller.dart';
import 'package:rest_api/app/http/middleware/authenticate.dart';
import 'package:rest_api/app/http/controllers/vendor_controller.dart';
import 'package:rest_api/app/http/controllers/users_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    /// Customer Routes
    Router.group(prefix: 'customer', () {
      Router.get('/', customerController.index);
      Router.get('/{id}', customerController.show);
      Router.post('/store', customerController.store);
      Router.put('/update/{id}', customerController.update);
      Router.delete('/delete/{id}', customerController.destroy);
    });

    /// Vendor Routes
    Router.group(prefix: 'vendor', () {
      Router.get('/', vendorController.index);
      Router.get('/{id}', vendorController.show);
      Router.post('/store', vendorController.store);
      Router.put('/update/{id}', vendorController.update);
      Router.delete('/delete/{id}', vendorController.destroy);
    });

    /// Product Routes
    Router.group(prefix: 'product', () {
      Router.get('/', productController.index);
      Router.get('/{id}', productController.show);
      Router.post('/store', productController.store);
      Router.put('/update/{id}', productController.update);
      Router.delete('/delete/{id}', productController.destroy);
    });

    // Product Notes Routes
    Router.group(prefix: 'product-note', () {
      Router.get('/', productNoteController.index);
      Router.get('/{id}', productNoteController.show);
      Router.post('/store', productNoteController.store);
      Router.put('/update/{id}', productNoteController.update);
      Router.delete('/delete/{id}', productNoteController.destroy);
    });

    /// Order Routes
    Router.group(prefix: 'order', () {
      Router.get('/', orderController.index);
      Router.get('/{id}', orderController.show);
      Router.post('/store', orderController.store);
      Router.put('/update/{id}', orderController.update);
      Router.delete('/delete/{id}', orderController.destroy);
    });

    /// Order Item Routes
    Router.group(prefix: 'order-item', () {
      Router.get('/', orderItemController.index);
      Router.get('/{id}', orderItemController.show);
      Router.post('/store', orderItemController.store);
      Router.put('/update/{id}', orderItemController.update);
      Router.delete('/delete/{id}', orderItemController.destroy);
    });
    
    Router.group(() {
      Router.post('register',
          authController.register); 
      Router.post('login', authController.login);
    }, prefix: 'auth');
  }
}
