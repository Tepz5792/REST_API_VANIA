import 'package:rest_api/app/models/product.dart';
import 'package:rest_api/app/models/vendor.dart';
import 'package:uuid/uuid.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {

     Future<Response> index() async {
          final products = await Product().query().get();
          return Response.json({
               'success': true,
               'message': 'Data has been loaded',
               'data': products,
          });
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          try {
            request.validate({
              'prod_name': 'required|string|min_length:3|max_length:25',
              'prod_price': 'required|integer',
              'prod_desc': 'required|string',
              'vend_id': 'required|string',
            });
          } catch (e) {
            if (e is ValidationException) {
              return Response.json({'success': false, 'message': e.message}, 401);
            }
          }

          var prodName = request.input('prod_name');
          var prodPrice = request.input('prod_price');
          var prodDesc = request.input('prod_desc');
          var vendId = request.input('vend_id');

          final vend = await Vendor().query().where('vend_id', '=', vendId).first();

          if (vend == null) {
               return Response.json({
                    'success': false,
                    'message': 'Vendor with id $vendId not found'
               }, 401);
          }

          final data = {
              'prod_id': Uuid().v4().toString().substring(0, 10),
               'prod_name': prodName,
               'prod_price': prodPrice,
               'prod_desc': prodDesc,
               'vend_id': vendId,
          };

          await Product().query().insert(data);

          return Response.json({
               'success': true,
               'message': 'Product has been created',
               'data': data,
          });
     }

     Future<Response> show(String id) async {
          final product = await Product().query().where('prod_id', '=', id).first();

          if (product == null) {
               return Response.json({
                    'success': false,
                    'message': 'Product with id $id not found'
               }, 404);
          }

          return Response.json({
               'success': true,
               'message': 'Product found',
               'data': product,
          });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,String id) async {
          var prod = await Product().query().where('prod_id', '=', id).first();

          if (prod == null) {
               return Response.json({
                    'success': false,
                    'message': 'Product with id $id not found'
               }, 404);
          }

          try {
               request.validate({
                    'prod_name': 'string|min_length:3|max_length:25',
                    'prod_price': 'integer',
                    'prod_desc': 'string',
               });
          } catch (e) {
               if (e is ValidationException) {
                    return Response.json({'success': false, 'message': e.message}, 401);
               }
          }

          var prodName = request.input('prod_name');
          var prodPrice = request.input('prod_price');
          var prodDesc = request.input('prod_desc');

          final data = {
               'prod_name': prodName ?? prod['prod_name'],
               'prod_price': prodPrice ?? prod['prod_price'],
               'prod_desc': prodDesc ?? prod['prod_desc'],
          };

          await Product().query().where('prod_id', '=', id).update(data);

          return Response.json({
               'success': true,
               'message': 'Product has been updated',
               'data': data,
          });
     }

     Future<Response> destroy(String id) async {
          final product = await Product().query().where('prod_id', '=', id).first();

          if (product == null) {
               return Response.json({
                    'success': false,
                    'message': 'Product with id $id not found'
               }, 404);
          }

          await Product().query().where('prod_id', '=', id).delete();

          return Response.json({
               'success': true,
               'message': 'Product has been deleted'
          });
     }
}

final ProductController productController = ProductController();

