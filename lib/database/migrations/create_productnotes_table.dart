import 'package:vania/vania.dart';

class CreateProductnotesTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('productnotes', () {
      primary('note_id');
      char('note_id', length: 5);
      string('prod_id', length: 10);
      foreign('prod_id', 'products', 'prod_id', onDelete: 'CASCADE');
      date('note_date');
      text('note_text');
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
