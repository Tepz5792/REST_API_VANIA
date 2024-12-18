import 'package:rest_api/app/models/customer.dart';
import 'package:uuid/uuid.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    final customers = await Customer().query().get();
    return Response.json({
      'success': true,
      'message': 'Data telah diunggah',
      'data': customers,
    });
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_name': 'required|string|min_length:3|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var custName = request.input('cust_name');
    var custAddress = request.input('cust_address');
    var custCity = request.input('cust_city');
    var custState = request.input('cust_state');
    var custZip = request.input('cust_zip');
    var custCountry = request.input('cust_country');
    var custTelp = request.input('cust_telp');

    var cust =
        await Customer().query().where('cust_telp', '=', custTelp).first();

    if (cust != null) {
      return Response.json({
        'success': false,
        'message': 'Pelanggan dengan nomor telepon $custTelp sudah ada'
      }, 401);
    }

    final data = {
      'cust_id': Uuid().v4().toString().substring(0, 5),
      'cust_name': custName,
      'cust_address': custAddress,
      'cust_city': custCity,
      'cust_state': custState,
      'cust_zip': custZip,
      'cust_country': custCountry,
      'cust_telp': custTelp.toString(),
    };
    await Customer().query().insert(data);

    return Response.json(
        {'success': true, 'message': 'Data sudah berhasil disimpan', 'data': data});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }
  
  Future<Response> show(String id) async {
    final customer = await Customer().query().where('cust_id', '=', id).first();
    if (customer == null) {
      return Response.json(
          {'success': false, 'message': 'Pengguna dengan id $id tidak ditemukan'}, 404);
    }
    return Response.json({
      'success': true,
      'message': 'Data has been loaded',
      'data': customer,
    });
  }


  Future<Response> update(Request request, String id) async {
    var cust = await Customer().query().where('cust_id', '=', id).first();

    if (cust == null) {
      return Response.json(
          {'success': false, 'message': 'Pengguna dengan id $id tidak ditemukan'}, 404);
    }

    try {
      request.validate({
        'cust_name': 'string|min_length:3|max_length:50',
        'cust_address': 'string|max_length:50',
        'cust_city': 'string|max_length:20',
        'cust_state': 'string|max_length:5',
        'cust_zip': 'string|max_length:7',
        'cust_country': 'string|max_length:25',
        'cust_telp': 'string|max_length:15',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var custName = request.input('cust_name');
    var custAddress = request.input('cust_address');
    var custCity = request.input('cust_city');
    var custState = request.input('cust_state');
    var custZip = request.input('cust_zip');
    var custCountry = request.input('cust_country');

    final data = {
      'cust_name': custName ?? cust['cust_name'],
      'cust_address': custAddress ?? cust['cust_address'],
      'cust_city': custCity ?? cust['cust_city'],
      'cust_state': custState ?? cust['cust_state'],
      'cust_zip': custZip ?? cust['cust_zip'],
      'cust_country': custCountry ?? cust['cust_country'],
    };

    await Customer().query().where('cust_id', '=', id).update(data);

    return Response.json(
        {'success': true, 'message': 'Data berhasil diupdate', 'data': data});
  }

  Future<Response> destroy(String id) async {
    final customer = await Customer().query().where('cust_id', '=', id).first();
    if (customer == null) {
      return Response.json(
          {'success': false, 'message': 'Pengguna dengan id $id tidak ditemukan'}, 404);
    }
    await Customer().query().where('cust_id', '=', id).delete();
    return Response.json({
      'success': true,
      'message': 'Data has been deleted',
    });
  }
}

final CustomerController customerController = CustomerController();
