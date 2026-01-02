CREATE EXTENSION aws_s3 CASCADE;

SELECT aws_commons.create_aws_credentials(
  'YOUR ACCESS KEY ID',    -- access key id
  'YOUR SECRET ACCESS KEY',
  'YOUR REGION'   -- region
);



CREATE EXTENSION IF NOT EXISTS anon CASCADE;
SELECT anon.init();
        