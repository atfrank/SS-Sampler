# SS-Sampler: A Simple Secondary Structure Sampling Tool
* Sampling is done using a genetic algorithm and simple hydrogen-bonding and base-stacking fitness function
# Installation:

```
conda create -n ss-sampler python=3.7
conda activate ss-sampler
pip install geneticalgorithm matplotlib pandas more-itertools
```

# Usage:
```
usage: ga_sampler.py [-h] -s SEQUENCE -n N_STEMS [-i ITERATIONS]
                     [-p POPULATIONS] [-o OUTPUT_PREFIX]

optional arguments:
  -h, --help            show this help message and exit
  -s SEQUENCE, --sequence SEQUENCE
                        RNA Sequence
  -n N_STEMS, --n_stems N_STEMS
                        maximum number of stems
  -i ITERATIONS, --iterations ITERATIONS
                        number of independent GA iterations
  -p POPULATIONS, --populations POPULATIONS
                        GA population
  -o OUTPUT_PREFIX, --output_prefix OUTPUT_PREFIX
                        GA population
```

# Run SS-Sampler
```shell
# TAR RNA; 10 iterations; maximum number of stems set to 4
python ga_sampler.py -s 'GGCAGAUCUGAGCCUGGGAGCUCUCUGCC'  -i 10 -n 4 -o output/user
```

# COMMERCIAL USE LICENSE:

If you are interested in commercial licensing of these applications (clinical, operational, etc.) please contact the University of Michigan Office of Technology Transfer for a quote and licensing options.

Drew Bennett - https://techtransfer.umich.edu/team/drew-bennett/

or

techtransfer@umich.edu
