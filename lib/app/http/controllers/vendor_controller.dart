import 'package:rest_api/app/models/vendor.dart';
import 'package:uuid/uuid.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    final vendors = await Vendor().query().get();
    return Response.json({
      'success': true,
      'message': 'Data has been loaded',
      'data': vendors,
    });
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_name': 'required|string|min_length:3|max_length:50',
        'vend_address': 'required|string',
        'vend_city': 'required|string',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var vendName = request.input('vend_name');
    var vendAddress = request.input('vend_address');
    var vendCity = request.input('vend_city');
    var vendState = request.input('vend_state');
    var vendZip = request.input('vend_zip');
    var vendCountry = request.input('vend_country');

    var vend =
        await Vendor().query().where('vend_name', '=', vendName).first();

    if (vend != null) {
      return Response.json({
        'success': false,
        'message': 'Vendor with name $vendName already exists'
      }, 401);
    }

    final data = {
      'vend_id': Uuid().v4().toString().substring(0, 5),
      'vend_name': vendName,
      'vend_address': vendAddress,
      'vend_city': vendCity,
      'vend_state': vendState,
      'vend_zip': vendZip,
      'vend_country': vendCountry,
    };

    await Vendor().query().insert(data);

    return Response.json({
      'success': true,
      'message': 'Vendor has been created',
      'data': data,
    });
  }

  Future<Response> show(String id) async {
    final vendor = await Vendor().query().where('vend_id', '=', id).first();
    if (vendor == null) {
      return Response.json({
        'success': false,
        'message': 'Vendor not found',
      }, 404);
    }

    return Response.json({
      'success': true,
      'message': 'Data has been loaded',
      'data': vendor,
    });
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    final vendor = await Vendor().query().where('vend_id', '=', id).first();
    if (vendor == null) {
      return Response.json({
        'success': false,
        'message': 'Vendor not found',
      }, 404);
    }

    try {
      request.validate({
        'vend_name': 'string|min_length:3|max_length:50',
        'vend_address': 'string',
        'vend_city': 'string',
        'vend_state': 'string|max_length:5',
        'vend_zip': 'string|max_length:7',
        'vend_country': 'string|max_length:25',
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'success': false, 'message': e.message}, 401);
      }
    }

    var vendName = request.input('vend_name');
    var vendAddress = request.input('vend_address');
    var vendCity = request.input('vend_city');
    var vendState = request.input('vend_state');
    var vendZip = request.input('vend_zip');
    var vendCountry = request.input('vend_country');

    final data = {
      'vend_name': vendName ?? vendor['vend_name'],
      'vend_address': vendAddress ?? vendor['vend_address'],
      'vend_city': vendCity ?? vendor['vend_city'],
      'vend_state': vendState ?? vendor['vend_state'],
      'vend_zip': vendZip ?? vendor['vend_zip'],
      'vend_country': vendCountry ?? vendor['vend_country'],
    };

    await Vendor().query().where('vend_id', '=', id).update(data);

    return Response.json({
      'success': true,
      'message': 'Vendor has been updated',
      'data': data,
    });
  }

  Future<Response> destroy(String id) async {
    final vendor = await Vendor().query().where('vend_id', '=', id).first();
    if (vendor == null) {
      return Response.json({
        'success': false,
        'message': 'Vendor not found',
      }, 404);
    }

    await Vendor().query().where('vend_id', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Vendor has been deleted',
    });
  }
}

final VendorController vendorController = VendorController();
