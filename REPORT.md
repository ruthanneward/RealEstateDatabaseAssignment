# Real Estate Database Normalization Report 

**Objective**

The objective of this assignment is to gain a conceptual understanding of the 3NF and 4NF normalization rules and apply those rules to a database of real estate data.

**Methods**

First, I created and populated a table that was already in 2NF. This table is in 2NF becuase: 
- Each column holds atomic, indivisible values.
- Rows are uniquely identifiable by PropertyID.
- It does not have a primary composite key, making partial-dependency issues obsolete.

   `CREATE TABLE PropertyDetails (
    PropertyID SERIAL PRIMARY KEY, 
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50),
    ZoningType VARCHAR(100),
    Utility VARCHAR(100),
    GeoLocation GEOMETRY(Point, 4326), 
    CityPopulation INT);`

  `INSERT INTO PropertyDetails (PropertyID, Address, City, State, Country, ZoningType, Utility, GeoLocation, CityPopulation) VALUES
  (1, '123 Main St', 'Springfield', 'MA', 'United States', 'Industry', 'Porch', ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326), 169180),
  (2, '261 Union St', ' West Springfield', 'MA', 'United States', 'Commercial', 'Restroom', ST_GeomFromText('POINT(-72.616554 42.102650)', 4326), 28840),
  (3, '222 Dewey St', 'Worcester', 'MA', 'United States', 'Residential', 'Dishwasher', ST_GeomFromText('POINT (-71.823658 42.254547)', 4326), 2006520);`

Next, I normalized the PropertyDetails table into 3NF by removing transitive dependencies. Transitive dependencies are indirect relationships that cause functional dependencies. In this example CityPopulation column is dependent on the City Column. This dependency is fixed by creating a seperate column that contains the city, state, country and city population. 

`CREATE TABLE CityDemographics (
    City VARCHAR(100) PRIMARY KEY, -- Assign City as the Primary Key.
    State VARCHAR(50),
    Country VARCHAR(50),
    CityPopulation INT
);`

I inserted the data into the new table.

INSERT INTO CityDemographics (City, State, Country, CityPopulation) VALUES
('Springfield', 'MA', 'United States', 169180),
('West Springfield', 'MA', 'United States', 28840),
('Worcester', 'MA', 'United States', 2006520);`

Then I altered the origional table to remove the citypopulation, state and country column. The tables both still have the city column.  

`ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;`

Next, I normalized the PropertyDetails table into 4NF by removing multi-value dependencies. Multi value dependencies happen when a combination of attributes can determine another attribute. In this example, I seperated the origional table into three tables, each with their own subject. This ensures that there are no multi-value dependencies between the property ID, Zoning information and utility information.  

`CREATE TABLE PropertyZoning (
    PropertyZoningID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    ZoningType VARCHAR(100)
);`

`CREATE TABLE PropertyUtilities (
    PropertyUtilityID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    Utility VARCHAR(100)
);`

I then deleted the zoning type and utility columns from the origional table. 

`ALTER TABLE PropertyDetails DROP COLUMN ZoningType, DROP COLUMN Utility;`

Finally, I used PostGIS to perform a spatial query on the data. I used the function 'ST_DWithin' to select all of the properties that were within a 10km radius of 123 Main St, Springfield, MA. 

`SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);`

**Results**

The output of the normalization process is 4 seperate tables:

1. PropertyDetails

![PropertyDetails](https://github.com/ruthanneward/RealEstateDatabaseAssignment/assets/98286245/a5fbfbcb-8256-4061-a3d9-a2bd2d1eab06)

2. CityDemographics

![CityDemographics](https://github.com/ruthanneward/RealEstateDatabaseAssignment/assets/98286245/89b8f2a2-fd04-4dfe-b981-cb3126abfa75)

3. PropertyZoning

![PropertyZoning](https://github.com/ruthanneward/RealEstateDatabaseAssignment/assets/98286245/e5bb26eb-473f-4a4e-9c3f-f0d95dabe725)

4. PropertyUtilities

![PropertyUtilities](https://github.com/ruthanneward/RealEstateDatabaseAssignment/assets/98286245/838e2519-3fd5-4f29-82e1-a6af7de60e35)

The spatial query showed that all three locations are within 10km of 123 Main St, Springfield MA. 

![SpatialQueryOutput](https://github.com/ruthanneward/RealEstateDatabaseAssignment/assets/98286245/08d7b98a-510c-4484-ad94-a5ad63e6076c)

