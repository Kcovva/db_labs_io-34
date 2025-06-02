from fastapi import FastAPI
import uvicorn
from routers import content, labels, analyze

app = FastAPI(title="Lab6 RESTful API for Media Content Analyzer")

app.include_router(content.router, prefix="/content", tags=["Content"])
app.include_router(labels.router, prefix="/labels", tags=["Labels"])
app.include_router(analyze.router, prefix="/analyze", tags=["Analyze"])

if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)

