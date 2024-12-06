def parse(line):
    return [int(id) for id in line.split()]


with open("inputs/01", "r") as f:
    lefts, rights = zip(*[parse(line) for line in f])

print(sum(left * rights.count(left) for left in lefts))
