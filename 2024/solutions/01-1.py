def parse(line):
    return [int(id) for id in line.split()]


with open("inputs/01", "r") as f:
    lefts, rights = zip(*[parse(line) for line in f])

print(sum(abs(left - right) for left, right in zip(sorted(lefts), sorted(rights))))
