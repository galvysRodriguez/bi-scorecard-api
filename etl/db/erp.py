from sqlalchemy import create_engine, URL

url_object_mysql = URL.create(
    "mysql+pymysql",
    username="root",
    password="",  
    host="localhost",
    database="probando_stock",
    query={"charset": "latin1"},  
)

source_engine = create_engine(url_object_mysql)