with number_names (number, name) as (
  values
    (0, 'zero'),
    (1, 'one'),
    (2, 'two'),
    (3, 'three'),
    (4, 'four'),
    (5, 'five'),
    (6, 'six'),
    (7, 'seven'),
    (8, 'eight'),
    (9, 'nine')
),
lines as (
  select row_number() over () id, line
  from string_to_table(:'input', E'\n') line
),
left_trimmed as (
  select
    id line_id,
    regexp_replace(
      line,
      '^.*?(?=([0-9]|' || (select string_agg(name, '|') from number_names) || '))',
      ''
    ) line
  from lines
),
fully_trimmed as (
  select
    line_id,
    reverse(
      regexp_replace(
        reverse(line),
        '^.*?(?=([0-9]|' || (select string_agg(reverse(name), '|') from number_names) || '))',
        ''
      )
    ) line
  from left_trimmed
),
replaced as (
  with recursive replaced as (
    select
      (select min(number) from number_names) - 1 number,
      line_id,
      line replaced_line
    from fully_trimmed
    union all
    select
      r.number + 1,
      line_id,
      regexp_replace(replaced_line, '(^' || nn.name || '|' || nn.name || '$)', nn.number::varchar, 'g')
    from replaced r
    inner join number_names nn on nn.number = r.number + 1
  )
  select distinct on (line_id)
    line_id,
    replaced_line line
  from replaced
  order by line_id, number desc
)
select sum((left(line, 1) || right(line, 1))::int)
from replaced;
