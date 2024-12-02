lefts = []
rights = []

with open("inputs/01", "r") as f:
    for line in f:
        left, right = line.split()

        lefts.append(int(left))
        rights.append(int(right))

print(sum(abs(left - right) for left, right in zip(sorted(lefts), sorted(rights))))
