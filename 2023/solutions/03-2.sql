with token_types (type, pattern) as (
  values
    ('number', '\d+'),
    ('symbol', '[^\d\.]+'),
    ('space', '\.+')
),
tokens as (
  with split_tokens as (
    select
      row_number() over () y,
      array(select (regexp_matches(line, (select string_agg(pattern, '|') from token_types), 'g'))[1]) tokens
    from string_to_table(:'input', E'\n') line
  ),
  indexed_tokens as (
    select
      y,
      generate_subscripts(tokens, 1) index,
      unnest(tokens) token
    from split_tokens
  ),
  typed_tokens as (
    select
      y,
      index,
      token,
      tt.type
    from indexed_tokens it
    inner join token_types tt on it.token ~ ('^' || tt.pattern || '$')
  ),
  positioned_tokens as (
    select
      y,
      sum(length(token)) over (partition by y order by index) - length(token) + 1 min_x,
      sum(length(token)) over (partition by y order by index) max_x,
      index,
      token,
      type
    from typed_tokens
  )
  select *
  from positioned_tokens
),
gears as (
  select s.y, s.index, s.token, exp(sum(ln(n.token::int)))::int ratio
  from tokens s
  inner join tokens n
    on n.type = 'number'
    and s.y between n.y - 1 and n.y + 1
    and int8range(s.min_x, s.max_x, '[]') && int8range(n.min_x - 1, n.max_x + 1, '[]')
  where s.type = 'symbol' and s.token = '*'
  group by 1, 2, 3
  having count(1) = 2
)
select sum(ratio)
from gears;
