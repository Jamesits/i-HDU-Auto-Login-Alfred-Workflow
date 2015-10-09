#!/usr/bin/env python3

from urllib import request, parse
import re
import os
from pathlib import PurePath

home = os.environ['HOME']
config = '.i-hdu'
path = PurePath(home).joinpath(config).as_posix()

def getInfo():
	try:
		with open(path, 'r') as f:
			#print('load user and password from ' + path)
			name = f.readline()[0:-1]
			pwd = f.readline()[0:-1]
			# print('user name:\t' + name[0:-1])
			# print('user pwd:\t' + pwd[0:-1])
			return (name, pwd)
	except FileNotFoundError as e:
		print('config file not found in ' + path)
		exit(1)

def login():
	name, pwd = getInfo()
	with request.urlopen('http://www.baidu.com') as f:
		stream = f.read()
		data = stream.decode('utf-8')
		result = re.search(r"location\.href=\"(.*)\"",data)
		if not result:
			print("You are already logged in! ")
			exit(2)
		else:
			url = parse.urljoin(result.group(1),'logon.cgi')
			data = parse.urlencode([
				('PtUser', name),
				('PtPwd', pwd),
				('PtButton', 'logon')
			])
			with request.urlopen(url, data=data.encode('utf-8')) as f:
				stream = f.read()
				print("Logged in successfully as " + name)
				exit(0)

login()