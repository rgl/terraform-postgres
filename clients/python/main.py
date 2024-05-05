#!/usr/bin/python3
import argparse
import logging
import psycopg2
import textwrap

def sql_execute_scalar(sql):
  with psycopg2.connect('') as connection:
    with connection.cursor() as cursor:
      cursor.execute(sql)
      return cursor.fetchone()[0]

def quote_main(args):
  quote = sql_execute_scalar('''select text || ' -- ' || author from quote order by random() limit 1''')
  print(f"Random Quote: {quote}")

def main():
  parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description=textwrap.dedent('''\
      Use PostgreSQL from Python.
      example:
        python3 %(prog)s -v
      '''))
  parser.add_argument(
    '--verbose',
    '-v',
    default=0,
    action='count',
    help='verbosity level. specify multiple to increase logging.')
  args = parser.parse_args()

  LOGGING_FORMAT = '%(asctime)-15s %(levelname)s %(name)s: %(message)s'
  if args.verbose >= 3:
    logging.basicConfig(level=logging.DEBUG, format=LOGGING_FORMAT)
    from http.client import HTTPConnection
    HTTPConnection.debuglevel = 1
  elif args.verbose >= 2:
    logging.basicConfig(level=logging.DEBUG, format=LOGGING_FORMAT)
  elif args.verbose >= 1:
    logging.basicConfig(level=logging.INFO, format=LOGGING_FORMAT)

  quote_main(args)

main()
