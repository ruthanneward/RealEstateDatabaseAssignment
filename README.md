# Real Estate Database Assignment 
## Author: Ruthanne Ward
## Class: Spatial Database
## Assignment: Lab 3 
## Description: During this lab I populated a table with real estate data and normalized this table to 3NF and 4NF through seperating the initial table into multiple related tables. I also performed a spatial query to determine the properties that were within a 10km radius of 123 Main St, Springfield, MA.

**Repository Contents**

This repository includes: 
1. The lab report titled REPORT.md. This file details the objectives, methods and results of the assignment.
2. The SQL file titled RealEstateDatabase.sql. This file includes the SQL querys that were used to execute the assignment.
3. A .gitignore file that is used to ensure that no unwanted files are being pushed to the repository.

**Setup Instructions**

Prior to starting the assignment I created a database:

`CREATE DATABASE "RealEstateDB";`

Next I connected to the database:

`\c RealEstateDB`

and enabled PostGIS:

`CREATE EXTENSION IF NOT EXISTS postgis;`
