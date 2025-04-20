from sqlalchemy import create_engine, URL

url_object_postgres = URL.create(
    "postgresql+psycopg2",
    username="postgres",
    password="olap22",  
    host="localhost",
    database="postgres",
)

destination_engine = create_engine(url_object_postgres)
