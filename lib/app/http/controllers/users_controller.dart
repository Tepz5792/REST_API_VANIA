import 'package:vania/vania.dart';
import 'package:rest_api/app/models/user.dart';

class UserController extends Controller {
  Future<Response> index() async {
    Map? user = Auth().user();

    if (user != null) {
      user.remove('password');
      return Response.json({
        'status': 'success',
        'message': 'Data dari pengguna telah berhasil diperoleh',
        'data': user,
      });
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna belum terverifikasi',
      }, 401);
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    return Response.json({});
  }
}

final UserController userController = UserController();
