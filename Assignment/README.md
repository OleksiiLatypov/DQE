
# Assignment

1. Create virtual enviroment
```
python -m venv venv
source venv/bin/activate
```

2. Install the dependencies with:
```
pip install -r requirements.txt
```

3. Run the PostgreSQL Docker Container
```
docker run --name postgres_container \
  -e POSTGRES_DB=assignment \
  -e POSTGRES_USER=postgres_user \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -d postgres:latest
```

4. Run the script
```
python main.py
```

