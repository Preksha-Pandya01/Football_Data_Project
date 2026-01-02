-- ** SSC-EWI-0001 - UNRECOGNIZED TOKEN ON LINE '1' COLUMN '1' OF THE SOURCE CODE STARTING AT 'CREATE'. EXPECTED 'STATEMENT' GRAMMAR. **
--CREATE EXTENSION aws_s3 CASCADE
                               ;
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "aws_commons.create_aws_credentials" **
SELECT aws_commons.create_aws_credentials(
  'key id',    -- access key id
  'secret key',
  'region'   -- region
) !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'aws_commons.create_aws_credentials' NODE ***/!!!



-- ** SSC-EWI-0001 - UNRECOGNIZED TOKEN ON LINE '11' COLUMN '1' OF THE SOURCE CODE STARTING AT 'CREATE'. EXPECTED 'STATEMENT' GRAMMAR. LAST MATCHING TOKEN WAS ';' ON LINE '7' COLUMN '2'. FAILED TOKEN WAS 'CREATE' ON LINE '11' COLUMN '1'. **
--CREATE EXTENSION IF NOT EXISTS anon CASCADE
                                           ;
--** SSC-FDM-0007 - MISSING DEPENDENT OBJECT "anon.init" **
SELECT anon.init() !!!RESOLVE EWI!!! /*** SSC-EWI-0073 - PENDING FUNCTIONAL EQUIVALENCE REVIEW FOR 'anon.init' NODE ***/!!!;