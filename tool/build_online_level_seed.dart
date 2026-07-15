import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln(
      'Usage: dart run tool/build_online_level_seed.dart <output>',
    );
    exitCode = 64;
    return;
  }

  final levels = <Map<String, dynamic>>[];
  for (var start = 1; start <= 500; start += 50) {
    final end = start + 49;
    final path = 'assets/levels/levels_${_pad(start)}_${_pad(end)}.json';
    final chunk = jsonDecode(File(path).readAsStringSync()) as Map;
    levels.addAll(
      (chunk['levels'] as List).map(
        (value) => Map<String, dynamic>.from(value as Map),
      ),
    );
  }

  if (levels.length != 500) {
    throw StateError('Expected 500 campaign levels, found ${levels.length}.');
  }

  final sql = StringBuffer()
    ..writeln(
      '-- Generated from assets/levels by tool/build_online_level_seed.dart.',
    )
    ..writeln('insert into public.game_level_versions (')
    ..writeln(
      '  level_id, version, definition_format, coordinate_space, definition',
    )
    ..writeln(') values');

  for (var index = 0; index < levels.length; index++) {
    final level = levels[index];
    final id = level['id'] as int;
    final json = jsonEncode(level).replaceAll("'", "''");
    sql
      ..write("  ($id, 1, 'campaign_v1', 'normalized_v1', ")
      ..write("'")
      ..write(json)
      ..write("'::jsonb)")
      ..writeln(index == levels.length - 1 ? '' : ',');
  }

  sql
    ..writeln('on conflict (level_id, version) do nothing;')
    ..writeln()
    ..writeln('insert into public.game_levels (')
    ..writeln('  level_id, published_version, definition_format,')
    ..writeln('  coordinate_space, definition, updated_at, published_at')
    ..writeln(')')
    ..writeln('select')
    ..writeln('  level_id, version, definition_format, coordinate_space,')
    ..writeln('  definition, published_at, published_at')
    ..writeln('from public.game_level_versions')
    ..writeln('where version = 1')
    ..writeln('on conflict (level_id) do nothing;');

  File(arguments.single).writeAsStringSync(sql.toString());
}

String _pad(int value) => value.toString().padLeft(3, '0');
