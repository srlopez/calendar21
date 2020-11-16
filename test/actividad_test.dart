import 'package:calendar21/model/actividad_model.dart';
import 'package:test/test.dart';

void main() {
  group('Actividad', () {
    test('Una Actividad se crea inactiva', () {
      var act = Actividad();

      expect(act.asignada, false);
      expect(act.segmentos, 1);
    });

    test('Creada de String', () {
      final s = Actividad().separator;
      final sm = 2;
      final m = 50;
      final a = true;
      final t = 'titulo';
      final st = 'subtitulo';
      final p = 'pie';
      final c = 100;
      final str = '$sm$s$m$s${a ? 1 : 0}$s$t$s$st$s$p$s$c';
      var act = Actividad.fromString(str);

      expect(act.segmentos, sm);
      expect(act.minutos, m);
      expect(act.asignada, a);
      expect(act.titulo, t);
      expect(act.subtitulo, st);
      expect(act.pie, p);
      expect(act.color, c);
    });
  });
}

//void group(String s, Null Function() param1) {}
