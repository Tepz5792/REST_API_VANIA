import 'package:rest_api/app/models/customer.dart';
import 'package:rest_api/app/models/order.dart';
import 'package:rest_api/app/models/order_item.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    final orders = await Order().query().get();
    return Response.json({
      'success': true,
      'message': 'Customer data retrieved successfully',
      'data': orders,
    });
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required|string',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var orderDate = request.input('order_date');
    var custId = request.input('cust_id');

    final cust = await Customer().query().where('cust_id', '=', custId).first();

    if (cust == null) {
      return Response.json(
          {'success': false, 'message': 'Customer with id $custId not found'},
          401);
    }

    final order = {
      'order_date': orderDate,
      'cust_id': custId,
    };

    await Order().query().insert(order);

    return Response.json({
      'success': true,
      'message': 'Order has been created',
      'data': order
    });
  }

  Future<Response> show(int id) async {
    final order = await Order().query().where('order_num', '=', id).first();

    if (order == null) {
      return Response.json(
          {'success': false, 'message': 'Order with id $id not found'}, 404);
    }

    final orderItems = await OrderItem().query().where('order_num', '=', id).get();

    return Response.json({
      'success': true,
      'message': 'Data has been loaded',
      'data': {
        ...order,
        'order_items': orderItems
      },
    });
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    final order = await Order().query().where('order_num', '=', id).first();

    if (order == null) {
      return Response.json(
          {'success': false, 'message': 'Order with id $id not found'}, 404);
    }

    try {
      request.validate({
        'order_date': 'date',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var orderDate = request.input('order_date');

    await Order().query().where('order_num', '=', id).update({
      'order_date': orderDate
    });

    return Response.json({
      'success': true,
      'message': 'Order has been updated'
    });
  }

  Future<Response> destroy(int id) async {
    final order = await Order().query().where('order_num', '=', id).first();

    if (order == null) {
      return Response.json(
          {'success': false, 'message': 'Order with id $id not found'}, 404);
    }

    await Order().query().where('order_num', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Order has been deleted',
    });
  }
}

final OrderController orderController = OrderController();
