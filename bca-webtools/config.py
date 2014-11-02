#!/usr/bin/python
# coding=UTF-8
#
# bca-webtools: Disk Image Access for the Web
# Copyright (C) 2014
# All rights reserved.
#
# This code is distributed under the terms of the GNU General Public
# License, Version 3. See the text file "COPYING" for further details
# about the terms of this license.
#
# This file contains items that can be configured in DIMAC.
#
# IMAGEDIR - the local directory containing your disk images
# SQLALCHEMY_DATABASE_URI - the local db URI (you must configure a postgres
#                           database before running the main script.

IMAGEDIR = "/home/bcadmin/disk_images"
SQLALCHEMY_DATABASE_URI = "postgresql://bcadmin:bcadmin@localhost/bcdb"
