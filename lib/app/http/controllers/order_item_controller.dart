import 'package:rest_api/app/models/order.dart';
import 'package:rest_api/app/models/order_item.dart';
import 'package:rest_api/app/models/product.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {
  Future<Response> index() async {
    final orderItems = await OrderItem().query().get();
    return Response.json({
      'success': true,
      'message': 'Data has been loaded',
      'data': orderItems,
    });
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required|integer',
        'order_items': 'required|array',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var orderNum = request.input('order_num');
    var orderItems = request.input('order_items');

    final order =
        await Order().query().where('order_num', '=', orderNum).first();

    if (order == null) {
      return Response.json({
        'success': false,
        'message': 'Order with number $orderNum not found'
      }, 401);
    }

    for (var item in orderItems) {
      var prodId = item['prod_id'];
      var quantity = item['quantity'];
      var size = item['size'];

      final prod =
          await Product().query().where('prod_id', '=', prodId).first();

      if (prod == null) {
        return Response.json(
            {'success': false, 'message': 'Product with id $prodId not found'},
            401);
      }

      final data = {
        'order_num': orderNum,
        'prod_id': prodId,
        'quantity': quantity,
        'size': size,
      };

      await OrderItem().query().insert(data);
    }

    return Response.json({
      'success': true,
      'message': 'Order items has been created',
    });
  }

  Future<Response> show(int id) async {
    final orderItem =
        await OrderItem().query().where('order_item', '=', id).first();

    if (orderItem == null) {
      return Response.json(
          {'success': false, 'message': 'Order item with id $id not found'},
          404);
    }

    return Response.json({
      'success': true,
      'message': 'Order item found',
      'data': orderItem,
    });
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    final orderItem =
        await OrderItem().query().where('order_item', '=', id).first();

    if (orderItem == null) {
      return Response.json(
          {'success': false, 'message': 'Order item with id $id not found'},
          404);
    }

    try {
      request.validate({
        'quantity': 'integer',
        'size': 'integer',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var quantity = request.input('quantity');
    var size = request.input('size');

    final data = {
      'quantity': quantity ?? orderItem['quantity'],
      'size': size ?? orderItem['size'],
    };

    await OrderItem().query().where('order_item', '=', id).update(data);

    return Response.json({
      'success': true,
      'message': 'Order item has been updated',
    });
  }

  Future<Response> destroy(int id) async {
    final orderItem =
        await OrderItem().query().where('order_item', '=', id).first();

    if (orderItem == null) {
      return Response.json(
          {'success': false, 'message': 'Order item with id $id not found'},
          404);
    }

    await OrderItem().query().where('order_item', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Order item has been deleted',
    });
  }
}

final OrderItemController orderItemController = OrderItemController();
