# Day 17 – Install and Configure PostgreSQL

## Task
The Nautilus application development team has shared that they are planning to deploy one newly developed application on Nautilus infra in Stratos DC. The application uses PostgreSQL database, so as a pre-requisite we need to set up PostgreSQL database server as per requirements shared below:


PostgreSQL database server is already installed on the Nautilus database server.


a. Create a database user kodekloud_roy and set its password to GyQkFRVNr3.


b. Create a database kodekloud_db7 and grant full permissions to user kodekloud_roy on this database.


Note: Please do not try to restart PostgreSQL server service.


## Objective
Provision a PostgreSQL database and user for an upcoming application deployment on Nautilus infrastructure.

> PostgreSQL is already installed.  
>  Do **not** restart the PostgreSQL service.

---

## Step 1: Switch to the PostgreSQL System User

PostgreSQL administrative tasks are executed using the `postgres` OS user.

```bash
sudo su - postgres
````

Access the PostgreSQL interactive terminal:

```bash
psql
```

---

## Step 2: Create Database User

Create the required database role with login privileges and password authentication.

```sql
CREATE USER kodekloud_roy WITH PASSWORD 'GyQkFRVNr3';
```

Verify:

```sql
\du
```

---

## Step 3: Create the Database

Create the required database:

```sql
CREATE DATABASE kodekloud_db7;
```

Verify:

```sql
\l
```

---

## Step 4: Grant Full Privileges

Grant full access on the database to the created user:

```sql
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db7 TO kodekloud_roy;
```

This ensures:

* Connection access
* Schema modification
* Table creation
* Data manipulation

---

## Step 5: Exit PostgreSQL

```sql
\q
exit
```

---

## Validation

Test login using the new user:

```bash
psql -U kodekloud_roy -d kodekloud_db7 -W
```

If prompted for password and login succeeds, configuration is complete.

---

## Result

*  Database user `kodekloud_roy` created
*  Database `kodekloud_db7` created
*  Full privileges granted
*  No PostgreSQL service restart performed

The environment is now ready for application deployment.
