#!/usr/bin/python

import sys


def main():

  if len(sys.argv) < 2:
     print "ERR - Insufficient arguments - provide at least one argument"
     sys.exit(1)

  print len(sys.argv)

  a1 = sys.argv[1]
  print a1

  url = 'http://' + a1
  print url

if __name__ == '__main__':
    main()
