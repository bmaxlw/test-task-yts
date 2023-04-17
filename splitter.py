import math, pandas as pd

def split_csv(
    # source_csv_path   - path to the source csv file
    # target_dir_path   - path to the folder where splitted csv will be stored
    # split_to          - number of partitions, source csv has to be split to
                   source_csv_path: str, 
                   target_dir_path: str,
                   split_to: int=2,
                   ) -> None:
    base_csv=pd.read_csv(source_csv_path)
    start,stop,step=0,0,math.ceil(len(base_csv)/split_to)
    for _ in range(split_to):
        stop=start+step 
        target_csv=base_csv[start:stop]
        target_csv.to_csv(f"{target_dir_path}/{start}-{stop}.csv", index=False)
        start=stop

if __name__ == "__main__":
    SOURCE_CSV_PATH,TARGET_DIR_PATH,NUM_OF_PARTITIONS="./sends.csv","./sends",4
    split_csv(SOURCE_CSV_PATH,TARGET_DIR_PATH,NUM_OF_PARTITIONS)