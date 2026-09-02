/*
Create a Database named DataWarehouse and create 3 schema inside it  gold , silver , bronze
*/
use master;
CREATE DATABASE DataWarehouse;

use DataWarehouse;
go
CREATE SCHEMA bronze;
go /*just like a seperator like execute individually*/
CREATE SCHEMA silver;
go
CREATE SCHEMA gold;
