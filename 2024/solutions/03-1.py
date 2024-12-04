import re

regex = r"mul\((\d+),(\d+)\)"

with open("inputs/03", "r") as f:
    print(sum(int(match[1]) * int(match[2]) for match in re.finditer(regex, f.read())))
