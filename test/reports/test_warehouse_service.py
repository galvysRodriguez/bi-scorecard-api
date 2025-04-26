from services.reports.warehouse_service import validation_order_by, validation_order_dir

def test_validation_order_by_true():
    result = validation_order_by("osoa")
    assert result is None

def test_validation_order_by_false():
    result = validation_order_by("id")
    assert result == "id_movimientos"

def test_validation_order_dir_by_true():
    result = validation_order_dir("osoa")
    assert result is None

def test_validation_order_dir_by_false():
    result = validation_order_dir("asc")
    assert result == "asc"