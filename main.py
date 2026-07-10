from fastapi import FastAPI

app = FastAPI(title="Dexter Fintech Wallet API")

@app.get("/")
def read_root():
    return {"status": "healthy", "message": "Welcome to Dexter Digital Wallet Backend"}
