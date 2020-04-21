CREATE ROLE myrole;

DROP ROLE myrole;

SELECT rolname FROM pg_roles;

TABLE pg_roles;

CREATE ROLE login_role LOGIN;
CREATE USER my_user;

CREATE ROLE my_su SUPERUSER;

CREATE ROLE createdb_role CREATEDB;

-- CREATEROLE;

-- REPLICATION LOGIN;

CREATE ROLE role_w_p PASSWORD '1234';

ALTER ROLE myrole CREATEDB;

-- ALTER ROLE myrole SET enable_indexscan TO off;
-- ALTER ROLE myrole RESET enable_indexscan;

CREATE ROLE mygroup;
GRANT mygroup TO myrole;
REVOKE mygroup FROM myrole;

CREATE ROLE ivan LOGIN INHERIT; -- NOINHERIT

SET ROLE myrole;
SET ROLE NONE;
RESET ROLE;

ALTER TABLE spaceships OWNER TO myrole;

REASSIGN OWNED BY myrole TO postgres; -- For each DB
DROP OWNED BY myrole; -- For each DB
DROP ROLE myrole;

-- SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE, CONNECT, TEMPORARY, EXECUTE, USAGE

GRANT UPDATE ON spaceships TO ivan;
REVOKE ALL ON accounts FROM PUBLIC; -- PUBLIC => to all roles

ALTER DEFAULT PRIVILEGES

GRANT SELECT ON mytable TO PUBLIC;
GRANT SELECT, UPDATE, INSERT ON mytable TO admin;
GRANT SELECT (col1), UPDATE (col1) ON mytable TO miriam_rw;

ALTER TABLE spaceships ENABLE ROW LEVEL SECURITY;

-- BYPASSRLS
ALTER TABLE spaceships FORCE ROW LEVEL SECURITY;

CREATE POLICY
ALTER POLICY
DROP POLICY

CREATE TABLE accounts (manager text, company text, contact_email text);
CREATE POLICY accounts_managers ON accounts TO managers
    USING (manager = current_user);

CREATE POLICY user_policy ON users
    USING (user_name = current_user)

CREATE POLICY user_sel_policy ON users
    FOR SELECT
    USING (true); -- OR
CREATE POLICY user_mod_policy ON users
    USING (user_name = current_user)

CREATE POLICY admin_all ON passwd TO admin USING (true) WITH CHECK (true);

CREATE POLICY admin_local_only ON passwd AS RESTRICTIVE TO admin
    USING (pg_catalog.inet_client_addr() IS NULL);
