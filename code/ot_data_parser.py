import os
import argparse
import pyarrow
import pyarrow.parquet as pq
import pyarrow.compute as pc
import pandas as pd

# import modin.pandas as pd
import numpy as np
import pyarrow.dataset as ds


class EvidenceParser:
    """
    A class to parse evidence data from evidence, targets and diseases datasets.
    """

    def __init__(self, datafile_path, *fields):
        self.datafile_path = datafile_path
        self.evidence_data_fields = list(fields)
        self.target_data_fields = ["id", "approvedSymbol"]
        self.diseases_data_fields = ["id", "name"]
        self._evidence_data_path = os.path.join(self.datafile_path, "evidence")
        self._target_data_path = os.path.join(self.datafile_path, "targets")
        self._diseases_data_path = os.path.join(self.datafile_path, "diseases")
        self.result = None

    def read_data(self, raw_data_path, data_fields):
        """
        Reads set of parquet files stored at directory, converts it to pandas dataframe.
        Parameters:
            raw_data_path : Directory where parquet files are stored
            data_fields : Fields to extract from parquet file
        """
        try:
            raw_dataset = ds.dataset(raw_data_path, format="parquet")
            raw_data = raw_dataset.scanner(columns=data_fields).to_table()
            raw_df = raw_data.to_pandas()
            return raw_df
        except Exception as ex:
            print(ex)

    def parse_data(self):
        """
        Parses evidence data, calculates median score, keeps top 3 score value
        for each targetId, diseasesId pair, adds approvedSymbol field from target,
        adds disease name field from diseases dataset and finally sorts the result
        dataset on median_score value.

        Parameters:
            None

        Returns:
            Dataframe containing results.

        """
        # Read evidence data to pyarrow table and then to pandas dataframe
        print("\n!!!! Reading Evidence Data")
        evidence_df = self.read_data(
            self._evidence_data_path, self.evidence_data_fields
        )
        print("\n!!!! Evidence Data read successfully")

        # Read targets data to pyarrow table and then to pandas dataframe
        print("\n!!!! Reading Target Data")
        target_df = self.read_data(self._target_data_path, self.target_data_fields)
        print("\n!!!! Target data read successfully")

        # Read diseases data to pyarrow table and then to pandas dataframe
        print("\n!!!! Reading Diseases Data")
        diseases_df = self.read_data(
            self._diseases_data_path, self.diseases_data_fields
        )
        print("\n!!!! Diseases data read successfully")

        # Sort score
        print("\n!!!! Sorting score")
        evidence_df_sorted = (
            evidence_df.groupby(["targetId", "diseaseId"])[["score"]]
            .agg(lambda s: sorted(list(s), reverse=True))
            .reset_index()
        )

        print("\n!!!! Joining Target and Diseases datasets")
        # Join with target
        target_t3_ms = pd.merge(
            evidence_df_sorted, target_df, left_on="targetId", right_on="id"
        )

        # Join with disease
        disease_t3_ms = pd.merge(
            target_t3_ms, diseases_df, left_on="diseaseId", right_on="id"
        )
        del disease_t3_ms["id_x"]
        del disease_t3_ms["id_y"]

        print("\n!!!! Calculation Medain Score")
        # Calculate median score
        disease_t3_ms["median_score"] = disease_t3_ms.score.apply(np.median)

        # Store top 3 values only for score
        disease_t3_ms["score"] = disease_t3_ms.score.apply(lambda x: x[:3])

        print("\n!!!! Sorting data based on median_score")
        # Sort ascending on median_score
        disease_t3_ms = disease_t3_ms.sort_values("median_score").reset_index(drop=True)

        self.result = disease_t3_ms

    def export_data(self, out_file):
        """
        Exports the result to json file
        Parameters:
            out_file: Name of the file to export data to

        Returns: None
        """
        print(
            "\n!!!! Exporting Results to JSON file : {outfile}".format(outfile=out_file)
        )
        self.result.to_json(out_file, orient="records")
        print("\n!!!! Data exported to {outfile}".format(outfile=out_file))

    def target_target_pair(self):
        df1 = self.result
        df2 = self.result
        # Join on targetID
        tt_pair = pd.merge(
            df1, df2, left_on="targetId", right_on="targetId"
        )

        # Remove all the rows having same diseasesID
        tt_pair_dif_diseases = tt_pair[tt_pair['diseaseId_x'] != tt_pair['diseaseId_y']]

        tt_pair_count = tt_pair_dif_diseases['targetId'].count()/2
        print ("Target Target Pair sharing connection with atleast two diseases {tt_pair_count}".format(tt_pair_count=int(tt_pair_count)))

if __name__ == "__main__":
    ARG_PARSER = argparse.ArgumentParser()
    ARG_PARSER.add_argument(
        "--datadir",
        help="Directory where evidence, targets and diseases are stored",
        default="data",
    )
    ARG_PARSER.add_argument(
        "--outfile",
        help="The name of the output file where results will be stored",
        default="evidence_mt3.json",
    )

    CLI_ARGS = ARG_PARSER.parse_args()
    data_dir = CLI_ARGS.datadir
    outfile = CLI_ARGS.outfile

    print(data_dir, outfile)

    ep = EvidenceParser(data_dir, "diseaseId", "targetId", "score")
    ep.parse_data()
    ep.export_data(outfile)
    ep.target_target_pair()
