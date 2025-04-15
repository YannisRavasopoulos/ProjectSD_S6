# Loop

## Frontend

- [Flutter](https://flutter.dev/)
- Everything is in [frontend/](frontend)
- For features use frontend/feature-name branch

### Install dependencies

```bash
$ ./scripts/install_android.sh
$ ./scripts/config_android.sh
```

### Run the app

```bash
$ cd frontend/
$ flutter pub get
$ flutter emulators --launch flutter_emulator
$ flutter run
```


## Backend

- [FastAPI](https://fastapi.tiangolo.com/)
- Everything is in [backend/](backend)
- For features use backend/feature-name branch

### Install dependencies

```bash
$ cd backend/
$ python -m venv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```

### Run the server

```bash
$ cd backend/
$ source venv/bin/activate
$ uvicorn app.main:app --reload --port 8000
```

## Reports

- Everything is in [reports/](reports)
