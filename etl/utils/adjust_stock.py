def adjust_quantity_column(df):
    if 'cantidad' in df.columns:
        print("Columna 'cantidad' encontrada. Ajustando valores para eliminar el signo...")
        df['cantidad'] = df['cantidad'].abs()
    else:
        print("Columna 'cantidad' no encontrada. No se realizó ningún ajuste.")
    return df