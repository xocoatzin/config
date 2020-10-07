import pickle

import os
import os.path
import sys

import re
import math

import sched
import datetime
import time
import pytz
from dateutil.parser import parse

import http.client as httplib

from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request


def authenticate():
    print('Authenticating', flush=True)
    # If modifying these scopes, delete the file token.pickle.
    SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            print('Refreshing credentials', flush=True)
            creds.refresh(Request())
        else:
            print('Need to allow access', flush=True)
            flow = InstalledAppFlow.from_client_secrets_file('credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('calendar', 'v3', credentials=creds)
    return service

def join(*args):
    return ' '.join(str(e) for e in args if e)

def truncate(string, length):
    ellipsis = ' ...'
    if len(string) < length:
        return string
    return string[:length - len(ellipsis)] + ellipsis

def summary(text):
    return truncate(re.sub(r'X[0-9A-Za-z]+', '', text).strip(), 50)

def gray(text):
    return '%{F#999999}' + text + '%{F-}'

def formatdd(begin, end):
    minutes = math.ceil((end - begin).seconds / 60)

    if minutes == 1:
        return '1 min'

    if minutes < 60:
        return f'{minutes} min'

    hours = math.floor(minutes/60)
    rest_minutes = minutes % 60

    if hours > 5 or rest_minutes == 0:
        return f'{hours} hr'

    return '{}:{:02d} hr'.format(hours, rest_minutes)

def location(text):
    if text is None:
        return ''
    return f'{gray("in")} {text}'

def text(events, now):
    current = next((e for e in events if e['start'] < now and  now < e['end']), None)

    if not current:
        nxt = next((e for e in events if now <= e['start']), None)
        if nxt:
            return join(
                summary(nxt.get('summary', 'Untitled')),
                gray('starting in'),
                formatdd(now, nxt['start']),
                location(nxt['location'])
            )
        return ''

    nxt = next((e for e in events if e['start'] >= current['end']), None)
    if not nxt:
        return join(gray('End over'), formatdd(now, current['end']) + '!')

    if current['end'] == nxt['start']:
        return join(
            gray('Ends in'),
            formatdd(now, current['end']) + gray('.'),
            gray('and then'),
            summary(nxt.get('summary', 'Untitled')),
            location(nxt['location'])
        )

    return join(
        gray('Ends in'),
        formatdd(now, current['end']) + gray('.'),
        gray('and then'),
        summary(nxt.get('summary', 'Untitled')),
        location(nxt['location']),
        gray('after a break of'),
        formatdd(current['end'], nxt['start'])
    )


# def activate_course(event):
#     course = next(
#         (course for course in courses
#          if course.info['title'].lower() in event['summary'].lower()),
#         None
#     )

#     if not course:
#         return

#     courses.current = course


def main():
    scheduler = sched.scheduler(time.time, time.sleep)

    print('Initializing', flush=True)
    TZ = pytz.timezone(os.environ.get('TZ', 'Europe/Zurich'))
    # if 'TZ' not in os.environ:
    #     print("Warning: TZ environ variable not set")


    service = authenticate()

    print('Authenticated', flush=True)
    # Call the Calendar API
    now = datetime.datetime.now(tz=TZ)

    morning = now.replace(hour=6, minute=0, microsecond=0)
    evening= now.replace(hour=18, minute=59, microsecond=0)


    def did_decline(event):
        return len([i for i in event.get("attendees",[]) if i.get('self') and i.get("responseStatus") == "declined"]) > 0

    def get_events(calendar):
        print('Searching for events', flush=True)
        events_result = service.events().list(
            calendarId=calendar,
            timeMin=morning.isoformat(),
            timeMax=evening.isoformat(),
            singleEvents=True,
            orderBy='startTime'
        ).execute()
        events = events_result.get('items', [])
        #  __import__('pdb').set_trace()
        return [
            {
                'summary': event.get('summary', 'Untitled'),
                'location': event.get('location', None),
                'start': parse(event['start']['dateTime']),
                'end': parse(event['end']['dateTime'])
            }
            for event in events
            if 'dateTime' in event['start'] and not did_decline(event)
        ]

    events = get_events('primary')
    # events = get_events('primary') + get_events('school-calendar@import.calendar.google.com')
    # print('Done')

    DELAY = 60

    def print_message(events, counter):
        # Update every 5 iterations
        if counter % 5 == 0:
            events = get_events('primary')

        now = datetime.datetime.now(tz=TZ)
        print(text(events, now), flush=True)
        if now < evening:
            scheduler.enter(DELAY, 1, print_message, argument=(events, counter + 1,))

    # for event in events:
    #     # absolute entry, priority 1
    #     scheduler.enterabs(event['start'].timestamp(), 1, activate_course, argument=(event, ))

    # Immediate, priority 1
    scheduler.enter(0, 1, print_message, argument=(events, 1,))
    scheduler.run()


def wait_for_internet_connection(url, timeout=1):
    while True:
        conn = httplib.HTTPConnection(url, timeout=5)
        try:
            conn.request("HEAD", "/")
            conn.close()
            return True
        except:
            conn.close()

if __name__ == '__main__':
    os.chdir(sys.path[0])
    print('Waiting for connection', flush=True)
    wait_for_internet_connection('www.google.com')
    main()

