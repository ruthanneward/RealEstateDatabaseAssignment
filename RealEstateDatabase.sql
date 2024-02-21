-- Title: Normalizing Spatial Data in a Real Estate Database
-- Author: Ruthanne Ward
-- Description: This SQL File normalizes a database of real estate data from 2NF to 3NF and 4NF. It also used spatial 
-- querys to find properties within a 10km radius of 123 Main St, Springfield. 

-- Create table PropertyDetails.
CREATE TABLE PropertyDetails (
    PropertyID SERIAL PRIMARY KEY, -- Assign PropertyID as the Primary Key.
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50),
    ZoningType VARCHAR(100),
    Utility VARCHAR(100),
    GeoLocation GEOMETRY(Point, 4326), -- Spatial data type
    CityPopulation INT
);

-- Insert Data into PropertyDetails.
INSERT INTO PropertyDetails (PropertyID, Address, City, State, Country, ZoningType, Utility, GeoLocation, CityPopulation) VALUES
(1, '123 Main St', 'Springfield', 'MA', 'United States', 'Industry', 'Porch', ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326), 169180),
(2, '261 Union St', ' West Springfield', 'MA', 'United States', 'Commercial', 'Restroom', ST_GeomFromText('POINT(-72.616554 42.102650)', 4326), 28840),
(3, '222 Dewey St', 'Worcester', 'MA', 'United States', 'Residential', 'Dishwasher', ST_GeomFromText('POINT (-71.823658 42.254547)', 4326), 2006520);

-- Normalize to 3NF by creating a new table, CityDemographics and modifying the PropertyDetails table.
-- Creating the CityDemographics table ensures that all the attributes in PrertyDetails are directly dependent on the primary key
-- The CityDemographics table removes the transitive dependency of CityPopulation
CREATE TABLE CityDemographics (
    City VARCHAR(100) PRIMARY KEY, -- Assign City as the Primary Key.
    State VARCHAR(50),
    Country VARCHAR(50),
    CityPopulation INT
);

-- Insert data into CityDemographics
INSERT INTO CityDemographics (City, State, Country, CityPopulation) VALUES
('Springfield', 'MA', 'United States', 169180),
('West Springfield', 'MA', 'United States', 28840),
('Worcester', 'MA', 'United States', 2006520);

--Adjust PropertyDetails table to drop columns that were seperated into their own tables. 
ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;

-- Normalize to 4NF by creating two new tables, PropertyZoning and PropertyUtilities. 
-- Seperating ZoningType and Utility into their own tables elimiates their multi-valued dependencies.

-- Create table PropertyZoning
CREATE TABLE PropertyZoning (
    PropertyZoningID SERIAL PRIMARY KEY, -- Assign PropertyZoningID as the Primary Key.
    PropertyID INT REFERENCES PropertyDetails(PropertyID), -- Connect the PropertyZoning table to the PropertyDetails Table by referencing the PropertyID column.
    ZoningType VARCHAR(100));

-- Insert data into PropertyZoning.
INSERT INTO PropertyZoning (PropertyZoningID, PropertyID, ZoningType) VALUES
(1, 1, 'Industry'),
(2, 2, 'Commercial'),
(3, 3, 'Residential');

-- Create table PropertyUtilities.
CREATE TABLE PropertyUtilities (
    PropertyUtilityID SERIAL PRIMARY KEY,  -- Assign PropertyUtilityID as the Primary Key.
    PropertyID INT REFERENCES PropertyDetails(PropertyID), -- Connect the PropertyUtilityID table to the PropertyDetails Table by referencing the PropertyID column.
    Utility VARCHAR(100)
);

-- Insert data into PropertyUtilites.
INSERT INTO PropertyUtilities (PropertyUtilityID, PropertyID, Utility) VALUES
(1, 1, 'Porch'),
(2, 2, 'Restroom'),
(3, 3, 'Dishwasher');

--Adjust PropertyDetails table to drop columns that were seperated into their own tables.
ALTER TABLE PropertyDetails DROP COLUMN ZoningType, DROP COLUMN Utility;

-- Spatial Data Manipulation

-- Query Properties within a radius of 10km.
SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);
