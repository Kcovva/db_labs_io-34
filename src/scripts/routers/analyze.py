from fastapi import APIRouter
from analyze import analyze_text, AnalyzeInput

router = APIRouter()

@router.post("/")
async def analyze(data: AnalyzeInput):
    tags = analyze_text(data)
    return {"hashtags": tags}
