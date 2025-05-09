from __future__ import annotations

from pydantic import BaseModel

from .sample import Sample


class Configuration(BaseModel):
    samples: list[Sample]
