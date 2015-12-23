
import sys, os, itertools

# Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
# Rudolph can fly 3 km/s for 15 seconds, but then must rest for 28 seconds.
# Donner can fly 19 km/s for 9 seconds, but then must rest for 164 seconds.
# Blitzen can fly 19 km/s for 9 seconds, but then must rest for 158 seconds.
# Comet can fly 13 km/s for 7 seconds, but then must rest for 82 seconds.
# Cupid can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
# Dasher can fly 14 km/s for 3 seconds, but then must rest for 38 seconds.
# Dancer can fly 3 km/s for 16 seconds, but then must rest for 37 seconds.
# Prancer can fly 25 km/s for 6 seconds, but then must rest for 143 seconds.

class Reindeer(object):
  def __init__(self, name, speed, endurance, rest_period):
    self.name = name
    self.speed = speed
    self.endurance = endurance
    self.rest_period = rest_period

    self.position = 0
    self.resting = False
    self.time_spent_resting = 0
    self.time_until_rest = self.endurance

  def tick(self):
    if not self.resting and self.time_until_rest == 0:
      self.time_spent_resting = 0
      self.time_until_rest = self.endurance # reset
      self.resting = True

    if self.resting:
      self.time_spent_resting += 1
      if self.time_spent_resting == self.rest_period:
        self.resting = False # wake up
    else:
      self.position += self.speed
      self.time_until_rest -= 1

  def __repr__(self):
    return "{} at position {}{}".format(self.name, self.position, " (resting)" if self.resting else "")

  def __str__(self):
    return self.__repr__()

reindeer = [
  Reindeer('Vixen', 19, 7, 124),
  Reindeer('Rudolph', 3, 15, 28),
  Reindeer('Donner', 19, 9, 164),
  Reindeer('Blitzen', 19, 9, 158),
  Reindeer('Comet', 13, 7, 82),
  Reindeer('Cupid', 25, 6, 145),
  Reindeer('Dasher', 14, 3, 38),
  Reindeer('Dancer', 3, 16, 37),
  Reindeer('Prancer', 25, 6, 143)
]

test_reindeer = [Reindeer('Coment', 14, 10, 127), Reindeer('Dancer', 16, 11, 162)]

for i in xrange(0, 2503):
  for r in reindeer:
    r.tick()
print reindeer
winner = max(reindeer, key=lambda r: r.position)
print "The winner is {}".format(winner)

