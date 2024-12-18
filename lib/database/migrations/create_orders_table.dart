import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      primary('order_num');
      integer('order_num', length: 11, increment: true);
      date('order_date');
      char('cust_id', length: 5);
      foreign('cust_id', 'customers', 'cust_id', onDelete: 'CASCADE');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
