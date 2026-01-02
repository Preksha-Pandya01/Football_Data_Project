import json
import pandas as pd
import boto3
import io
import yaml
from io import StringIO

s3_client = boto3.client('s3')

# -----------------------------
# Load CSV data from S3
# -----------------------------
def load_data(table_name):
    table_key = f"Football-Dataset/Dataset/{table_name}.csv"
    obj = s3_client.get_object(Bucket='preksha-bucket-1', Key=table_key)
    return pd.read_csv(obj["Body"])


# -----------------------------
# Load YAML validation rules from S3
# -----------------------------
def load_rules(table_name):
    rules_key = f"Football-Dataset/Validation_Rules/{table_name}.yaml"
    obj = s3_client.get_object(Bucket='preksha-bucket-1', Key=rules_key)
    return yaml.safe_load(obj["Body"].read().decode("utf-8"))





def validate_data(df, rules):

    df = df.copy()
    error_msgs = pd.Series("", index=df.index)
    special_characters = ('!', '#', '$', '%', '^', '&', '*', '(', ')', '\\', '/', '.', '<', '>', '?', ';', ':')

    # --- Handle unique constraint ---
    unique_cols = [c["name"] for c in rules.get("columns", []) if c.get("unique")]
    if unique_cols:
        dup_mask = df.duplicated(subset=unique_cols, keep=False)
        error_msgs[dup_mask] += "Duplicate values in unique columns; "

    # --- Go column by column ---
    for col_rule in rules.get("columns", []):
        col_name = col_rule["name"]
        if col_name not in df.columns:
            continue

        col = df[col_name]
        dtype = col_rule.get("type")

        # --- Required field check ---
        if col_rule.get("required"):
            missing = col.isna() | (col.astype(str).str.strip() == "")
            error_msgs[missing] += f"{col_name} is required; "

        # --- Type checks ---
        if dtype == "integer":
            numeric = pd.to_numeric(col, errors="coerce")
            invalid_type = numeric.isna()
            error_msgs[invalid_type] += f"{col_name} must be an integer; "

            if "min" in col_rule:
                too_low = numeric < col_rule["min"]
                error_msgs[too_low] += f"{col_name} must be >= {col_rule['min']}; "
            if "max" in col_rule:
                too_high = numeric > col_rule["max"]
                error_msgs[too_high] += f"{col_name} must be <= {col_rule['max']}; "

        elif dtype == "float":
            numeric = pd.to_numeric(col, errors="coerce")
            invalid_type = numeric.isna()
            error_msgs[invalid_type] += f"{col_name} must be a float; "

            if "min" in col_rule:
                too_low = numeric < col_rule["min"]
                error_msgs[too_low] += f"{col_name} must be >= {col_rule['min']}; "
            if "max" in col_rule:
                too_high = numeric > col_rule["max"]
                error_msgs[too_high] += f"{col_name} must be <= {col_rule['max']}; "

        elif dtype == "date":
            parsed = pd.to_datetime(col, format=col_rule.get("format", "%Y-%m-%d"), errors="coerce")
            invalid_date = parsed.isna() 
            error_msgs[invalid_date] += f"{col_name} has invalid date format; "


        # --- Allowed values check ---
        if "allowed" in col_rule:
            allowed = [str(x).lower().strip() for x in col_rule["allowed"]]  # gives the list of all the allowed values from the col_rules
            invalid_allowed = ~col.astype(str).str.lower().str.strip().isin(allowed) # gives the boolean values based on the vaues in the dataframe's respective column by checking the values from the rules' allowed and then inverts the boolean value
            error_msgs[invalid_allowed] += f"{col_name} must be one of {col_rule['allowed']}; "

        if "regex" in col_rule:
            pattern = col_rule["regex"]
            invalid_regex = ~col.astype(str).str.match(pattern, na=True)
            error_msgs[invalid_regex] += f"{col_name} does not match required pattern; "


    # --- 3️⃣ Split valid vs invalid ---
    df["error_message"] = error_msgs.str.strip() #removes extra spaces for better readability
    valid_df = df[df["error_message"] == ""].drop(columns=["error_message"])
    invalid_df = df[df["error_message"] != ""]

    return valid_df, invalid_df


# Save validated data to S3
# -----------------------------
def save_to_s3(table_name, valid_df, invalid_df):
    today = pd.Timestamp.today().strftime("%Y-%m-%d")

    if not valid_df.empty:
        buf = StringIO()
        valid_df.to_csv(buf, index=False)
        key = f"Football-Dataset/Validated_tables/{today}/{table_name}.csv"
        s3_client.put_object(Bucket='preksha-bucket-1', Key=key, Body=buf.getvalue())

    if not invalid_df.empty:
        buf = StringIO()
        invalid_df.to_csv(buf, index=False)
        key = f"Football-Dataset/Quarantine_tables/{today}/{table_name}.csv"
        s3_client.put_object(Bucket='preksha-bucket-1', Key=key, Body=buf.getvalue())


# -----------------------------
# Master validation function
# -----------------------------
def validate_data_with_rules(table_name):
    df = load_data(table_name)
    rules = load_rules(table_name)
    valid_df, invalid_df = validate_data(df, rules)
    save_to_s3(table_name, valid_df, invalid_df)

    print(f"Validation complete for {table_name} | Valid: {len(valid_df)}, Invalid: {len(invalid_df)}")


# -----------------------------
# Lambda Handler
# -----------------------------
def lambda_handler(event, context):
    # for sqs_record in event["Records"]:
    #     message_body = json.loads(sqs_record["body"])
    #     for record in message_body["Records"]:
    #         object_key = record["s3"]["object"]["key"]
    #         table_name = object_key.split("/")[2].split(".")[0]

    #         print(f"Starting validation for {table_name}")
    #         try:
    #             validate_data_with_rules(table_name)
    #         except Exception as e:
    #             print(f"Error validating {table_name}: {e}")

    message_body = json.loads(event['Records'][0]['body'])
    object_key = message_body['Records'][0]['s3']['object']['key']
    table_name = object_key.split('/')[2].split('.')[0]
    print(f"Starting validation for {table_name}")
    validate_data_with_rules(table_name)
    print(f"Validation complete for {table_name}")
