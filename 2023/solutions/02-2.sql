with color_counts as (
  with lines as (
    select * from string_to_table(:'input', E'\n') line
  ),
  games as (
    with chunks as (
      select regexp_matches(line, '^Game (\d+): (.*)$') chunks
      from lines
    )
    select
      chunks[1]::int id,
      string_to_array(chunks[2], '; ') set_records
    from chunks
  ),
  sets as (
    select
      id game_id,
      generate_subscripts(set_records, 1) number,
      string_to_array(unnest(set_records), ', ') color_records
    from games
  ),
  chunks as (
    select
      game_id,
      number step_number,
      regexp_matches(unnest(color_records), '^(\d+) (red|green|blue)$') chunks
    from sets
  )
  select
    game_id,
    step_number,
    chunks[2] color,
    chunks[1]::int count
  from chunks
),
game_powers as (
  select
    game_id,
    max(count) filter (where color = 'red') *
      max(count) filter (where color = 'green') *
      max(count) filter (where color = 'blue') power
  from color_counts
  group by 1
)
select sum(power)
from game_powers;
