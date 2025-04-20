def adjust_quantity_column(df):
    if 'cantidad' in df.columns:
        print("Columna 'cantidad' encontrada. Ajustando valores para eliminar el signo...")
        df['cantidad'] = df['cantidad'].abs()
    else:
        print("Columna 'cantidad' no encontrada. No se realizó ningún ajuste.")
    if 'acceso' in df.columns:
        print("Columna 'acceso' encontrada. Convirtiendo valores a booleano...")
        df['acceso'] = df['acceso'].astype(bool)
    else:
        print("Columna 'acceso' no encontrada. No se realizó conversión a booleano.")
    return df