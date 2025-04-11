from fastapi import HTTPException
from asyncpg import Connection
from utils.api_response import api_response
from repositories.formula_repo import add_formula_query, get_formula_query, get_by_id_formula_query, delete_formula_query, update_formula_query, exist_formula_query, get_by_id_formula_query, get_by_tag_formula_query
from services.indicator_service import fetch_indicator, fetch_indicator_value, fetch_indicator_str, fetch_indicator_grouped
from schemas.target import FormulaBase, FormulaCreate
from sympy.parsing.latex import parse_latex
from sympy import Symbol
import pandas as pd
import re

async def get_formulas(db: Connection):
    row = await get_formula_query(db)
    if not row:
        return api_response("Formula not found", False)
    return api_response("Formula retrieved successfully", True, row)

async def get_formula(db: Connection, formula_id: int):
    row = await get_by_id_formula_query(db, formula_id)
    if not row:
        return api_response("Formula not found", False)
    return api_response("Formula retrieved successfully", True, dict(row))

async def get_formula_tag(db: Connection, tag_id: int):
    row = await get_by_tag_formula_query(db, tag_id)
    if not row:
        return api_response("Formula not found", False)
    return api_response("Formula retrieved successfully", True, row)

async def add_formula(db: Connection, formula_data: FormulaCreate):
    row = await add_formula_query(db, formula_data)
    return api_response("Formula created successfully", True, dict(row))

async def update_formula(db: Connection, formula: FormulaCreate, formula_id:int):
    row = await update_formula_query(db, formula_id, formula)
    if not row:
        return api_response("Formula not found", False)
    return api_response("Formula updated successfully", True, dict(row))

async def delete_formula(db: Connection, formula_id: int):
    row = await delete_formula_query(db, formula_id)
    if not row:
        return api_response("Formula not found", False)
    return api_response("Formula deleted successfully", True, dict(row))

async def exist_formula(db: Connection, formula:FormulaBase):
    rows = await exist_formula_query(db, formula)
    value = rows["count"] == 1
    return api_response("Etiquetas listadas correctamente", True, value)

async def calc_formula(db: Connection, formula_id: int):
    row = await get_by_id_formula_query(db, formula_id)
    if not row:
        raise HTTPException(status_code=404, detail="Formula not found")

    formula_latex = row["formula"]  # Se asume que la columna en la BD se llama "formula"

    
        # Detectar agregaciones (SUM, AVG, COUNT) y las variables asociadas
    agregaciones = re.findall(r"(SUM|AVG|COUNT)\\left\((\w+)\\right\)", formula_latex)

    valores = {}

        # Obtener los valores agregados desde la base de datos
    for funcion, variable in agregaciones:
        print(f"Buscando indicador: función={funcion}, variable={variable}")
        valor_record = await fetch_indicator(db, variable, funcion)
        
        # Extraer el valor numérico del objeto Record
        print(valor_record)
        if valor_record is None or valor_record.get("result") is None:
            return api_response("Formula calculated none", True, {"formula": row["formula"], "value": 0})
        else:
            valor = valor_record.get("result", 0) # Asegúrate de que "result" sea la clave correcta
        valores[f"{funcion}({variable})"] = valor
        formula_latex = re.sub(rf"{funcion}\\left\({variable}\\right\)", str(valor), formula_latex)

    print("Fórmula procesada:", formula_latex)
    expr = parse_latex(formula_latex)
    print("Expresión simbólica:", expr)

        # Evaluar la expresión final
    resultado = float(expr.evalf())

    return api_response("Formula calculated successfully", True, {"formula": row["formula"], "value": resultado})

async def calc_formula_date(db: Connection, formula_id: int, start_date, end_date):
    row = await get_by_id_formula_query(db, formula_id)
    if not row:
        raise HTTPException(status_code=404, detail="Formula not found")

    formula_latex = row["formula"] 
    agregaciones = re.findall(r"(SUM|AVG|COUNT)\\left\((\w+)\\right\)", formula_latex)

    valores = {}

        # Obtener los valores agregados desde la base de datos
    for funcion, variable in agregaciones:
        print(f"Buscando indicador: función={funcion}, variable={variable}")
        
        valor_record = await fetch_indicator_str(db, variable, funcion, start_date, end_date)
        
        # Extraer el valor numérico del objeto Record
        print(valor_record)
        if valor_record is None or valor_record.get("result") is None:
            return api_response("Formula calculated none", True, {"formula": row["formula"], "value": 0})
        else:
            valor = valor_record.get("result", 0)   # Asegúrate de que "result" sea la clave correcta
        valores[f"{funcion}({variable})"] = valor
        formula_latex = re.sub(rf"{funcion}\\left\({variable}\\right\)", str(valor), formula_latex)

    print("Fórmula procesada:", formula_latex)
    expr = parse_latex(formula_latex)
    print("Expresión simbólica:", expr)

        # Evaluar la expresión final
    resultado = float(expr.evalf())

    return api_response("Formula calculated successfully", True, {"formula": row["formula"], "value": resultado})

async def calc_formula_grouped(db, formula_id: int, start_date, end_date, optimal):
    row = await get_by_id_formula_query(db, formula_id)
    if not row:
        raise HTTPException(status_code=404, detail="Formula not found")

    formula_latex = row.get("formula", "")  # Evitar errores si 'formula' no existe
    if not formula_latex:
        return api_response("Formula not found", False, {"formula": None, "values": []})

    # Buscar funciones agregadas en la fórmula
    agregaciones = re.findall(r"(SUM|AVG|COUNT)\\left\((\w+)\\right\)", formula_latex)
    valores = []

    # Obtener los valores agregados desde la base de datos
    for funcion, variable in agregaciones:
        print(f"Buscando indicador: función={funcion}, variable={variable}")
        
        registros = await fetch_indicator_grouped(db, variable, funcion, start_date, end_date)
        if not registros:
            return api_response("Formula calculated none", True, {"formula": formula_latex, "values": []})

        for registro in registros:
            fecha = registro.get("fecha")
            valor = registro.get("result", 0)
            valores.append({"fecha": fecha, "value": valor})

    # Crear DataFrame de Pandas
    df = pd.DataFrame(valores)

    if df.empty:
        return api_response("Formula calculated none", True, {"formula": formula_latex, "values": []})

    # Asegurar tipos correctos
    df["fecha"] = pd.to_datetime(df["fecha"])
    df["value"] = pd.to_numeric(df["value"], errors="coerce")

    # Evaluar la expresión en cada fecha sin interpolación
    formula_procesada = formula_latex
    calculated_values = []

    calculated_values = []
    num_rows = len(df)
    optimal_values = [optimal/num_rows * (i + 1) for i in range(num_rows)]  # Genera 100, 200, 300, ...

    for index, row in enumerate(df.iterrows()):
        _, row_data = row
        formula_temp = formula_procesada

        for funcion, variable in agregaciones:
            formula_temp = re.sub(rf"{funcion}\\left\({variable}\\right\)", str(row_data["value"]), formula_temp)

        try:
            expr = parse_latex(formula_temp)
            calculated_value = float(expr.evalf())
        except Exception as e:
            print(f"Error evaluando fórmula: {e}")
            calculated_value = None

        calculated_values.append({
            "date": row_data["fecha"],
            "value": round(calculated_value,2),
            "optimal": round(optimal_values[index],2)  # Asigna 100, 200, 300, ...
        })

    # Respuesta final
    return calculated_values
