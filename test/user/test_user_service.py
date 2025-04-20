import pytest
from services.user_service import verify_password

def test_user_verify_password_true():
    result = verify_password("123456", "7c4a8d09ca3762af61e59520943dc26494f8941b")
    assert result is True, "Debería encontrar 1 registro existente"

def test_user_verify_password_false():
    result = verify_password("1234567", "7c4a8d09ca3762af61e59520943dc26494f8941b")
    assert result is False, "Debería encontrar 0 registro existente"