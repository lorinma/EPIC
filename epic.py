import pandas as pd
from sqlalchemy import create_engine


class Simulation:
    def __init__(self):
        self.engine = create_engine('postgresql://localhost:5432/epic')
        self.trade = pd.read_excel(io="epic.xlsx", sheetname="Trade", header=0)
        self.work_method = pd.read_excel(io="epic.xlsx", sheetname="WorkMethod", header=0)
        self.work_method_dependency = pd.read_excel(io="epic.xlsx", sheetname="WorkMethodDependency", header=0)
        self.space = pd.read_excel(io="epic.xlsx", sheetname="Space", header=0)
        self.design = pd.read_excel(io="epic.xlsx", sheetname="Design", header=0)

        self.trade.to_sql(name="Trade", con=self.engine, if_exists="append", index=False)
        self.work_method.to_sql(name="WorkMethod", con=self.engine, if_exists="append", index=False)
        self.work_method_dependency.to_sql(name="WorkMethodDependency", con=self.engine, if_exists="append",
                                           index=False)
        self.space.to_sql(name="Space", con=self.engine, if_exists="append", index=False)
        self.design.to_sql(name="Design", con=self.engine, if_exists="append", index=False)


if __name__ == '__main__':
    game = Simulation()
    print(game.design)
