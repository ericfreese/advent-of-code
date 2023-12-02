with winds as (
  select
    row_number() over () - 1 num,
    direction
  from string_to_table(:'input', null) direction
),
shape_rocks (num, points) as (
  values
    (0, array[array[0, 0], array[1, 0], array[2, 0], array[3, 0]]),
    (1, array[array[1, 0], array[0, 1], array[1, 1], array[2, 1], array[1, 2]]),
    (2, array[array[0, 0], array[1, 0], array[2, 0], array[2, 1], array[2, 2]]),
    (3, array[array[0, 0], array[0, 1], array[0, 2], array[0, 3]]),
    (4, array[array[0, 0], array[1, 0], array[0, 1], array[1, 1]])
    --(0, 0, 0), (1, 1, 0), (1, 2, 0), (1, 3, 0),
    --(1, 1, 0), (2, 0, 1), (2, 1, 1), (2, 2, 1), (2, 1, 2),
    --(2, 0, 0), (3, 1, 0), (3, 2, 0), (3, 2, 1), (3, 2, 2),
    --(3, 0, 0), (4, 0, 1), (4, 0, 2), (4, 0, 3),
    --(4, 0, 0), (5, 1, 0), (5, 0, 1), (5, 1, 1)
),
simulation as (
  with recursive simulation as (
    select
      0 step,
      -1 rock_num,
      -1 wind_num,
      null::boolean falling,
      null::int x,
      null::int y
    union all
    select * from (
      with simulation as (
        select * from simulation
      ),
      nums as (
        -- should give only one row
        select distinct
          rock_num,
          wind_num
        from simulation
      ),
      fixed as (
        select * from simulation where not falling
      ),
      falling as (
        select * from simulation where falling
      ),
      next_nums as (
        select
          case
            when (select count(*) from falling) > 0 then
              rock_num
            else
              (rock_num + 1) % 5
          end rock_num,
          wind_num -- TODO
        from nums
      )
      select
        step + 1,
        nn.rock_num,
        nn.wind_num,
        falling,
        x,
        y
      from simulation
      cross join next_nums nn
      where step + 1 < 10
    ) q
  )
  select * from simulation
)
select * from simulation
--select
--  string_agg(
--    case
--      when sr.x is not null then '#'
--      else '.'
--    end,
--    ''
--    order by bx.x
--  )
--from generate_series(0, 5) bx(x)
--cross join generate_series(0, 5) by(y)
--left join shape_rocks sr
--  on sr.x = bx.x and sr.y = by.y and sr.num = 4
--group by by.y
