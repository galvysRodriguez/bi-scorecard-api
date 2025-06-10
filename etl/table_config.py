from etl.json.sales.sale import SALE
from etl.json.sales.sale_detail import SALE_DETAIL
from etl.json.public.person import PERSON
from etl.json.sales.customer_group import CUSTOMER_GROUP
from etl.json.sales.seller import SELLER
from etl.json.public.city import CITY
from etl.json.public.state import STATE
from etl.json.public.invoice_type import INVOICE_TYPE
from etl.json.public.user import USER
from etl.json.products.product import PRODUCT
from etl.json.products.product_detail import PRODUCT_DETAIL
from etl.json.products.brand import BRAND
from etl.json.products.group import GROUP
from etl.json.products.subgroup import SUBGROUP
from etl.json.products.unit import UNIT
from etl.json.products.presentation import PRESENTATION
from etl.json.purchase.group_provider import GROUP_PROVIDER
from etl.json.purchase.provider import PROVIDER
from etl.json.purchase.purchase_order import PURCHASE_ORDER
from etl.json.purchase.purchase_order_detail import PURCHASE_ORDER_DETAIL
from etl.json.purchase.purchase import PURCHASE
from etl.json.purchase.purchase_detail import PURCHASE_DETAIL
from etl.json.public.resource import RESOURCE
from etl.json.public.profile import PROFILE
from etl.json.public.profile_resource import PROFILE_RESOURCE
from etl.json.warehouse.warehouse import WAREHOUSE
from etl.json.warehouse.move import MOVE
from etl.json.sales.quote import QUOTE
from etl.json.sales.box import BOX_SALE
from etl.json.sales.quote_detail import QUOTE_DETAIL



TABLE_PROCESS = [
    CUSTOMER_GROUP,
    STATE,
    CITY,
    PERSON,
    SELLER,
    WAREHOUSE,
    INVOICE_TYPE,
    PROFILE,
    USER,
    RESOURCE,
    PROFILE_RESOURCE,
    BRAND,
    GROUP,
    SUBGROUP,
    UNIT,
    PRODUCT,
    PRODUCT_DETAIL,
    PRESENTATION,
    BOX_SALE,
    QUOTE,
    QUOTE_DETAIL,
    SALE,
    SALE_DETAIL,
    GROUP_PROVIDER,
    PROVIDER,
    PURCHASE_ORDER,
    PURCHASE_ORDER_DETAIL,
    PURCHASE,
    PURCHASE_DETAIL,
    MOVE
]