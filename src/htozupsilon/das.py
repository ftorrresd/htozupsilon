from __future__ import annotations

from dbs.apis.dbsClient import DbsApi


def get_files(dataset: str) -> list[str]:
    dbs = DbsApi("https://cmsweb.cern.ch/dbs/prod/global/DBSReader")
    files = []
    for f in dbs.listFiles(dataset=dataset):
        if f:
            files.append(f["logical_file_name"].strip())

    return files
