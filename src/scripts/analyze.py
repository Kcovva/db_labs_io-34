import re
import string
from pydantic import BaseModel

class AnalyzeInput(BaseModel):
    text: str

#Повертає список хештегів (без #), які є у вхідному тексті.
def analyze_text(data: AnalyzeInput) -> list[str]:
    raw_tags = re.findall(r'#(\w+)', data.text)

    # Очищаємо теги від пунктуації
    tags = [tag.strip(string.punctuation) for tag in raw_tags]

    # Прибираємо дублі
    unique_tags = list(set(tags))

    return unique_tags
