select sum((left(regexp_replace(line, '^[^\d]*', ''), 1) || right(regexp_replace(line, '[^\d]*$', ''), 1))::int)
from string_to_table(:'input', E'\n') line;
