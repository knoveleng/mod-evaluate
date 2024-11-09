#!/bin/bash

# Define variables
CONFIG_DIR="../mod/configs/1.5B"
PROMPT_TYPE="qwen25-math-cot"

# Function to run merging and evaluation
run_merge_and_eval() {
    method=$1
    config_file=$2
    merge_script=$3
    output_dir=$4

    echo "Running merge for method: $method"
    python "$merge_script" --config "$CONFIG_DIR/${config_file}" --out_path "$output_dir"
    
    echo "Running evaluation for method: $method"
    export CUDA_VISIBLE_DEVICES="0"
    MODEL_NAME_OR_PATH="$output_dir"
    bash sh/eval.sh $PROMPT_TYPE $MODEL_NAME_OR_PATH
    
    echo "Cleaning up"
    rm -r "$MODEL_NAME_OR_PATH/"
}

# MoD
run_merge_and_eval "mod" "mod_config.yml" "../mod/scripts/mod.py" "qwen2.5-1.5B-mod"

# Linear
run_merge_and_eval "linear" "linear_config.yml" "../mod/scripts/common_mergekit.py" "qwen2.5-1.5B-linear"

# Slerp
run_merge_and_eval "slerp" "slerp_config.yml" "../mod/scripts/common_mergekit.py" "qwen2.5-1.5B-slerp"

# DARE
run_merge_and_eval "dare" "dare_config.yml" "../mod/scripts/common_mergekit.py" "qwen2.5-1.5B-dare"

# TIes
run_merge_and_eval "ties" "ties_config.yml" "../mod/scripts/common_mergekit.py" "qwen2.5-1.5B-ties"

# Task Arithmetic
run_merge_and_eval "task_arithmetic" "task_arithmetic_config.yml" "../mod/scripts/common_mergekit.py" "qwen2.5-1.5B-task-arithmetic"

echo "All merging and evaluation processes completed."

