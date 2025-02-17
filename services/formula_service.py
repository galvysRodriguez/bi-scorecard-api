from fastapi import HTTPException
from asyncpg import Connection
from utils.api_response import api_response
from repositories.formula_repo import add_formula_query, get_formula_query, get_by_id_formula_query
from services.indicator_service import fetch_indicator, fetch_indicator_value, fetch_indicator_str
from schemas.target import FormulaBase
from sympy.parsing.latex import parse_latex
from sympy import Symbol
import re

async def get_formulas(db: Connection):
    row = await get_formula_query(db)
    if not row:
        return api_response("Formula not found", False)
    return api_response("Formula retrieved successfully", True, dict(row))

async def add_formula(db: Connection, formula_data: FormulaBase):
    row = await add_formula_query(db, formula_data)
    return api_response("Formula created successfully", True, dict(row))

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

    formula_latex = row["formula"]  # Se asume que la columna en la BD se llama "formula"

    
        # Detectar agregaciones (SUM, AVG, COUNT) y las variables asociadas
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

  