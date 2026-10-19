import pytest
from services.reports.metric_service import convert_date
from datetime import date

def test_convert_date_valid():
    start, end = convert_date("2023-01-01", "2023-01-31")
    assert isinstance(start, date)
    assert isinstance(end, date)
    assert start == date(2023, 1, 1)
    assert end == date(2023, 1, 31)

def test_convert_date_invalid():
    result = convert_date("2023-01-01", "invalid-date")
    assert isinstance(result, dict)
    assert result.get("error") == "Invalid date format. Use YYYY-MM-DD."