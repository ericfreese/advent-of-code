import math
import re


def violation_pattern(rule):
    first, second = rule.split("|")
    return re.compile(rf"\b{second}\b.*\b{first}\b")


def middle_number(update):
    numbers = update.split(",")
    return int(numbers[math.floor(len(numbers) / 2)])


with open("inputs/05", "r") as f:
    rules, updates = [t.strip().split() for t in f.read().split("\n\n")]

violation_patterns = [violation_pattern(rule) for rule in rules]


def is_valid(update):
    return not any(re.search(pattern, update) for pattern in violation_patterns)


valid_updates = [update for update in updates if is_valid(update)]
print(sum(middle_number(update) for update in valid_updates))
