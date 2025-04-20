def safe_decode_column(df):
    for column in df.select_dtypes(include=['object']).columns:
        df[column] = df[column].apply(
            lambda x: x.encode('latin1').decode('utf-8', errors='replace') if isinstance(x, str) else x
        )
    return df