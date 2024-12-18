import 'package:rest_api/app/models/product_note.dart';
import 'package:vania/vania.dart';
import 'package:uuid/uuid.dart';
import 'package:rest_api/app/models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';



class ProductNoteController extends Controller {

     Future<Response> index() async {
          final productnotes = await ProductNote().query().get();

          return Response.json({
               'success': true,
               'message': 'Data has been loaded',
               'data': productnotes,
          });
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          try {
               request.validate({
                    'prod_id': 'required|string',
                    'note_date': 'required|date',
                    'note_text': 'required|string',
               });
          } catch (e) {
               if (e is ValidationException) {
                    return Response.json({'success': false, 'message': e.message}, 401);
               }
          }

          var prodId = request.input('prod_id');
          var noteDate = request.input('note_date');
          var noteText = request.input('note_text');

          final prod = await Product().query().where('prod_id', '=', prodId).first();

          if (prod == null) {
               return Response.json({
                    'success': false,
                    'message': 'Product with id $prodId not found'
               }, 401);
          }

          final data = {
               'note_id': Uuid().v4().toString().substring(0, 5),
               'prod_id': prodId,
               'note_date': noteDate,
               'note_text': noteText,
          };

          await ProductNote().query().insert(data);

          return Response.json({
               'success': true,
               'message': 'Data has been saved',
               'data': data,
          });
     }

     Future<Response> show(String id) async {
          final productnote = await ProductNote().query().where('note_id', '=', id).first();

          if (productnote == null) {
               return Response.json({
                    'success': false,
                    'message': 'Data not found',
               }, 401);
          }

          return Response.json({
               'success': true,
               'message': 'Data has been loaded',
               'data': productnote,
          });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,String id) async {
          final productnote = await ProductNote().query().where('note_id', '=', id).first();

          if (productnote == null) {
               return Response.json({
                    'success': false,
                    'message': 'Data not found',
               }, 401);
          }

          try {
               request.validate({
                    'note_date': 'date',
                    'note_text': 'string',
               });
          } catch (e) {
               if (e is ValidationException) {
                    return Response.json({'success': false, 'message': e.message}, 401);
               }
          }
          var noteDate = request.input('note_date');
          var noteText = request.input('note_text');

          final data = {
               'note_date': noteDate ?? productnote['note_date'],
               'note_text': noteText ?? productnote['note_text'],
          };

          await ProductNote().query().where('note_id', '=', id).update(data);

          return Response.json({
               'success': true,
               'message': 'Data has been updated',
               'data': data,
          });
     }

     Future<Response> destroy(String id) async {
          final productnote = await ProductNote().query().where('note_id', '=', id).first();

          if (productnote == null) {
               return Response.json({
                    'success': false,
                    'message': 'Data not found',
               }, 401);
          }

          await ProductNote().query().where('note_id', '=', id).delete();

          return Response.json({
               'success': true,
               'message': 'Data has been deleted',
          });
     }
}

final ProductNoteController productNoteController = ProductNoteController();

