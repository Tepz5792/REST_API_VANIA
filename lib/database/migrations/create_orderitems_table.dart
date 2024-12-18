import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('orderitems', () {
      primary('order_item');
      integer('order_item', length: 11, increment: true);
      integer('order_num', length: 11);
      foreign('order_num', 'orders', 'order_num', onDelete: 'CASCADE');
      string('prod_id', length: 10);
      foreign('prod_id', 'products', 'prod_id', onDelete: 'CASCADE');
      integer('quantity', length: 11);
      integer('size', length: 11);
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
