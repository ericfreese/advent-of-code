import re

regex = r"(mul\((\d+),(\d+)\)|do\(\)|don't\(\))"

muls_enabled = True


def process(match):
    global muls_enabled

    val = match.group()

    if val.startswith("mul"):
        return int(match[2]) * int(match[3]) if muls_enabled else 0
    elif val.startswith("don't"):
        muls_enabled = False
    elif val.startswith("do"):
        muls_enabled = True

    return 0


with open("inputs/03", "r") as f:
    print(sum(process(match) for match in re.finditer(regex, f.read())))
