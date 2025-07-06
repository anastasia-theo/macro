import pandas as pd

def categorize_m_value(m_value):
    """
    Assigns labels to m-values based on the following criteria:
    - If m_value > 1, returns "1"
    - If m_value < -1, returns "-1"
    - If -1 <= m_value <= 1, returns "0"
    """
    if m_value > 0.8:
        return "2"
    elif m_value < -0.8:
        return "0"
    else:
        return "1"

def process_bed_file(input_file, output_file):
    """
    Processes a BED file, categorizing the m-value columns (4 and 13)
    and writing the modified data to a new BED file.
    """
    try:
        # Read the BED file into a Pandas DataFrame
        df = pd.read_csv(input_file, sep='\t', header=None)

        # Apply the categorization function to columns 4 and 13 (index 3 and 12)
        df[3] = df[3].apply(lambda x: categorize_m_value(x) if isinstance(x, (int, float)) else x)
        print(df[3].head())  # Debugging line to check the original values in column 12
        # df[12] = df[12].apply(lambda x: categorize_m_value(x) if isinstance(x, (int, float)) else (x if x == "." else x))
        df[12] = df[12].apply(lambda x: categorize_m_value(float(x)) if isinstance(x, str) and x != "." else x)

        print(df[12].head(10))  # Debugging line to check the original values in column 12

        # Write the modified DataFrame to a new BED file
        df.to_csv(output_file, sep='\t', header=None, index=False)

        print(f"Successfully processed {input_file} and saved to {output_file}")

    except FileNotFoundError:
        print(f"Error: Input file {input_file} not found.")
    except Exception as e:
        print(f"An error occurred: {e}")


input_bed_file = "/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/bed_intersect/EGR1_H3K27ac_IL4/EGR1_H3K27ac_IL4_ctrl_overlap.bed"  
output_bed_file = "/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/bed_intersect/EGR1_H3K27ac_IL4/EGR1_H3K27ac_IL4_ctrl_overlap_modified_008.bed"    
process_bed_file(input_bed_file, output_bed_file)