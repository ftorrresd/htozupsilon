from __future__ import annotations

from pydantic import BaseModel


class Sample(BaseModel):
    das_name: str
