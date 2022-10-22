#!/usr/bin/python3
import argparse
import logging
import psycopg2
import textwrap
import time

def wait_for_postgres():
  for _ in range(5):
    try:
      with psycopg2.connect('') as connection:
        return
    except psycopg2.OperationalError as err:
      error_message = str(err)
      # e.g. could not connect to server: Connection refused
      # e.g. connection to server at "postgres" (192.168.32.2), port 5432 failed: Connection refused
      if 'Connection refused' in error_message:
        pass
      # e.g. the database system is starting up
      elif 'the database system is starting up' in error_message:
        pass
      # e.g. password authentication failed for user "alice"
      elif 'password authentication failed' in error_message:
        # NB this exception seems to happen immediately after creating the user.
        pass
      else:
        print(type(err), err)
      time.sleep(1)
  raise Exception('timeout waiting for postgres')

def sql_execute_scalar(sql):
  with psycopg2.connect('') as connection:
    with connection.cursor() as cursor:
      cursor.execute(sql)
      return cursor.fetchone()[0]

def wait_main(args):
  wait_for_postgres()
  print(f"PostgreSQL Version:        {sql_execute_scalar('select version()')}")
  print(f"PostgreSQL Server Address: {sql_execute_scalar('select inet_server_addr()')}")
  print(f"PostgreSQL Client Address: {sql_execute_scalar('select inet_client_addr()')}")
  print(f"PostgreSQL User:           {sql_execute_scalar('select current_user')}")
  print(f"PostgreSQL Database:       {sql_execute_scalar('select current_catalog')}")

def quote_main(args):
  wait_main(None)
  quote = sql_execute_scalar('''select text || ' -- ' || author from quote order by random() limit 1''')
  print(f"Random Quote:              {quote}")

def main():
  parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description=textwrap.dedent('''\
      tests access to PostgreSQL
      example:
        python3 %(prog)s -v wait
        python3 %(prog)s -v quote
      '''))
  parser.add_argument(
    '--verbose',
    '-v',
    default=0,
    action='count',
    help='verbosity level. specify multiple to increase logging.')
  subparsers = parser.add_subparsers(help='sub-command help')
  wait_parser = subparsers.add_parser('wait', help='wait for postgres to be ready')
  wait_parser.set_defaults(sub_command=wait_main)
  quote_parser = subparsers.add_parser('quote', help='show a random quote')
  quote_parser.set_defaults(sub_command=quote_main)
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

  args.sub_command(args)

main()
