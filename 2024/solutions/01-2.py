lefts = []
rights = []

with open("inputs/01", "r") as f:
    for line in f:
        left, right = line.split()

        lefts.append(int(left))
        rights.append(int(right))

print(sum(left * rights.count(left) for left in lefts))
