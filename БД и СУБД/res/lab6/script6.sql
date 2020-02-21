WITH RECURSIVE actual_addrobj AS
    ( SELECT *
     FROM addrobj
     WHERE currstatus = 0 ),
               nested AS
    ( SELECT concat(formalname, ' ', shortname) AS full_name,
             aoguid,
             aolevel
     FROM actual_addrobj
     WHERE parentguid IS NULL
     UNION ALL SELECT concat(nested.full_name, ' | ', actual_addrobj.shortname, '. ', actual_addrobj.formalname),
                      actual_addrobj.aoguid,
                      actual_addrobj.aolevel
     FROM nested
     JOIN actual_addrobj ON nested.aoguid = actual_addrobj.parentguid
     WHERE currstatus = 0 )
SELECT *
FROM nested
WHERE full_name ILIKE '%ленин%';

-- LIMIT 1000;
