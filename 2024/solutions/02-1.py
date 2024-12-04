def same_sign(num1, num2):
    return num1 * num2 > 0


def is_safe(report):
    deltas = [next - curr for curr, next in zip(report, report[1:])]
    return all(same_sign(deltas[0], d) and abs(d) in range(1, 4) for d in deltas)


def check(line):
    report = [int(level) for level in line.split()]
    return is_safe(report)


with open("inputs/02", "r") as f:
    print(sum(1 if check(line) else 0 for line in f))
