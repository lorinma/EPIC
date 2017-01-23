import pandas as pd
from sqlalchemy import create_engine


class Simulation:
    def __init__(self):
        self.engine = create_engine('postgres://postgres:000000@localhost:5432/epic')
        self.trade = pd.read_excel(io="epic.xlsx", sheetname="trade", header=0)
        self.work_method = pd.read_excel(io="epic.xlsx", sheetname="work_method", header=0)
        self.work_method_dependency = pd.read_excel(io="epic.xlsx", sheetname="work_method_dependency", header=0)
        self.space = pd.read_excel(io="epic.xlsx", sheetname="space", header=0)
        self.design = pd.read_excel(io="epic.xlsx", sheetname="design", header=0)
        self.workflow = self.design.rename(columns = {'quantity':'remaining_quantity'})

        self.trade.to_sql(name="trade", con=self.engine, if_exists="append", index=False)
        self.work_method.to_sql(name="work_method", con=self.engine, if_exists="append", index=False)
        self.work_method_dependency.to_sql(name="work_method_dependency", con=self.engine, if_exists="append",
                                           index=False)
        self.space.to_sql(name="space", con=self.engine, if_exists="append", index=False)
        self.design.to_sql(name="design", con=self.engine, if_exists="append", index=False)

        self.workflow.to_sql(name="workflow", con=self.engine, if_exists="append", index=False)


if __name__ == '__main__':
    game = Simulation()