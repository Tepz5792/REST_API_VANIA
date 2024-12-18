import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('products', () {
      primary('prod_id');
      string('prod_id', length: 10);
      char('vend_id', length: 5);
      foreign('vend_id', 'vendors', 'vend_id', onDelete: 'CASCADE');
      string('prod_name', length: 25);
      integer('prod_price', length: 11);
      text('prod_desc');
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
