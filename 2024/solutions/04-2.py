def cell_value(grid, row, col):
    chars = grid[row] if row >= 0 and row < len(grid) else []
    return chars[col] if col >= 0 and col < len(chars) else None


def search(grid, row, col, row_dir, col_dir):
    return all(
        cell_value(grid, row + (i * row_dir), col + (i * col_dir)) == char
        for i, char in [(-1, "M"), (0, "A"), (1, "S")]
    )


def check(grid, row, col):
    directions = [
        (1, 1),
        (1, -1),
        (-1, 1),
        (-1, -1),
    ]

    return sum(
        1 if search(grid, row, col, row_dir, col_dir) else 0
        for row_dir, col_dir in directions
    )


with open("inputs/04", "r") as f:
    grid = [list(line.strip()) for line in f]

    print(
        sum(
            1 if check(grid, row, col) == 2 else 0
            for row, chars in enumerate(grid)
            for col in range(len(chars))
        )
    )
